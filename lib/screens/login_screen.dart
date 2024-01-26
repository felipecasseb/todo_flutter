import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/screens/home_screen.dart';
import 'package:todo_flutter/screens/recovery_password_screen.dart';
import 'package:todo_flutter/screens/signup_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Todo Supermercado", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
                Text("Acesse sua conta", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Email",
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
                      await auth.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text
                      ).then((value){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen())
                        );
                      });
                    },
                    child: Text("Acessar")
                ),
                TextButton(
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RecoveryPasswordScreen())
                      );
                    },
                    child: Text("Esqueci minha senha")
                ),
                Text("Ainda não tem acesso?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                TextButton(
                  onPressed: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignupScreen())
                    );
                  },
                  child: Text("Crie sua conta", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                ),
              ],
            ),
          ),
        )
    );
  }
}
