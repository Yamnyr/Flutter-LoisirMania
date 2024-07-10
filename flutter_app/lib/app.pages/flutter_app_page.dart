import 'package:flutter/material.dart';
import 'package:flutter_app/app.pages/flutter_app_button.dart';
// import 'package:flutter_app/app.pages/flutter_app_button_loisir.dart';

class FlutterAppPage extends StatelessWidget {
  const FlutterAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TODO',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlutterAppButton(
              text: 'test',
              color: Colors.black87,
              textColor: Colors.white,
              onPressed: () {},
            ),
            FlutterAppButton(
                text: 'text',
                color: Colors.black87,
                textColor: Colors.white,
                onPressed: () {}
            ),
          ],
        ),
      ),
    );
  }
}
