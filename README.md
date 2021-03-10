```
███╗   ███╗██████╗    ██████╗  ██████╗ ██████╗ ████████╗███████╗██████╗
████╗ ████║██╔══██╗   ██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝██╔════╝██╔══██╗
██╔████╔██║██████╔╝   ██████╔╝██║   ██║██████╔╝   ██║   █████╗  ██████╔╝
██║╚██╔╝██║██╔══██╗   ██╔═══╝ ██║   ██║██╔══██╗   ██║   ██╔══╝  ██╔══██╗
██║ ╚═╝ ██║██║  ██║██╗██║     ╚██████╔╝██║  ██║   ██║   ███████╗██║  ██║
╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
```
---

## 예약배송 플랫폼 포만감v1.2, 업주용 Flutter 앱

### 수행기간
- 2018-11 ~ 2020-11

### 사용기술
- Dart, Flutter

### 인원
- 1명 ([NTEVE](https://github.com/cholnh))

### 개요
- 업주 주문 관리용 하이브리드 어플리케이션.

### 스크린샷
|메인화면|주문접수화면|주문상세화면|주문내역화면|
|--|--|--|--|
|![screenshot (4)](https://user-images.githubusercontent.com/23611497/110626212-ca81de00-81e3-11eb-983f-f5049ef948d1.png)|![screenshot (1)](https://user-images.githubusercontent.com/23611497/110626228-cfdf2880-81e3-11eb-9427-b732eed4410b.png)|![screenshot (2)](https://user-images.githubusercontent.com/23611497/110626240-d40b4600-81e3-11eb-82d3-f2efaad48b66.png)|![screenshot (3)](https://user-images.githubusercontent.com/23611497/110626246-d7063680-81e3-11eb-8b46-4cf8772b3254.png)|

### 주요특징
|키워드|설명|링크|
|--|--|--|
| 주문 관리 로직 구현 | 주문 접수/거절/배달지연/픽업/취소/환불 이벤트를 서버에 전달. |[:arrow_right:](https://github.com/cholnh/pomangam_store_flutter/blob/ebb4124b932f59d3fb04b90275765163b93cd39c/lib/repositories/order/order_repository.dart#L31-L71)|
| Provider 패턴 | Ui와 비즈니스 로직을 분리 및 데이터 공유. |[:arrow_right:](https://github.com/cholnh/pomangam_store_flutter/tree/master/lib/providers)|
| OAuth2.0 | OAuth Token 발급, 관리 및 Resource Server와 연결하는 모듈 구현. |[:arrow_right:](https://github.com/cholnh/pomangam_store_flutter/blob/ebb4124b932f59d3fb04b90275765163b93cd39c/lib/_bases/network/repository/authorization_repository.dart#L8-L185)|
| FCM | 푸시 알림 모듈 구현. |[:arrow_right:](https://github.com/cholnh/pomangam_store_flutter/blob/ebb4124b932f59d3fb04b90275765163b93cd39c/lib/_bases/initalizer/initializer.dart#L205-L261)|
| Json | json_serializable 패키지를 통해 JsonSerializableGenerator 생성하어 서버로 부터 받아온 Json 값을 내부 domain으로 변환. |[:arrow_right:](https://github.com/cholnh/pomangam_store_flutter/blob/ebb4124b932f59d3fb04b90275765163b93cd39c/lib/domains/deliverysite/delivery_site.dart#L21-L27)|
| Widgets | XD, Zeplin으로 전달 받은 디자인 결과물을 바탕으로 Widgets 구현. |[:arrow_right:](https://github.com/cholnh/pomangam_store_flutter/tree/master/lib/views/mobile)|
| Infinite Scroll Pagination | 서버 비동기 통신을 통해 Pageable 리스트를 받아와 화면에 끊임없이 Loading 되는 widget 구현. |[:arrow_right:](https://github.com/cholnh/pomangam_store_flutter/blob/ebb4124b932f59d3fb04b90275765163b93cd39c/lib/providers/vbank/vbank_model.dart#L39-L46)|
| Firebase Crashlytics | 비정상 종료 모니터링. |[:arrow_right:](https://github.com/cholnh/pomangam_store_flutter/blob/ebb4124b932f59d3fb04b90275765163b93cd39c/lib/main.dart#L31-L39)|

### 결과
- ‘포만감 업주용’ 안드로이드 어플리케이션 배포 ( https://play.google.com/store/apps/details?id=com.mrporter.flutter.store.pomangam )
- 2018 고양지식정보산업진흥원 고-로켓 창업 아이디어 공모전 수상, 경진대회 2위 수상
- 2018 경기도경제과학진흥원 경기북부 대학생 창업경진대회 은상 수상
- 2018 광운대 도시樂 창업경진대회 1위 수상
- 2018 미래로 고양 창업경진대회 2위 수상
- 2019 특허 출원 경험 (다중 주문 실시간 배송 처리 장치 및 이를 이용한 다중 주문 실시간 배송 처리 방법, 10-2019-0022262)
- 2019 중국 국영 중강그룹 글로벌창업경진대회 2등 단체상 수상
- 2019 공학 페스티벌 창업투자 아이디어 경진대회 1위 수상

### 문서
- v1.0 API 문서 ( https://pomangam.docs.apiary.io )
- 주문 프로세스 문서 ( https://docs.google.com/document/d/1NTP_Ha8Gyu34hkUNxTii0bGyOfa5j-gOX-HamKXpCFw/edit )
