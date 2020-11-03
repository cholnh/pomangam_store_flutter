import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animation_set/widget/transition_animations.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:pomangam/_bases/i18n/i18n.dart';
import 'package:pomangam/_bases/initalizer/initializer.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/views/mobile/pages/_bases/error_page.dart';
import 'package:pomangam/views/mobile/pages/_bases/base_page.dart' as MobileBasePage;
import 'package:pomangam/views/mobile/pages/sign/sign_in_page.dart' as MobileSignInPage;
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  String version;
  String buildNumber;

  @override
  void initState() {
    if(!kIsWeb) {
      _appVersion();
    }
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

  void _readyInitialize() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      Get.find<Initializer>(tag: 'initializer')
        .initialize(
          onDone: _onDone,
          onServerError: _onServerError,
        ).catchError((err) => _onServerError());
    });
  }

  void _appVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      this.version = packageInfo.version;
      this.buildNumber = packageInfo.buildNumber;
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
}
