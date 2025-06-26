import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'newsview.dart';
import 'weatherview.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final RxInt selected = 0.obs;
  final pages = const [WeatherView(), NewsView()];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          extendBody: true,
          backgroundColor: Colors.teal[50],
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: pages[selected.value],
          ),
          bottomNavigationBar: CurvedNavigationBar(
            index: selected.value,
            height: 60,
            backgroundColor: Colors.transparent,
            color: Colors.teal.shade700,
            buttonBackgroundColor: Colors.tealAccent,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 400),
            items: const <Widget>[
              Icon(Icons.wb_sunny_outlined, size: 28, color: Colors.white),
              Icon(Icons.article_outlined, size: 28, color: Colors.white),
            ],
            onTap: (index) {
              selected.value = index;
            },
          ),
        ));
  }
}
