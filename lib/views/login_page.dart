import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {

  final AuthController authController =
      AuthController();

  final TextEditingController
      emailController =
      TextEditingController();

  final TextEditingController
      passwordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF8F9FD),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(

              children: [

                const SizedBox(height: 50),

                const Icon(
                  Icons.lock_person,
                  size: 90,
                  color: Color(0xFF6C63FF),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Login to continue",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 40),

                Card(

                  elevation: 8,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: Padding(
                    padding:
                        const EdgeInsets.all(20),

                    child: Column(

                      children: [

                        TextField(
                          controller:
                              emailController,

                          decoration:
                              InputDecoration(
                            labelText: "Email",

                            prefixIcon:
                                const Icon(
                              Icons.email,
                            ),

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller:
                              passwordController,

                          obscureText: true,

                          decoration:
                              InputDecoration(
                            labelText:
                                "Password",

                            prefixIcon:
                                const Icon(
                              Icons.lock,
                            ),

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(

                          width:
                              double.infinity,

                          height: 50,

                          child:
                              ElevatedButton(

                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  const Color(
                                      0xFF6C63FF),

                              foregroundColor:
                                  Colors.white,

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        15),
                              ),
                            ),

                            onPressed:
                                () async {

                              if (emailController
                                      .text
                                      .isEmpty ||
                                  passwordController
                                      .text
                                      .isEmpty) {

                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please fill all fields",
                                    ),
                                  ),
                                );

                                return;
                              }

                              var user =
                                  await authController
                                      .login(
                                emailController.text,
                                passwordController.text,
                              );

                              if (!mounted) {
                                return;
                              }

                              if (user != null) {

                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Login successful",
                                    ),
                                  ),
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            HomePage(
                                      userId:
                                          user['id'],
                                    ),
                                  ),
                                );

                              } else {

                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Incorrect email or password",
                                    ),
                                  ),
                                );
                              }
                            },

                            child:
                                const Text(
                              "LOGIN",
                              style:
                                  TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextButton(

                          onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const ForgotPasswordPage(),
                              ),
                            );

                          },

                          child: const Text(
                            "Forgot Password ?",
                            style: TextStyle(
                              color:
                                  Color(0xFF6C63FF),
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        Row(

                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: [

                            const Text(
                              "Don't have an account?",
                            ),

                            TextButton(

                              onPressed: () {

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            const RegisterPage(),
                                  ),
                                );

                              },

                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color:
                                      Color(0xFF6C63FF),
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}