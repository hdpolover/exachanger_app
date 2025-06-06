import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/widgets/connectivity_overlay_widget.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '/app/bindings/initial_binding.dart';
import '/app/core/values/app_colors.dart';
import '/app/routes/app_pages.dart';
import '/flavors/build_config.dart';
import '/flavors/env_config.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final EnvConfig _envConfig = BuildConfig.instance.config;
  @override
  Widget build(BuildContext context) {
    return ConnectivityOverlayWidget(
      child: GetMaterialApp(
        title: _envConfig.appName,
        initialRoute: AppPages.INITIAL,
        initialBinding: InitialBinding(),
        getPages: AppPages.routes,
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: _getSupportedLocal(),
        theme: ThemeData(
          primarySwatch: AppColors.colorPrimarySwatch,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light,
          primaryColor: AppColors.colorPrimary,
          textTheme: const TextTheme(
            labelLarge: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          fontFamily: 'Manrope',
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusColor: AppColors.colorPrimary,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: AppColors.colorPrimary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.red),
            ),
            // text
            hintStyle: labelStyle,
            labelStyle: labelStyle,
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  List<Locale> _getSupportedLocal() {
    return [
      const Locale('en', ''),
      // const Locale('bn', ''),
    ];
  }
}
