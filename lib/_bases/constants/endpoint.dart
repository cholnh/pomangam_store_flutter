import 'package:pomangam/domains/_bases/page_request.dart';

class Endpoint {
  /// Initialize
  static const int fallbackTotalCount = 10;

  /// SignIn
  static const int maxAuthCodeSendCount = 5;
  static const int maxPasswordTryCount = 5;

  /// PageRequest
  static const int defaultPage = 0;
  static const int defaultSize = 3;
  static const int defaultProductsSize = 6;
  static const String defaultProperty = 'idx';
  static const Direction defaultDirection = Direction.DESC;

  /// Network
  static final String serverDomain = 'http://192.168.123.106:9530/api/v1.2'; //'https://poman.kr:9531/api/v1.2';
  static final int connectTimeout = 5000;
  static final int receiveTimeout = 3000;
  static final String guestOauthTokenHeader = 'Z3Vlc3Q6c1pFSl45RV1la2pqLnt2Yw==';
  static final String loginOauthTokenHeader = 'c3RvcmVfb3duZXI6Zltkc2ZlXTMuKjFqQHor';

  /// BootPay
  static final String bootpayAndroidApplicationId = '5cc70f38396fa67747bd0684';
  static final String bootpayIosApplicationId = '5cc70f38396fa67747bd0685';
  static final String bootpayPg = 'kcp';
  static final bootpayMethods = ['card', 'vbank', 'bank', 'phone'];
  static final String bootpayAppScheme = 'pomangamClientFlutterV3'; //'bootpayFlutterSample';

  /// Juso Api
  static final String jusoApiDomain = 'http://www.juso.go.kr/addrlink/addrLinkApi.do';
  static final String jusoApiKey = 'U01TX0FVVEgyMDIwMDUwNTE1MjgzNDEwOTcyNjY=';

  /// Coordinate Api
  static final String coordinateApiDomain = 'http://www.juso.go.kr/addrlink/addrCoordApiJsonp.do';
  static final String coordinateApiKey = 'U01TX0FVVEgyMDIwMDgwNDExMzQ0MTExMDAyMjA= ';

  /// customer service center
  static final String customerServiceCenterNumber = '01064784899';
}