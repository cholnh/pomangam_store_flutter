import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/constants/endpoint.dart';
import 'package:pomangam/_bases/constants/initial_value.dart';
import 'package:pomangam/_bases/initalizer/data/delivery_detail_site_data_initializer.dart';
import 'package:pomangam/_bases/initalizer/data/delivery_site_data_initializer.dart';
import 'package:pomangam/_bases/initalizer/data/order_time_data_initializer.dart';
import 'package:pomangam/_bases/key/shared_preference_key.dart' as s;
import 'package:pomangam/_bases/network/api/api.dart';
import 'package:pomangam/_bases/network/domain/server_health.dart';
import 'package:pomangam/_bases/network/domain/token.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/domains/fcm/fcm_token.dart';
import 'package:pomangam/domains/fcm/fcm_owner_token_request.dart';
import 'package:pomangam/domains/user/enum/sign_in_state.dart';
import 'package:pomangam/domains/user/owner.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Initializer {

  Api api = Get.find(tag: 'api');
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool _isServerDown;
  bool _successNetwork;
  bool _successLocale;
  bool _successNotification;
  bool _successToken;
  bool _successModelData;
  bool _isDestinationNotSavedError;

  Future initialize({
    Function onDone,
    Function onServerError,
    Function destinationNotSavedHandler,
  }) async {
    // Get.context.read<SignInModel>().signIn(id: 'store_1', password: 'store_1_pw');
    // (await SharedPreferences.getInstance()).clear();
    try {
      int fallbackCount = 0;
      _checkerClear();
      do {
        await _checkNetwork();
        await _checkLocale();
        await _checkToken();
        await _checkNotification();
        await _checkModelData();
        if(_isCheckerAllSuccess()) {
          break;
        } else {
          _printChecker();
          log(
              'fallback try...${fallbackCount+1} (delay: ${fallbackCount*500}millis)',
              name: 'Initializer.initialize',
              time: DateTime.now()
          );
          await Future.delayed(Duration(milliseconds: fallbackCount*500));
        }
      } while(++fallbackCount < Endpoint.fallbackTotalCount);

      if(_isCheckerAllSuccess()) {
        if(_isDestinationNotSavedError) {
          logWithDots('destinationNotSavedError', 'Initializer.initialize', 'failed');
          destinationNotSavedHandler();
          return;
        } else {
          if(onDone != null) onDone();
        }
      } else {
        onServerError();
      }
      logWithDots('initialize', 'Initializer.initialize', 'success');
    } catch(error) {

      logWithDots('initialize', 'Initializer.initialize', 'failed', error: error);
      onServerError();
    }
  }

  Future<bool> _checkNetwork() async
  => _successNetwork = _successNetwork ? true : ! await initializeNetwork();

  Future<bool> _checkLocale() async
  => _successLocale = _successLocale ? true : await initializeLocale(locale: Localizations.localeOf(Get.context));

  Future<bool> _checkNotification() async
  => _successNotification = _successNotification ? true : await _initializeNotification();

  Future<bool> _checkToken() async
  => _successToken = _successToken ? true : await _initializeToken();

  Future<bool> _checkModelData() async
  =>  _successModelData = _successModelData ? true : await _initializeModelData();

  Future<bool> initializeNetwork() async
  => !await logProcess(name: 'initializeNetwork', function: () async => !(_isServerDown = await _serverStatus()));

  Future<bool> initializeLocale({Locale locale}) async
  => logProcess(name: 'initializeLocale', function: () {
        api.setResourceLocale(locale: locale);
        return true;
      });

  Future<bool> initializeNotification() async {
    _isServerDown = await initializeNetwork();
    return _initializeNotification();
  }

  Future<bool> _initializeNotification() async
  => logProcess(name: 'initializeNotification', function: () async {
      if(_isServerDown) return false;
      if(await _canInitializeNotification()) {
        bool isSuccess = await _issueFcmToken();
        _fcmConfigure();
        return isSuccess;
      } else {
        return true;
      }
  });

  Future<bool> _canInitializeNotification() async {
    String id = await loadInPrefs(s.userId);
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS) &&
        (id != null && id.isNotEmpty);
  }

  Future<bool> initializeToken() async {
    _isServerDown = await initializeNetwork();
    return _initializeToken();
  }

  Future<bool> _initializeToken() async
  => logProcess(name: 'initializeToken', function: () async {
      if(_isServerDown) return false;
      Token token = await api.oauthTokenRepository.loadToken();
      if(token != null) {
        token
        ..saveToDisk()
        ..saveToDioHeader();

        String id = await loadInPrefs(s.userId);
        if(token.tokenMode == TokenMode.LOGIN && id.isNotEmpty) {
          Owner ownerInfo = Owner.fromJson((await api.get(url: '/store/owners/$id')).data);
          Get.context.read<SignInModel>()
          ..ownerInfo = ownerInfo
          ..signInState = SignInState.SIGNED_IN;
          saveInPrefs(s.idxCurrentStore, ownerInfo.idxStore);
        }
        return true;
      }
      return false;
  });

  Future<bool> initializeModelData() async {
    _isServerDown = await initializeNetwork();
    return _initializeModelData();
  }

  Future<bool> _initializeModelData() async
  => logProcess(name: 'initializeModelData', function: () async {
      if(_isServerDown) return false;

      SharedPreferences pref = await SharedPreferences.getInstance();
      int sIdx = Get.context.read<SignInModel>()?.ownerInfo?.idxStore ?? pref.getInt(s.idxCurrentStore);
      int dIdx = pref.getInt(s.idxDeliverySite);
      int ddIdx = pref.getInt(s.idxDeliveryDetailSite);

      print(Get.context.read<SignInModel>()?.ownerInfo);

      if(sIdx == null) {
        return true;
      }

      await orderTimeDataInitialize(dIdx: dIdx);
      await deliverySiteDataInitialize(sIdx: sIdx, dIdx: dIdx);
      await deliveryDetailSiteDataInitialize(ddIdx: ddIdx);

      return true;
  });

  /// ## _serverStatus
  ///
  /// 서버 health indicator 가 반환하는 server health status 검사
  ///
  Future<bool> _serverStatus() async {
    ServerHealth health = await api.healthCheck();
    switch(health) {
      case ServerHealth.UP:
        return false;
      case ServerHealth.DOWN:
      case ServerHealth.MAINTENANCE:
      case ServerHealth.UNKNOWN:
    }
    return true;
  }

  /// ## _issueFcmToken
  ///
  /// fcm token 요청 후 내부 db 에 저장, 서버 db 에 저장 -> 서버에서 발급한 fidx 내부 db 에 저장.
  ///
  Future<bool> _issueFcmToken() async {
    try{
      await saveInPrefs(s.idxFcmToken, await _postFcmToken(token: await getFcmToken()));
      logWithDots('_issueFcmToken', 'Initializer._issueFcmToken', 'success');
    } catch(error) {
      logWithDots('_issueFcmToken', 'Initializer._issueFcmToken', 'failed');
      return false;
    }
    return true;
  }

  Future<String> getFcmToken() async {
    String fcmToken = await _firebaseMessaging.getToken() ?? getDeviceDetailsTempToken();
    return fcmToken;
  }

  void _fcmConfigure() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  Future<int> _postFcmToken({String token}) async {
    FcmOwnerTokenRequest requestData = FcmOwnerTokenRequest(token: token);
    requestData.id = await loadInPrefs(s.userId);

    FcmToken fcmToken;
    try {
      fcmToken = FcmToken.fromJson((await api.post(
          url: '/fcms/owner',
          data: requestData
      )).data);
    } catch (e) {
      try {
        fcmToken = FcmToken.fromJson((await api.post(
            url: '/fcms/owner',
            data: FcmOwnerTokenRequest(token: token)
        )).data);
      } catch (e) {
        throw Exception;
      }
    }
    if(fcmToken?.idx == null) throw Exception;
    return fcmToken.idx;
  }

  Future<void> deleteFcmTokenClientInfo() async {
    int fIdx = await loadInPrefs(s.idxFcmToken);
    api.delete(url: '/fcms/owner/$fIdx');
  }

  bool _isCheckerAllSuccess()
  => _successNetwork && _successLocale && _successNotification && _successToken && _successModelData;

  void _printChecker()
  => print('_successNetwork: $_successNetwork / _successLocale: $_successLocale / _successNotification: $_successNotification / _successToken: $_successToken / _successModelData: $_successModelData');

  void _checkerClear() {
    _isServerDown = false;
    _successNetwork = false;
    _successLocale = false;
    _successNotification = false;
    _successToken = false;
    _successModelData = false;
    _isDestinationNotSavedError = false;
  }

  static Future<dynamic> loadInPrefs(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  static Future<bool> saveInPrefs(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(value is int) {
      return prefs.setInt(key, value);
    } else if(value is double) {
      return prefs.setDouble(key, value);
    } else if(value is String) {
      return prefs.setString(key, value);
    } else if(value is bool) {
      return prefs.setBool(key, value);
    } else if(value is List<String>) {
      return prefs.setStringList(key, value);
    }
    return false;
  }

  static Future<void> clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<void> printPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for(String key in prefs.getKeys()) {
      print('key: $key / value: ${prefs.get(key)}');
    }
  }
}