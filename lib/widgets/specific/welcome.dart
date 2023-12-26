import 'package:flutter/material.dart';

import '../home.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Welcome'),
            // MaterialButton(
            //     onPressed: () => {
            //           Navigator.of(context).push(
            //             MaterialPageRoute(
            //               builder: (context) => HomeWidget(),
            //             ),
            //         },
            //     child: Text('Go to Home')),
          ],
        )),
      ),
    );
  }
}
