import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/di/injector_register.dart';
import 'package:pomangam/providers/deliverysite/delivery_site_model.dart';
import 'package:pomangam/providers/deliverysite/detail/delivery_detail_site_model.dart';
import 'package:pomangam/providers/order/order_model.dart';
import 'package:pomangam/providers/order/order_view_model.dart';
import 'package:pomangam/providers/order/order_view_sort_model.dart';
import 'package:pomangam/providers/order/time/order_time_model.dart';
import 'package:provider/provider.dart';
import 'package:pomangam/_bases/theme/custom_theme.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/views/splash_page.dart';

void main() {
  GoogleMap.init('AIzaSyCfgL80z55BPeCaCQSfiyabWK_J8YJkd5s');
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
//    runApp(_devicePreview(
//      enabled: true,
//      builder: (ctx) => MyApp()
//    ));
  }, (Object error, StackTrace stackTrace) {
    print('zone error!! $error');
    print(stackTrace);
  });
}

Widget _devicePreview({bool enabled, WidgetBuilder builder}) {
  return MaterialApp(
      home: Scaffold(
        body: DevicePreview(
            enabled: enabled,
            builder: builder
        ),
      )
  );
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

      ],
      child: GetMaterialApp(
        builder: DevicePreview.appBuilder, // <--- Add the builder
        title: '레디밀 사장님',
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

        supportedLocales: [Locale('en')],
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}