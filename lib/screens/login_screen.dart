import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/screens/signup_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
                    onPressed: (){
                      debugPrint("Email: ${emailController.text}, Senha: ${passwordController.text}");
                    },
                    child: Text("Acessar")
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
