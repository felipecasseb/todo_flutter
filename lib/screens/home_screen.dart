import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/screens/colors_app.dart';
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

  ColorsApp colorsApp = ColorsApp();

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
                    MaterialPageRoute(builder: (context) => FormScreen(novoProduto: true,))
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
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => FormScreen(
                                  novoProduto: false,
                                  dadosProduto: {
                                    "id_produto" : dados.id,
                                    "codigo_barras" : dados['codigo_barras'],
                                    "dentro_carrinho" : dados['dentro_carrinho'],
                                    "descricao" : dados['descricao'],
                                    "quantidade" : dados['quantidade'],
                                  },
                                ))
                            );
                          },
                          title: Text(dados['descricao']),
                          subtitle: Text(dados['quantidade'].toString()),
                          leading: Icon(Icons.add_a_photo),
                          trailing: Icon(
                            Icons.circle,
                            color:dados['dentro_carrinho'] == true
                                ? Color(colorsApp.verdeHex)
                                : Color(colorsApp.vermelhoHex)
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
