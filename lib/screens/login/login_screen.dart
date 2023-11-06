import 'package:flutter/material.dart';
import 'package:workoutapp/functions/auth_functions.dart';
import 'package:workoutapp/screens/login/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passtoggle = true;
  String email = "";
  String password = "";
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.only(
            left: 30,
            right: 30,
            bottom: size.height * 0.2,
            top: size.height * 0.05,
          ),
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Hello,\nWelcome Back",
                    style: TextStyle(fontSize: size.width * 0.1),
                  ),
                  const Text(
                    "You have been missed",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      ),
                      const SizedBox(height: 50),
                      Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: Colors.red),
                        child: TextFormField(
                          key: const ValueKey("email"),
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            prefixIcon: Icon(Icons.email),
                            hintText: "Email ",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email cannot be empty';
                            }
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              email = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        key: const ValueKey("password"),
                        keyboardType: TextInputType.emailAddress,
                        controller: passcontroller,
                        obscureText: true,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          prefixIcon: Icon(Icons.lock),
                          hintText: "Password",
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 6) {
                            return 'Please enter Passwords';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            password = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Forgot Password?",
                      )
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            signIn(email, password,context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 50, 49, 49),
                          padding: const EdgeInsets.all(18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                     
                       const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/google.png",
                            width: 30,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Continue with Google",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SignUpScreen()));
                        },
                        child: const Text(
                          "New User? Create account",
                        ),
                      )
                    ],
                  ),
                ]),
          ),
        ),
      ),
    ));
  }
}


