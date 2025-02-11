import 'package:flutter/material.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [

              const SizedBox(
                height: 150,
              ),

              Image.asset(
                "images/logo.png",
                width: 300,
              ),
              const Text(
                "Connecting souls",
                    style: TextStyle(
                      fontFamily: 'LoveDays',
                    fontSize: 30,
              ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

