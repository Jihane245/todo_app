import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {

  final AuthController authController =
      AuthController();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController secretCodeController =
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
                  Icons.person_add_alt_1,
                  size: 90,
                  color: Color(0xFF6C63FF),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Register to continue",
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
                              nameController,

                          decoration:
                              InputDecoration(
                            labelText: "Name",

                            prefixIcon:
                                const Icon(
                              Icons.person,
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

                              if (nameController
                                      .text
                                      .isEmpty ||
                                  emailController
                                      .text
                                      .isEmpty ||
                                  passwordController
                                      .text
                                      .isEmpty ||
                                  secretCodeController
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

                              bool success =
                                  await authController
                                      .register(
                                nameController.text,
                                emailController.text,
                                passwordController.text,
                                secretCodeController.text,
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
                                      "Account created successfully",
                                    ),
                                  ),
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            const LoginPage(),
                                  ),
                                );

                              } else {

                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Email already exists",
                                    ),
                                  ),
                                );
                              }
                            },

                            child:
                                const Text(
                              "SIGN UP",
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

                        Row(

                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: [

                            const Text(
                              "Already have an account?",
                            ),

                            TextButton(

                              onPressed: () {

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            const LoginPage(),
                                  ),
                                );

                              },

                              child: const Text(
                                "Login",
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