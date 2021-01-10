import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/initalizer/initializer.dart';
import 'package:pomangam/_bases/network/api/api.dart';
import 'package:pomangam/_bases/network/domain/token.dart';
import 'package:pomangam/domains/user/owner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomangam/_bases/key/shared_preference_key.dart' as s;

class SignRepository {

  final Api api = Get.find(tag: 'api');
  final Initializer initializer = Get.find(tag: 'initializer');

  /// ## signIn
  ///
  /// [id] ID 에 해당하는 핸드폰번호 입력
  /// [password] 비밀번호
  /// 유저 계정 서버로 전달 -> 유효성 체크 -> login token 발급 -> return 업주 정보
  ///
  Future<Owner> signIn({
    @required String id,
    @required String password
  }) async {
    Owner owner;
    Token token = await api.oauthTokenRepository.issueLoginToken(id: id, password: password);

    if(token != null) {
      token
        ..saveToDisk()
        ..saveToDioHeader();

      (await SharedPreferences.getInstance()).setString(s.userId, id);
      owner = Owner.fromJson((await api.get(url: '/store/owners/$id')).data);

      await initializer.initializeNotification();
    }
    return owner;
  }

  /// ## signOut
  ///
  /// 로그아웃
  /// SharedPreference 내부 token 값 삭제, Dio Header 내부 token 값 삭제.
  /// 로그아웃 후 View 단에서 초기화 후, 홈('/') 으로 이동 필요.
  ///
  Future<void> signOut({bool trySignInGuest = true}) async {
    Token.clearFromDisk();
    Token.clearFromDioHeader();
    //(await SharedPreferences.getInstance()).remove(s.userId);
    await initializer.deleteFcmTokenClientInfo();
    if(trySignInGuest) {
      await initializer.initializeToken();
      await initializer.initializeModelData();
    }
  }
}