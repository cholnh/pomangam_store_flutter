import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/initalizer/initializer.dart';
import 'package:pomangam/_bases/network/api/network_service.dart';
import 'package:pomangam/_bases/network/domain/server_health.dart';
import 'package:pomangam/_bases/network/domain/token.dart';
import 'package:pomangam/_bases/network/repository/authorization_repository.dart';
import 'package:pomangam/_bases/network/repository/resource_repository.dart';
import 'package:pomangam/domains/_bases/page_request.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_dialog_utils.dart';
import 'package:pomangam/views/splash_page.dart';
import 'package:provider/provider.dart';

class Api implements NetworkService {

  final OauthTokenRepository oauthTokenRepository = Get.find(tag: 'oauthTokenRepository');
  final ResourceRepository resourceRepository = Get.find(tag: 'resourceRepository');

  /// ## initialize - deprecated(Initializer 사용)
  ///
  /// [locale] 변경할 locale
  /// Oauth2.0 토큰 초기화, resource header 의 locale 변경.
  /// SharedPreference 에 저장되어 있는 token 을 우선적으로 load 함.
  /// load 된 token 은 서버에 보내져 유효한 token 인지 아닌지 검사를 진행.
  /// SharedPreference 에 토큰이 저장되어 있지 않다면 guest token 발급하여 load.
  /// 발급 된 토큰은 네트워크 헤더와 SharedPreference 내부에 저장됨.
  /// Dio Network Exception 발생 시 외부로 Exception 전달(내부 try-catch 설정 안 함)
  /// 외부 Repository 구현 시, try-catch 구현 or 외부로 전파 필요.
  ///
  @deprecated
  @override
  Future initialize({Locale locale}) async {
    Token token = await oauthTokenRepository.loadToken(); // 외부 error 발생 가능
    if(token != null) {
      token
        ..saveToDioHeader() // 네트워크 헤더에 저장 : Authorization Bearer {access_token}
        ..saveToDisk();     // SharedPreference 내부에 저장
    }
    if(locale != null) {
      setResourceLocale(locale: locale);
    }
  }

  /// ## healthCheck
  ///
  /// 서버 health 상태 반환
  ///
  Future<ServerHealth> healthCheck() => oauthTokenRepository.serverHealthCheck();


  /// ## setResourceLocale
  ///
  /// [locale] 변경할 locale
  /// resource header 의 locale 변경.
  ///
  Api setResourceLocale({Locale locale = const Locale('ko')}) {
    resourceRepository.setResourceLocale(locale); // resource locale 변경
    return this;
  }


  /// ## get
  ///
  /// [url] http 요청 url
  /// Http **GET** method call
  /// Dio Network Exception 발생 시 외부로 Exception 전달(내부 try-catch 설정 안 함)
  /// 외부 Repository 구현 시, try-catch 구현 or 외부로 전파 필요.
  ///
  @override
  Future<Response> get({
    @required String url,
    PageRequest pageRequest,
    Function fallBack,
    bool isOnError = true
  }) {
    if(pageRequest != null) {
      url += url.contains('?') ? '&$pageRequest' :  '?$pageRequest';
    }
    Function logic = () => resourceRepository.get(url: url);
    return logic().catchError(isOnError ? (error) => _errorHandler(error, fallBack == null ? logic : fallBack) : (error){});
  }


  /// ## post
  ///
  /// [url] http 요청 url
  /// [jsonData] http body data(raw JSON[application/json])
  /// Http **POST** method call (데이터 입력)
  /// Dio Network Exception 발생 시 외부로 Exception 전달(내부 try-catch 설정 안 함)
  /// 외부 Repository 구현 시, try-catch 구현 or 외부로 전파 필요.
  ///
  @override
  Future<Response> post({
    @required String url,
    dynamic data,
    bool isOnError = true
  }) {
    Function logic = () => resourceRepository.post(url: url, data: data);
    return logic().catchError(isOnError ? (error) => _errorHandler(error, logic) : (error){});
  }


  /// ## patch
  ///
  /// [url] http 요청 url
  /// [jsonData] http body data(raw JSON[application/json])
  /// Http **PATCH** method call (데이터 수정)
  /// Dio Network Exception 발생 시 외부로 Exception 전달(내부 try-catch 설정 안 함)
  /// 외부 Repository 구현 시, try-catch 구현 or 외부로 전파 필요.
  ///
  @override
  Future<Response> patch({
    @required String url,
    dynamic data,
    bool isOnError = true
  }) {
    Function logic = () => resourceRepository.patch(url: url, data: data);
    return logic().catchError(isOnError ? (error) => _errorHandler(error, logic) : (error){});
  }


  /// ## put **deprecated** patch 사용 권장
  ///
  /// [url] http 요청 url
  /// [jsonData] http body data(raw JSON[application/json])
  /// Http **PUT** method call
  /// Dio Network Exception 발생 시 외부로 Exception 전달(내부 try-catch 설정 안 함)
  /// 외부 Repository 구현 시, try-catch 구현 or 외부로 전파 필요.
  ///
  @deprecated
  @override
  Future<Response> put({
    @required String url,
    dynamic data,
    bool isOnError = true
  }) {
    Function logic = () => resourceRepository.put(url: url, data: data);
    return logic().catchError(isOnError ? (error) => _errorHandler(error, logic) : (error){});
  }


  /// ## delete
  ///
  /// [url] http 요청 url
  /// Http **DELETE** method call (데이터 삭제)
  /// Dio Network Exception 발생 시 외부로 Exception 전달(내부 try-catch 설정 안 함)
  /// 외부 Repository 구현 시, try-catch 구현 or 외부로 전파 필요.
  ///
  @override
  Future<Response> delete({
    @required String url,
    bool isOnError = true
  }) {
    Function logic = () => resourceRepository.delete(url: url);
    return logic().catchError(isOnError ? (error) => _errorHandler(error, logic) : (error){});
  }

  _errorHandler(error, logic) async {
    // 토큰 재 요청
    if(error is DioError) {
      print('[Api _errorHandler] $error');
      switch(error?.response?.statusCode) {
        case HttpStatus.unauthorized: // 401
          try {
            await Get.find<Initializer>(tag: 'initializer').initializeToken();
            //if(logic != null) logic();
          } catch(e) {
            print('shutdown - signout $e');
            SignInModel signInModel = Get.context.read();
            DialogUtils.dialog(Get.context, '접근거부로 인해 로그아웃됩니다.', height: 180, onPressed: (dialogContext) async {
              if(!signInModel.isSigningOut) {
                await signInModel.signOut();
                Get.offAll(SplashPage(), transition: Transition.fade);
                if( Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }
              }
            });
          }
          // await Get.find(tag: 'initializer')
          //   .initialize(
          //     onDone: logic,
          //     onServerError: () => print('[Debug] DioCore.interceptor!!server down..'),
          //   );
          break;
        default:
          break;
      }
    }
  }
}