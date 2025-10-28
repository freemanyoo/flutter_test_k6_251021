import 'package:busanit501_flutter_workspace_251021/sample_design/list_of_listview_sample.dart';
import 'package:busanit501_flutter_workspace_251021/sample_design/navigation_mode_sample1.dart';
import 'package:busanit501_flutter_workspace_251021/sample_design/tap_mode_sample2.dart';
import 'package:busanit501_flutter_workspace_251021/screen/my_splash2.dart';
import 'package:busanit501_flutter_workspace_251021/screen/pd_data/food_screen.dart';
import 'package:busanit501_flutter_workspace_251021/screen/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'main_screen.dart';

class MyAppRouting extends StatelessWidget {
  const MyAppRouting({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // 시작 화면, 스플레시 화면으로 시작. 3초뒤에 메인으로 이동함.
      home: const MySplash2(),
      //라우팅 준비물 1,
      routes: {
        '/main': (context) => const MyMainScreen(),
        '/signup': (context) => const MySignUpScreen(),
        '/login': (context) => const MyLoginScreen(),
        // 공공데이터 받아 오는 화면으로 라우팅 추가.
        '/pdtest': (context) => const MyPdTestScreen(),
        '/sample_design': (context) => const Sample3ListOfListView(),
        '/sample_design2': (context) => MaterialHomePage(),
        '/sample_design3': (context) => ResponsiveNavBarPage(),
      },
    );
  }
}
