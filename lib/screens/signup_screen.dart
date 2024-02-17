import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/screens/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nova Conta", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "E-mail",
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Senha",
              ),
            ),
            ElevatedButton(
              onPressed: ()async{
                await auth.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text
                ).then((value)async{
                  await firestore.collection("usuarios").doc(value.user!.email!).set({
                    "email" : value.user!.email!
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                      context,
                    MaterialPageRoute(builder: (context) => const HomeScreen())
                  );
                });
              },
              child: const Text("Salvar"),
            ),
            const Text("Já possui conta?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text("Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
            ),
          ],
        ),
      ),
    );
  }
}