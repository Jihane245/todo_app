import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends State<ForgotPasswordPage> {

  final AuthController authController =
      AuthController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController secretCodeController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
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
                  Icons.lock_reset,
                  size: 90,
                  color: Color(0xFF6C63FF),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Verify your secret code",
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
                              secretCodeController,

                          decoration:
                              InputDecoration(
                            labelText:
                                "Secret Code",

                            prefixIcon:
                                const Icon(
                              Icons.security,
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
                                "New Password",

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

                        const SizedBox(height: 15),

                        TextField(
                          controller:
                              confirmPasswordController,

                          obscureText: true,

                          decoration:
                              InputDecoration(
                            labelText:
                                "Confirm Password",

                            prefixIcon:
                                const Icon(
                              Icons.lock_outline,
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
                            ),

                            onPressed:
                                () async {

                              if (emailController
                                      .text
                                      .isEmpty ||
                                  secretCodeController
                                      .text
                                      .isEmpty ||
                                  passwordController
                                      .text
                                      .isEmpty ||
                                  confirmPasswordController
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

                              if (passwordController
                                      .text !=
                                  confirmPasswordController
                                      .text) {

                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Passwords do not match",
                                    ),
                                  ),
                                );

                                return;
                              }

                              bool success =
                                  await authController
                                      .resetPassword(
                                emailController.text,
                                secretCodeController.text,
                                passwordController.text,
                              );

                              if (!mounted) {
                                return;
                              }

                              if (success) {

                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Password updated successfully",
                                    ),
                                  ),
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginPage(),
                                  ),
                                );

                              } else {

                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Invalid email or secret code",
                                    ),
                                  ),
                                );
                              }
                            },

                            child:
                                const Text(
                              "UPDATE PASSWORD",
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextButton(

                          onPressed: () {

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginPage(),
                              ),
                            );

                          },

                          child: const Text(
                            "Back to Login",
                          ),
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