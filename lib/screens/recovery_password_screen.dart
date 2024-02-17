import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecoveryPasswordScreen extends StatefulWidget {
  const RecoveryPasswordScreen({super.key});

  @override
  State<RecoveryPasswordScreen> createState() => _RecoveryPasswordScreenState();
}

class _RecoveryPasswordScreenState extends State<RecoveryPasswordScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar senha"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            ElevatedButton(
                onPressed: ()async{
                  await auth.sendPasswordResetEmail(email: emailController.text);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: const Text("Recuperar senha")
            )
          ],
        ),
      ),
    );
  }
}
