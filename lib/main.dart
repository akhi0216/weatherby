import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/homescreen.dart';
import 'controller/weather_controller.dart';
import 'controller/news_controller.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialBinding: BindingsBuilder(() {
      Get.put(WeatherController());
      Get.put(NewsController());
    }),
    home: HomePage(),
  ));
}
