import 'package:firebase_core/firebase_core.dart';
import 'package:firestoreproject/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AnaSayfa());
}

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.black),
        debugShowCheckedModeBanner: false,
        home: firebasedata());
  }
}

class firebasedata extends StatefulWidget {
  const firebasedata({super.key});
  @override
  State<firebasedata> createState() => _firebasedataState();
}

class _firebasedataState extends State<firebasedata> {
  final _firestore = FirebaseFirestore.instance;
  TextEditingController nameController=TextEditingController();
  TextEditingController surnameController=TextEditingController();
  TextEditingController ageController=TextEditingController();
  TextEditingController eMailController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    CollectionReference inforef = _firestore.collection("kullanıcılar");
      DocumentReference documentReference = inforef.doc('2WWL53rvBBWjuM5rx8He');
    DocumentReference documentReference1 =
        _firestore.collection("kullanıcılar").doc('vefa');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Kullanıcı Kayıt Ekranı"),
        centerTitle: true,
      ),
      backgroundColor: Colors.deepPurpleAccent[700],
      body: Column(
        children: [
          const Center(
              child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Hoş Geldiniz..",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black),
            ),
          )),

          //VERİ ÇEKME İŞLEMİ----------
          
          /*  Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: () async{
              DocumentSnapshot response=await documentReference1.get(); //koleksiyonun içindeki bir dökümanın verisini alma
              var map=response.data();
              print(map);

              var responsecoll=await inforef.get(); //liste ile koleksiyonun datasını listeleme
              var list=responsecoll.docs;
              print(list[1].data());

              
            }, child: Text("Veriyi yazdır")),
          ),
         */
         


          SizedBox(
            height: 5,
          ),


          //VERİ SİLME İŞLEMİ------

          ElevatedButton(
              onPressed: () {
                documentReference1.delete();
              },
              child: Text("veri sil")),


          //StreamBuilder İLE ANLIK VERİ ALMA
          StreamBuilder<QuerySnapshot>(
            //StreamBuilder istenen alanlarda veriyi dinler
            stream: inforef.snapshots(), //hangi alanı dinleyeceği
            builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
              List<DocumentSnapshot> listOfDocumentSnap =
                  asyncSnapshot.data.docs;
              return Flexible(
                child: ListView.builder(
                  itemCount: listOfDocumentSnap
                      .length, //kaç tane list çizeceği  bilgisi
                  itemBuilder: (context, index) {
                    //ne yapması gerektiği bilgisi
                    return Card(
                      child: ListTile(
                        title: Text(
                          '${listOfDocumentSnap.length}',
                          style: TextStyle(fontSize: 24),
                        ),
                        subtitle: null,
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Form(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: " İsim"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller:surnameController ,
                    decoration: InputDecoration(hintText: " Soyad"),
                
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(hintText: " Yaş"),
                
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: eMailController,
                    decoration: InputDecoration(hintText: " E-Mail"),
                
                  ),
                ),
                       SizedBox(height: 50,)
          
          
              ],
            )),
          )
        ],
      ),


      //VERİ EKLEME


      floatingActionButton: FloatingActionButton(
        child: Text("Ekle"),
        onPressed: () async {
          Map<String,dynamic> infodata=
          {
            'name':nameController.text,
            'surname':surnameController.text,
            'age':ageController.text,
            'mail':eMailController.text
          };
         await inforef.doc(nameController.text).set(infodata); //oluşacak dökümanın auto Id ismi
          //set metodu map bir veri bekler ona oluşturduğumuz controller ları verdik.
        }),
    );
  }
}
