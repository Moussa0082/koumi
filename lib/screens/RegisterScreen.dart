import 'package:flutter/material.dart';
import 'package:koumi_app/screens/RegisterNextScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  String fullname = "";
  String password = "";
  String telephone = "";
  String lastName = "";
  String email = "";
  bool _obscureText = true;

   List<String> options = ["Option 1", "Option 2", "Option 3"];

  // Valeur par défaut
  String selectedOption = "Option 1";

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  // TextEditingController Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
              Center(child: Image.asset('assets/images/logo.png', height: 200, width: 100,)),
               Container(
                 height: 40,
                 decoration: BoxDecoration(
                   color: Color.fromARGB(255, 240, 178, 107),
                 ),
                 child: Center(
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    const  Text("J'ai déjà un compte .",
                     style: TextStyle(color: Colors.white, fontSize: 18, 
                     fontWeight: FontWeight.bold),),
                     const SizedBox(width: 4,),
                     GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const RegisterNextScreen()));
                      },
                      child: const Text("Se connecter", 
                      style: TextStyle(color: Colors.blue, 
                      fontSize: 18, 
                      fontWeight: FontWeight.bold) ,
                       ),
                       ),
                    ],
                 ),
                 
                 ),
                 
               ),
               const SizedBox(height: 10,),
                 const Text("Inscription", style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold , color: Color(0xFFF2B6706)),),
               Form(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               const SizedBox(height: 10,),
                // debut fullname 
                Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Nom Complet *", style: TextStyle(color:  (Colors.black), fontSize: 18),),
                ),
                TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: "Nom Complet",
                        hintText: "Entrez votre prenom et nom",
                        // icon: const Icon(
                        //   Icons.mail,
                        //   color: Color(0xFFF2B6706),
                        //   size: 20,
                        // )
                        ),
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veillez entrez votre prenom et nom";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => fullname = val!,
                  ),
                  // fin  adresse fullname
  
                      const SizedBox(height: 10,),
                //Email debut 
                Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Email *", style: TextStyle(color:  (Colors.black), fontSize: 18),),
                ),
                TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: "Email",
                        hintText: "Entrez votre email",
                        // icon: const Icon(
                        //   Icons.mail,
                        //   color: Color(0xFFF2B6706),
                        //   size: 20,
                        // )
                        ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veillez entrez votre email";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => email = val!,
                  ),
                  // fin  adresse email
                      const SizedBox(height: 10,),

                      Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Téléphone *", style: TextStyle(color: (Colors.black), fontSize: 18),),
                ),
                TextFormField(
                    controller: telephoneController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: "Téléphone",
                        hintText: " (+223) XX XX XX XX ",
                        // icon: const Icon(
                        //   Icons.mail,
                        //   color: Color(0xFFF2B6706),
                        //   size: 20,
                        // )
                        ),
                    keyboardType: TextInputType.phone,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veillez entrez votre numéro de téléphone";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => telephone = val!,
                  ),
                  // fin  téléphone 
              const SizedBox(height: 10,),
                       Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Type Acteur *", style: TextStyle(color: (Colors.black), fontSize: 18),),
                ),

                const SizedBox(height: 5),

                //  selcet type acteur 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                menuMaxHeight: 90,
              isExpanded: true,
              value: selectedOption,
              items: options.map((option) {
                      return  DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                },
              
               ),
            ),
                //end select type acteur 
     const  SizedBox(height: 10,),

                  Center(
                    child: ElevatedButton(
              onPressed: () {
                // Handle button press action here
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterNextScreen() ));
              },
              child:  Text(
                " Suivant ",
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

              ],
               )),
            
              ],
            ),
            
          ),
        ),
      ),
    );
  }
}


