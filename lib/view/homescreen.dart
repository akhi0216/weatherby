import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'newsview.dart';
import 'weatherview.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final RxInt selected = 0.obs;
  final pages = const [WeatherView(), NewsView()];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: pages[selected.value],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selected.value,
        onTap: (i) => selected.value = i,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny_outlined), label: 'Weather'),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'News'),
        ],
      ),
    ));
  }
}
