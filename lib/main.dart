import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/constants/endpoint.dart';
import 'package:pomangam/_bases/di/injector_register.dart';
import 'package:pomangam/providers/deliverysite/delivery_site_model.dart';
import 'package:pomangam/providers/deliverysite/detail/delivery_detail_site_model.dart';
import 'package:pomangam/providers/order/order_history_model.dart';
import 'package:pomangam/providers/order/order_model.dart';
import 'package:pomangam/providers/order/order_view_model.dart';
import 'package:pomangam/providers/order/order_view_sort_model.dart';
import 'package:pomangam/providers/order/time/order_time_model.dart';
import 'package:pomangam/providers/payment/payment_model.dart';
import 'package:pomangam/providers/product/product_model.dart';
import 'package:pomangam/providers/store/store_model.dart';
import 'package:pomangam/providers/vbank/vbank_model.dart';
import 'package:provider/provider.dart';
import 'package:pomangam/_bases/theme/custom_theme.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/views/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  InjectorRegister.register();

//  Crashlytics.instance.enableInDevMode = true;
//  FlutterError.onError = Crashlytics.instance.recordFlutterError;
//  Isolate.current.addErrorListener(RawReceivePort((pair) async {
//    final List<dynamic> errorAndStacktrace = pair;
//    await Crashlytics.instance.recordError(
//      errorAndStacktrace.first,
//      errorAndStacktrace.last,
//    );
//  }).sendPort);
//  runZoned(() {
//    runApp(MyApp());
//  }, onError: Crashlytics.instance.recordError);

  runZonedGuarded(() {
    runApp(MyApp());
  }, (Object error, StackTrace stackTrace) {
    print('zone error!! $error');
    print(stackTrace);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInModel(), lazy: true),
        ChangeNotifierProvider(create: (_) => OrderViewSortModel(), lazy: true),
        ChangeNotifierProvider(create: (_) => OrderViewModel(), lazy: true),
        ChangeNotifierProvider(create: (_) => OrderTimeModel(), lazy: true),
        ChangeNotifierProvider(create: (_) => OrderModel(), lazy: true),
        ChangeNotifierProvider(create: (_) => DeliverySiteModel(), lazy: true),
        ChangeNotifierProvider(create: (_) => DeliveryDetailSiteModel(), lazy: true),
        ChangeNotifierProvider(create: (_) => OrderHistoryModel(), lazy: true),
        ChangeNotifierProvider(create: (_) => StoreModel(), lazy: true),
        ChangeNotifierProvider(create: (_) => VBankModel(), lazy: true),
        ChangeNotifierProvider(create: (_) => ProductModel(), lazy: true),
        ChangeNotifierProvider(create: (_) => PaymentModel(), lazy: true),

      ],
      child: GetMaterialApp(
        title: '포만감 사장님',
        themeMode: ThemeMode.light,
        theme: customTheme(context),
        darkTheme: customTheme(context, darkMode: true),
        home: SplashPage(),
        localizationsDelegates: [
          DefaultCupertinoLocalizations.delegate
        ],
        navigatorKey: Get.key,
        popGesture: true,
        defaultTransition: Transition.cupertino,
        transitionDuration: Duration.zero,

        builder: (context, child) => _webView(
            context: context,
            enabled: kIsPcWeb(context: context),
            child: child
        ),

        supportedLocales: [Locale('en')],
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  Widget _webView({BuildContext context, bool enabled, Widget child}) {
    if(!enabled) return child;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(size: Size(Endpoint.webWidth, Endpoint.webHeight)),
      child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: Center(
            child: Container(
              width: Endpoint.webWidth,
              height: Endpoint.webHeight,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey[500],
                      width: 0.5
                  )
              ),
              child: child,
            ),
          )
      ),
    );
  }
}