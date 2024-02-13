import 'package:flutter/material.dart';
import 'package:koumi_app/screens/CodeConfirmScreen.dart';
import 'package:koumi_app/widgets/BottomNavigationPage.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  

     
  String email = "";
  String whatsApp = "";
  


  TextEditingController emailController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();
   bool isVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isVisible = ! isVisible;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
              alignment: Alignment.topLeft,
              child:  IconButton(
             onPressed: () {
               // Fonction de retour
               Navigator.pop(context);
             },
             icon: Icon(
               Icons.arrow_back,
               color: Colors.black,
               size: 30,
             ),
             iconSize: 30,
             splashRadius: 20,
             padding: EdgeInsets.zero,
             constraints: BoxConstraints(minWidth: 40, minHeight: 40),
                        ),
            ),
            Center(child: Image.asset('assets/images/fg-pass.png')),
            // connexion
               const Text(" Mot de passe oublier  ", style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold , color: Color(0xFFF2B6706)),),
             Form(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const SizedBox(height: 10,),
              // debut email ou whats app  
              Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Text( isVisible ? " Email *" : "Whats App *" , style: TextStyle(color:  (Colors.black), fontSize: 18),),
              ),

              Visibility(
                visible: isVisible , 
                child: 
                 TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    labelText: "Email",
                    hintText: "Entrez votre adresse email",
                    ),
                keyboardType: TextInputType.text,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Veillez entrez votre adresse email";
                  } else {
                    return null;
                  }
                },
                onSaved: (val) => email = val!,
                ) ,
                replacement: SizedBox.shrink(child: 
               TextFormField(
                  controller: whatsAppController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: "Numéro WhatsApp",
                      hintText: "Entrez votre numéro whats app",
                      ),
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Veillez entrez votre numéro whats app";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) => whatsApp = val!,
                ),),
          ),
              
            ],
            ),
          ),

            TextButton(onPressed: (){
                  setState(() {
                    isVisible = !isVisible;
                  });
            }, child: Text(isVisible ? "Envoyer le code par whats app" : "Envoyer le code par mail", style: TextStyle(fontSize: 16),)),
        
             const SizedBox(height: 15,),
                Center(
                  child: ElevatedButton(
            onPressed: () {
              // Handle button press action here
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CodeConfirmScreen() ));
            },
            child:  Text(
              " Envoyer ",
              style:  TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8A00), // Orange color code
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              minimumSize: Size(250, 40),
            ),
          ),
           ),
            ]
                ),
              )
    )
    );
  }

}