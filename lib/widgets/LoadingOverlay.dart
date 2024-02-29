import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

   LoadingOverlay({
    required this.isLoading,
    required this.child,
     this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        isLoading
            ? Container(
                color: Colors.black.withOpacity(0.5), // Opacité pour l'arrière-plan
                child: Center(
                  child: CircularProgressIndicator(
                      backgroundColor: (Color.fromARGB(255, 245, 212, 169)),
          color: (Colors.orange),
                  ), 
                  // Indicateur de chargement
                ),
              )
            : SizedBox(), // Utilisé pour cacher l'indicateur de chargement
      ],
    );
  }
}
