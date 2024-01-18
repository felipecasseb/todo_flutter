import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Conta", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "E-mail",
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                ),
              ),
              ElevatedButton(
                onPressed: ()async{
                  await auth.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text
                  ).then((value) => print(value.toString()));
                },
                child: Text("Salvar"),
              ),
              Text("Já possui conta?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop(
                      MaterialPageRoute(builder: (context) => LoginScreen())
                  );
                },
                child: Text("Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}