import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/screens/form_screen.dart';
import 'package:todo_flutter/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: ()async{
                await auth.signOut();
               Navigator.pushReplacement(
                   context,
                   MaterialPageRoute(builder: (context) => LoginScreen())
               );
              },
              icon: Icon(Icons.exit_to_app)
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton.icon(
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FormScreen())
                );
              },
              label: Text("Novo Produto"),
            icon: Icon(Icons.add),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection("usuarios")
                  .doc(auth.currentUser!.email)
                  .collection("produtos").snapshots(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }else if(!snapshot.hasData){
                  return Center(child: Text("Sem dados"),);
                }else{
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index){
                        QueryDocumentSnapshot dados = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text(dados['descricao']),
                          subtitle: Text(dados['quantidade'].toString()),
                          leading: Icon(Icons.add_a_photo),
                          trailing: Icon(
                            Icons.circle,
                            color:dados['dentro_carrinho'] == true
                                ? Colors.green
                                : Colors.red
                            ,
                          ),
                        );
                      }
                  );
                }
              },
            ),
          ),
        ],
      )
    );
  }
}
