import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_dialog_utils.dart';
import 'package:pomangam/views/mobile/widgets/sign/sign_in_bottom_btn_widget.dart';
import 'package:pomangam/views/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:pomangam/_bases/key/shared_preference_key.dart' as s;
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  TextEditingController _idController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  FocusNode _idFocus = FocusNode();
  FocusNode _pwFocus = FocusNode();

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    String storedId = (await SharedPreferences.getInstance()).getString(s.userId);
    String storedPw = (await SharedPreferences.getInstance()).getString(s.userPw);
    if(!storedId.isNullOrBlank) {
      _idController.text = storedId;
      _pwController.text = storedPw;
      FocusScope.of(context).requestFocus(_pwFocus);
    } else {
      FocusScope.of(context).requestFocus(_idFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: context.watch<SignInModel>().isSigningIn,
      child: Scaffold(
        bottomNavigationBar: SignInBottomBtnWidget(title: '로그인', onTap: _login),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _idController,
                      focusNode: _idFocus,
                      autofocus: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontWeight: FontWeight.bold, locale: Locale('en')),
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        labelText: '아이디',
                        alignLabelWithHint: true,
                      ),
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_pwFocus),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _pwController,
                      focusNode: _pwFocus,
                      autofocus: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontWeight: FontWeight.bold, locale: Locale('en')),
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        alignLabelWithHint: true,
                      ),
                      onFieldSubmitted: (_) => _login(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    String id = _idController.text;
    String pw = _pwController.text;
    if(id.isEmpty) {
      DialogUtils.dialog(context, '아이디를 입력해주세요.', onPressed: (_) => FocusScope.of(context).requestFocus(_idFocus));
    }
    if(pw.isEmpty) {
      DialogUtils.dialog(context, '비밀번호를 입력해주세요.', onPressed: (_) => FocusScope.of(context).requestFocus(_pwFocus));
    }

    bool isSignIn = await context.read<SignInModel>().signIn(id: id, password: pw);
    if(isSignIn) {
      Get.offAll(SplashPage());
    } else {
      DialogUtils.dialog(context, '잘못된 계정 정보입니다.');
      //FocusScope.of(context).requestFocus(_pwFocus);
    }
  }
}
