import 'package:flutter/material.dart';
import 'package:DairyDunk/services/auth/auth_service.dart';
import 'package:DairyDunk/utils/extension.dart';

import '../components/components.dart';
import 'pages.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void login() async{
   final _authService = AuthService();
   try{
    await _authService.signInWithEmailPassword(
      emailController.text, 
      passController.text
      );
   }
   catch(e){
    showDialog(
          context: context, 
          builder: (context)=> AlertDialog(
            title: Text(e.toString()),
          ),
          );
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Logo
            Icon(
              Icons.shopping_bag,
              size: 100,
              color: Colors.pink,
            ),
            25.pv,

            //message, app  slogan
            Text(
              "Milk Delivery App",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            25.pv,

            // password textfield
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),

            10.pv,

            MyTextField(
              controller: passController,
              hintText: 'Password',
              obscureText: true,
            ),

            10.pv,

            // sing in button
            MyButton(
              text: "Sign In",
              onTap: login,
            ),
            25.pv,

            // not a member?  register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a Member?",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
                4.ph,
                GestureDetector(
                  // onTap: widget.onTap,
                  onTap: widget.onTap,
                  child: Text(
                    "Register now",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
