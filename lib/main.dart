import 'package:dwindle/accounts.dart';
import 'package:dwindle/login_page.dart';
import 'package:flutter/material.dart';
import 'adafruit_service.dart';
import 'meter_data.dart';
import 'usage_chart.dart';
import 'waqi_display.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await Hive.openBox('settings');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final adafruit = AdafruitService(
      'SRIEMS',
      'ENTER_ADAFRUIT_IO_KEY');

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),

      builder: (context, box, _) {

        bool isDark = box.get('darkMode', defaultValue: false);

        return MaterialApp(
          title: 'Smart Meter Dashboard',

          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFEAF5F1),
            useMaterial3: true,
          ),

          darkTheme: ThemeData.dark(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

          home: LoginPage(),
        );
      },
    );
  }
}