import 'package:flutter/material.dart';
import 'package:koumi_app/screens/RegisterScreen.dart';
import 'package:koumi_app/widgets/BottomNavigationPage.dart';

class LoginSuccessScreen extends StatefulWidget {
  const LoginSuccessScreen({super.key});

  @override
  State<LoginSuccessScreen> createState() => _LoginSuccessScreenState();
}

class _LoginSuccessScreenState extends State<LoginSuccessScreen> {
 

  String password = "";
  String email = "";
  bool _obscureText = true;


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
              // 
               const SizedBox(height: 10,),
                 const Text("Inscription", style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold , color: Color(0xFFF2B6706)),),
               Form(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               const SizedBox(height: 10,),
                // debut fullname 
                Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Email *", style: TextStyle(color:  (Colors.black), fontSize: 18),),
                ),
                TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: "Adresse email",
                        hintText: "Entrez votre adresse email",
                        // icon: const Icon(
                        //   Icons.mail,
                        //   color: Color(0xFFF2B6706),
                        //   size: 20,
                        // )
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
                  ),
                  // fin  adresse email
                    
                      const SizedBox(height: 10,),
                    
                         Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Mot de passe", style: TextStyle(color: (Colors.black), fontSize: 18),),
                ),
                // debut  mot de pass
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: "Mot de passe",
                        hintText: "Entrez votre mot de passe",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText =
                                  !_obscureText; // Inverser l'état du texte masqué
                            });
                          },
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons
                                    .visibility, // Choisir l'icône basée sur l'état du texte masqué
                            color: Colors.grey,
                          ),
                        ),
                        
                        ),
                    keyboardType: TextInputType.text,
                    obscureText: _obscureText,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veillez entrez votre  mot de passe";
                      }
                      if (val.length < 4) {
                        return 'Le mot de passe doit contenir au moins 4 caractères';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => password = val!,
                  ),
                  // fin mot de pass 

                  Center(
                    child: ElevatedButton(
              onPressed: () {
                // Handle button press action here
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavigationPage() ));
              },
              child:  Text(
                " Se connecter ",
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

            // Container(
              //    height: 40,
              //    decoration: BoxDecoration(
              //      color: Color.fromARGB(255, 240, 178, 107),
              //    ),
              //    child: Center(
              //      child: Row(
              //        mainAxisAlignment: MainAxisAlignment.center,
              //      children: [
              //       const  Text("Je n'ai pas de compte .",
              //        style: TextStyle(color: Colors.white, fontSize: 18, 
              //        fontWeight: FontWeight.bold),),
              //        const SizedBox(width: 4,),
              //        GestureDetector(
              //         onTap: (){
              //           Navigator.push(context, MaterialPageRoute(builder: (context)=> const RegisterScreen()));
              //         },
              //         child: const Text("M'inscrire", 
              //         style: TextStyle(color: Colors.blue, 
              //         fontSize: 18, 
              //         fontWeight: FontWeight.bold) ,
              //          ),
              //          ),
              //       ],
              //    ),
                 
              //    ),
                 
              //  ),

              ],
               )
               ),
            
              ],
            ),
            
          ),
        ),
      ),
    );
  }

}