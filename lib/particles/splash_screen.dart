import 'package:flutter/material.dart';
import 'package:schedule_kpi/generated/l10n.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text(
            S.of(context).firstLoading,
            style: TextStyle(color: Colors.black, fontSize: 24),
          )
        ],
      ),
    );
  }
}
