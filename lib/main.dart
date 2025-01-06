import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
// import google fonts
import 'package:wave_fe/view/core/dashboard/dashboard_page.dart';
import 'package:wave_fe/view/routes/routes.dart';
import 'package:wave_fe/view/widgets/main_header.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    html.window.onPopState.listen((event) {
      // Cegah navigasi kembali
      html.window.history.pushState(null, '', html.window.location.href);
    });
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: MainHeader(),
        ),
        body: DashboardPage());
  }
}
