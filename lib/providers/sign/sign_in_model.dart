import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/constants/endpoint.dart';
import 'package:pomangam/domains/user/enum/sign_in_state.dart';
import 'package:pomangam/domains/user/owner.dart';
import 'package:pomangam/repositories/sign/sign_repository.dart';

class SignInModel with ChangeNotifier {

  /// repository
  SignRepository _signRepository = Get.find(tag: 'signRepository');

  /// data
  Owner ownerInfo;
  SignInState signInState = SignInState.SIGNED_OUT;
  int passwordTryCount = 0;
  String id;
  String authCode;
  bool isSigningIn = false;
  bool isSigningOut = false;

  /// Sign in
  Future<bool> signIn({
    @required String id,
    @required String password
  }) async {
    assert(id != null && id.isNotEmpty && password != null && password.isNotEmpty);
    this.isSigningIn = true;
    changeSignState(SignInState.SIGNING_IN);
    this.passwordTryCount++;
    try {
      this.ownerInfo = await _signRepository.signIn(id: id, password: password);

    } catch(error) {
      changeSignState(SignInState.SIGNED_FAIL);
      this.isSigningIn = false;
      return false;
    }
    changeSignState(SignInState.SIGNED_IN);
    this.isSigningIn = false;
    return true;
  }

  /// Sign out
  Future<void> signOut({bool notify = true}) async {
    changeIsSigningOut(true);
    try {
      this.ownerInfo = null;
      changeSignState(SignInState.SIGNED_OUT, notify: false);
      await _signRepository.signOut(trySignInGuest: true);
    } finally {
      changeIsSigningOut(false, notify: false);
      if(notify) {
        notifyListeners();
      }
    }
  }

  void changeIsSigningOut(bool tf, {bool notify = true}) {
    this.isSigningOut = tf;
    if(notify) {
      notifyListeners();
    }
  }

  void changeSignState(SignInState signInState, {bool notify = true}) {
    this.signInState = signInState;
    if(notify) {
      notifyListeners();
    }
  }

  bool isMaxPasswordCount()
  => Endpoint.maxPasswordTryCount <= passwordTryCount;

  bool isSignIn() {
    return this.signInState == SignInState.SIGNED_IN;
  }

}