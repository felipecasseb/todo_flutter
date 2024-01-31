import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController codigoBarraController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController quantidadeController = TextEditingController();

  bool dentroCarrinho = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo produto"),
        centerTitle: true,
        backgroundColor: Color(0xFFDDDEDF),
        actions: [
          IconButton(
              onPressed: (){},
              icon: Image.asset("images/barcode.png")
          )
        ],
      ),
      body: Padding(
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
                  setState(() {
                    loading = true;
                  });
                  await firestore
                      .collection("usuarios")
                      .doc("emailteste1@gmail.com")
                      .collection("produtos").add({
                    "codigo_barras" : codigoBarraController.text,
                    "dentro_carrinho" : dentroCarrinho,
                    "descricao" : descricaoController.text,
                    "quantidade" : int.parse(quantidadeController.text)
                  });
                  setState(() {
                    loading = false;
                  });
                },
                child: Text("Cadastrar produto")
            )
          ],
        ),
      ),
    );
  }
}
