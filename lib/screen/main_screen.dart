import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyMainScreen extends StatelessWidget {
  const MyMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('메인화면'),),
        body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(child: FlutterLogo(size:100),),
                const SizedBox(height: 16,),     ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text('로그인')),

                ElevatedButton(
                  //라우팅 2번 째 준비물,
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text('회원 가입'),
                ),
                ElevatedButton(
                  //라우팅 2번 째 준비물,
                  onPressed: () => Navigator.pushNamed(context, '/pdtest'),
                  child: const Text('조리식품의 레시피'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/sample_design'),
                  child: const Text('샘플 디자인1'),
                ),
              ],
            )),
      );

  }
}
