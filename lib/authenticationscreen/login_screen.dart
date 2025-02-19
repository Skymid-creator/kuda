import 'package:flutter/material.dart';
import 'package:kuda/widgets/custom_text_field_widget.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();


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

              const SizedBox(
                height: 60,
              ),

              //email
              SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                height: 70,
                child: CustomTextFieldWidget(
                  editingController: emailTextEditingController,
                  labelText: "Email",
                  iconData: Icons.email_outlined,
                  isObscure: false,
                ),
              ),

              //password
              SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                height: 70,
                child: CustomTextFieldWidget(
                  editingController: passwordTextEditingController,
                  labelText: "Password",
                  iconData: Icons.lock_outlined,
                  isObscure: true,
                ),
              ),

              //login button
              Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 55,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  )
                ),
                child: InkWell(
                  onTap: (){

                  },
                  child: const Center(
                    child: Text(
                      "Login",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                    ),
                    )
                  )
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 55,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    )
                ),
                child: InkWell(
                    onTap: (){

                    },
                    child: const Center(
                        child: Text(
                          "Create new account",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                    )
                ),
              ),

            ],
          ),
        ),
      )
    );
  }
}

