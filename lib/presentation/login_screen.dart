import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../core/component/dialog/loading_dialog.dart';
import '../core/theme/app_color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String validEmail = "Yekta@gmail.com";
  String validPass = "123456789";
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();
  StateMachineController? controller;
  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    emailFocusNode.addListener(email);
    passwordFocusNode.addListener(password);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(email);
    passwordFocusNode.removeListener(password);
    super.dispose();
  }

  void email() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void password() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EA),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text(
              "Hellooooo :)",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 250,
              width: 250,
              child: RiveAnimation.asset(
                "assets/login-teddy.riv",
                fit: BoxFit.fitHeight,
                stateMachines: const ["Login Machine"],
                onInit: (artBoard) {
                  controller = StateMachineController.fromArtboard(
                    artBoard,
                    "Login Machine",
                  );
                  if (controller == null) return;
                  artBoard.addController(controller!);
                  isChecking = controller?.findInput("isChecking");
                  numLook = controller?.findInput("numLook");
                  isHandsUp = controller?.findInput("isHandsUp");
                  trigSuccess = controller?.findInput("trigSuccess");
                  trigFail = controller?.findInput("trigFail");
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      focusNode: emailFocusNode,
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email",
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (value) {
                        numLook?.change(value.length.toDouble());
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    
                    decoration: BoxDecoration(
                      
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(

                      focusNode: passwordFocusNode,
                      controller: passwordController,
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        suffixIconConstraints:const BoxConstraints(maxHeight: 37,),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                passwordVisible = !passwordVisible;
                              },
                            );
                          },
                        ),
                        
                        border: InputBorder.none,
                        hintText: "Password",
                        
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () async {
                        emailFocusNode.unfocus();
                        passwordFocusNode.unfocus();

                        final email = emailController.text;
                        final password = passwordController.text;

                        showLoadingDialog(context);
                        await Future.delayed(
                          const Duration(milliseconds: 2000),
                        );
                        if (mounted) Navigator.pop(context);

                        if (email == validEmail && password == validPass) {
                          trigSuccess?.change(true);
                        } else {
                          trigFail?.change(true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff9e4968),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
