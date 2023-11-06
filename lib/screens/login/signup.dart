import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workoutapp/functions/auth_functions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenScreenState();
}

class _SignUpScreenScreenState extends State<SignUpScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  String username = "";
  String email = "";
  String password = "";

  void confirm() {
    if (passwordController.text != confirmPasswordController.text) {
      Fluttertoast.showToast(
        msg: "Passwords do not match",
        backgroundColor: Colors.red,
      );
    } else {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        signup(email, password, username, context);
      }
    }
  }

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
                    "New User?",
                    style: TextStyle(fontSize: size.width * 0.1),
                  ),
                  const Text(
                    "Lets Get Started",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      TextFormField(
                        key: const ValueKey("username"),
                        keyboardType: TextInputType.name,
                        controller: usernameController,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .black), // Change the focused border color when clicked
                          ),
                          prefixIcon: Icon(Icons.verified_user),
                          hintText: "Useranme ",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an full name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            username = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        key: const ValueKey("email"),
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .black), // Change the focused border color when clicked
                          ),
                          prefixIcon: Icon(Icons.email),
                          hintText: "Email ",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            email = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        key: const ValueKey("password"),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: passwordVisible,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), //
                          ),
                          prefixIcon: Icon(Icons.lock),
                          hintText: "Password",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty ) {
                            return 'Please enter Passwords';
                          }
                          if(value.length<6){
                            return 'Password must be atleast 6 characters';
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
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          prefixIcon: const Icon(Icons.password),
                          hintText: "Confirm Password",
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            child: Icon(
                              passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          confirm();
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
                            "Sign Up",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text("or "),
                      const SizedBox(
                        height: 30,
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
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
