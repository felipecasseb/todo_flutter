import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class FormScreen extends StatefulWidget {
  final bool novoProduto;
  final Map? dadosProduto;
  const FormScreen({
    required this.novoProduto,
    this.dadosProduto,
    super.key
  });

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController codigoBarraController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController quantidadeController = TextEditingController();

  bool dentroCarrinho = false;
  bool loading = false;
  bool loadBarCode = false;
  
  Future<void> getBarCode(String barCode)async{
    setState(() => loadBarCode = true);

    Uri uri = Uri.parse("https://api.cosmos.bluesoft.com.br/gtins/$barCode");

    final response = await http.get(
      uri,
      headers: {
        "Content-Type" : "application/json",
        "X-Cosmos-Token" : "ZsXdsbPaF7bMTs0vdmHJcA"
      }
    );
    if(response.statusCode == 200){
      Map<String, dynamic> dadosProduto = json.decode(response.body);
      descricaoController.text = dadosProduto['description'];
      setState(() => loadBarCode = false);
    }else{
      setState(() => loadBarCode = false);
    }
  }


  @override
  void initState() {
    super.initState();
    if(widget.novoProduto == false){
      codigoBarraController.text = widget.dadosProduto!['codigo_barras'];
      descricaoController.text = widget.dadosProduto!['descricao'];
      quantidadeController.text = widget.dadosProduto!['quantidade'].toString();
      dentroCarrinho = widget.dadosProduto!['dentro_carrinho'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.novoProduto == true ? "Novo Produto" : "Editar Produto"),
        centerTitle: true,
        backgroundColor: Color(0xFFDDDEDF),
        actions: [
          IconButton(
              onPressed: ()async{
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));
                setState(()async {
                  if (res is String){
                    codigoBarraController.text = res;
                    await getBarCode(res);
                  }
                });
              },
              icon: Image.asset("images/barcode.png")
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Código de barras", style: TextStyle(fontWeight: FontWeight.bold),),
                TextField(
                  controller: codigoBarraController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20,),
                const Text("Descrição", style: TextStyle(fontWeight: FontWeight.bold),),
                TextField(
                  controller: descricaoController,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20,),
                const Text("Quantidade", style: TextStyle(fontWeight: FontWeight.bold),),
                TextField(
                  controller: quantidadeController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20,),
                const Text("Está dentro do carrinho?", style: TextStyle(fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            dentroCarrinho = true;
                            print(dentroCarrinho);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            //border: Border.all(color: Color(0xFF639339)),
                            color: dentroCarrinho == true ? Color(0xFFE5F0DB) : Colors.grey.shade100,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.circle, color: Colors.green,),
                              Text("Sim")
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            dentroCarrinho = false;
                            print(dentroCarrinho);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              //border: Border.all(color: Color(0xFF639339)),
                              color: dentroCarrinho == false ? Color(0xFFF3BABD) : Colors.grey.shade100//Color(0xFFE5F0DB)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.circle, color: Colors.red,),
                              Text("Não")
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 40,),
                loading == true
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                    onPressed: ()async{
                      setState(() => loading = true);
                      if(widget.novoProduto){
                        await firestore
                            .collection("usuarios")
                            .doc(auth.currentUser!.email)
                            .collection("produtos").add({
                          "codigo_barras" : codigoBarraController.text,
                          "dentro_carrinho" : dentroCarrinho,
                          "descricao" : descricaoController.text,
                          "quantidade" : int.parse(quantidadeController.text)
                        });
                      }else{
                        await firestore
                            .collection("usuarios")
                            .doc(auth.currentUser!.email)
                            .collection("produtos")
                            .doc(widget.dadosProduto!['id_produto'])
                            .update({
                          "codigo_barras" : codigoBarraController.text,
                          "dentro_carrinho" : dentroCarrinho,
                          "descricao" : descricaoController.text,
                          "quantidade" : int.parse(quantidadeController.text)
                        });

                      }
                      setState(() => loading = false);
                    },
                    child: Text(widget.novoProduto ? "Cadastrar produto" : "Atualizar produto")
                )
              ],
            ),
          ),
          Visibility(
            visible: loadBarCode,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey.withOpacity(0.7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Carregando dados do produto...")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
