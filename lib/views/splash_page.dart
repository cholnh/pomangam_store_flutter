import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animation_set/widget/transition_animations.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:pomangam/_bases/i18n/i18n.dart';
import 'package:pomangam/_bases/initalizer/initializer.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/_bases/util/toast_utils.dart';
import 'package:pomangam/domains/version/version.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/providers/version/version_model.dart';
import 'package:pomangam/views/mobile/pages/_bases/error_page.dart';
import 'package:pomangam/views/mobile/pages/_bases/base_page.dart' as MobileBasePage;
import 'package:pomangam/views/mobile/pages/home/order/order_status_board_page.dart';
import 'package:pomangam/views/mobile/pages/sign/sign_in_page.dart' as MobileSignInPage;
import 'package:pomangam/views/mobile/widgets/_bases/custom_dialog_utils.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  AppUpdateInfo _updateInfo;

  String version;
  String buildNumber;

  @override
  void initState() {
    _readyInitialize(); // 초기화 준비
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(332 / 360),
              child: Image(
                image: const AssetImage('assets/logo_transparant.png'),
                width: 150,
                height: 150,
              ),
            ),
            alignment: Alignment.center,
          ),
          Container(
            child: Text(
              '${Messages.companyName}',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).backgroundColor
            )),
            margin: const EdgeInsets.only(bottom: 65),
            alignment: Alignment.bottomCenter,
          ),
          Container(
            child: YYThreeLine(),
            margin: const EdgeInsets.only(bottom: 40),
            alignment: Alignment.bottomCenter,
          ),
          if (version != null) Container(
            child: Text(
              '$version+$buildNumber',
              style: TextStyle(
                fontSize: 13.0,
                color: Theme.of(context).backgroundColor
              )),
            margin: const EdgeInsets.only(bottom: 15),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Future<void> _updateChecker() async {
    if(!kIsWeb) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      setState(() {
        this.version = packageInfo.version;
        this.buildNumber = packageInfo.buildNumber;
      });

      // Todo. iOS 업데이터 구현 필요
      if(Platform.isAndroid) {
        await InAppUpdate.checkForUpdate().then((info) {
          _updateInfo = info;
          logWithDots('checkForUpdate', 'InAppUpdate.checkForUpdate', 'success');
        }).catchError((e) => _showError(e, where: 'checkForUpdate'));

        Version version = await context.read<VersionModel>().fetch();
        if(version != null) {
          final int currentVersion = int.parse(buildNumber);
          final int latestVersion = version.latestVersion;
          final int minimumVersion = version.minimumVersion;

          if(_updateInfo?.updateAvailable ?? false) {
            if(latestVersion > currentVersion && currentVersion >= minimumVersion) {
              // 백그라운드 Update
              await InAppUpdate.startFlexibleUpdate().then((_) {
                logWithDots('startFlexibleUpdate', 'InAppUpdate.startFlexibleUpdate', 'success');
              }).catchError((e) async {
                logWithDots('initialize', 'InAppUpdate.startFlexibleUpdate', 'failed', error: e);
                await DialogUtils.dialogYesOrNo(context, '새로운 업데이트가 있습니다.\n업데이트 하시겠습니까?', height: 180,
                  onConfirm: (_) {
                    _playStore();
                    logWithDots('initialize', 'InAppUpdate.startFlexibleUpdate.b-plan', 'success');
                  });
              });
            } else if(minimumVersion > currentVersion) {
              // 강제 Update
              await InAppUpdate.performImmediateUpdate()
                  .then((_) => logWithDots('performImmediateUpdate', 'InAppUpdate.performImmediateUpdate', 'success'))
                  .catchError((e) async {
                logWithDots('initialize', 'InAppUpdate.performImmediateUpdate', 'failed', error: e);
                await DialogUtils.dialog(context, '필수 업데이트가 있습니다.\n업데이트 하시겠습니까?', height: 180, whenComplete: (_) {
                  _playStore();
                  logWithDots('initialize', 'InAppUpdate.performImmediateUpdate.b-plan', 'success');
                });
              });
            }
          }
        }
      }
    }
  }

  void _playStore() {
    LaunchReview.launch(
        androidAppId: 'com.mrporter.flutter.store.pomangam',
        iOSAppId: ''
    );
  }

  void _readyInitialize() async {
    await _updateChecker();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      Get.find<Initializer>(tag: 'initializer')
        .initialize(
          onDone: _onDone,
          onServerError: _onServerError,
        ).catchError((err) => _onServerError());
    });
  }

  void _onDone() {
    Get.offAll(
      context.read<SignInModel>().isSignIn()
        ? MobileBasePage.BasePage()
        : MobileSignInPage.SignInPage(),
      transition: Transition.cupertino
    );
  }

  void _onServerError()
  => Get.offAll(ErrorPage(contents: 'Server Down'));

  void _showError(dynamic exception, {String where}) {
    logWithDots('initialize', 'InAppUpdate.$where', 'failed', error: exception);
    ToastUtils.showToast(msg: exception.toString());
  }
}
