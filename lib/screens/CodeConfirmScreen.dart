import 'package:flutter/material.dart';
import 'package:flutter_pin_code_widget/flutter_pin_code_widget.dart';
import 'package:koumi_app/screens/ResetPassScreen.dart';

class CodeConfirmScreen extends StatefulWidget {
  const CodeConfirmScreen({super.key});

  @override
  State<CodeConfirmScreen> createState() => _CodeConfirmScreenState();
}

class _CodeConfirmScreenState extends State<CodeConfirmScreen> {
 
  
     
  String email = "";
  String _pin = "";
  


  TextEditingController emailController = TextEditingController();
  // TextEditingController Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Expanded(
        child: Column(
          children: [
            SizedBox(height: 20,),
            // Back button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
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
              
            // Center image
            Center(child: Image.asset('assets/images/fg-pass.png')),
              
            // "Mot de passe oublié" text
            const Text(
              " Veuillez saisir votre code de confirmation ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF2B6706),
              ),
            ),
              
            // Code section
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "Code *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
              
            // OTP entry field
            const SizedBox(height: 15),
            Row(
              children: [
                // code pin start 
            Padding(
              padding: const EdgeInsets.only(left:40.0),
              child: SizedBox(
                height: 68,
                width: 240,
                child: Center(
                  child: PinCodeWidget(
                    buttonColor: Colors.black,
                    borderSide: BorderSide(width: 4,),
                    numbersStyle: TextStyle(color: Colors.black,),
                    minPinLength: 4,
                    maxPinLength: 25,
                    onChangedPin: (pin) {
                      // check the PIN length and check different PINs with 4,5.. length.
                    },
                    onEnter: (pin, _) {
                      // callback user pressed enter
                    },
                    centerBottomWidget: IconButton(
                      icon: const Icon(
                        Icons.fingerprint,
                        size: 10,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
              
              ],
            ),
          
           
            // Send button
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press action here
                  // Example:
                  if (_pin.length == 6) {
                    // Perform OTP verification using provided backend logic
                    // You'll need to implement your own verification logic
                    print("Verifying OTP: $_pin");
                    // If successful, navigate to reset password screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ResetPassScreen()),
                    );
                  } else {
                    // Show error message if OTP is incomplete
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid 6-digit OTP"),
                      ),
                    );
                  }
                },
                child: Text(
                  " Envoyer ",
                  style: TextStyle(
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
        ),
      ),
    );
      }


}