import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stripe_method/screens/signup_screen/signup_screen_controller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final SignupScreenController controller = Get.put(SignupScreenController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GetBuilder<SignupScreenController>(builder: (controller) {
          return Column(
            children: [
              SizedBox(height: 50),
              Text(
                'Sign up',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: controller.emailController,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.black54),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      borderSide: BorderSide(color: Colors.black)),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: controller.passwordController,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.black54),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      borderSide: BorderSide(color: Colors.black)),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: controller.nameController,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Name',
                  hintStyle: TextStyle(color: Colors.black54),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      borderSide: BorderSide(color: Colors.black)),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  GestureDetector(
                    onTap: () {
                      controller.LodinScreen();
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  controller.signUP();
                },
                child: controller.isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white),
                      ),
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue)),
              )
            ],
          );
        }),
      ),
    ));
  }
}
