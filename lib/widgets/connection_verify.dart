// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ConnectionVerify extends GetxController {
//   Connectivity _connectivity = Connectivity();

//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     _connectivity.onConnectivityChanged.listen(Netstatus);
//   }

//   Netstatus(ConnectivityResult cr) {
//     if (cr == ConnectivityResult.none) {
//       print("verification connection");
//       Get.rawSnackbar(
//           titleText: Container(
//             width: double.infinity,
//             height: Get.size.height * (.954),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Center(
//                   child: Icon(
//                     Icons.wifi_off,
//                     size: 120,
//                   ),
//                 ),
//                 Text("Aucune connexion internet !")
//               ],
//             ),
//           ),
//           messageText: Container(),
//           backgroundColor: Colors.black87,
//           isDismissible: false,
//           duration: Duration(days: 1));
//     } else {
//       if (Get.isSnackbarOpen) {
//         Get.closeCurrentSnackbar();
//       }
//     }
//   }
// }
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionVerify extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
    _connectivity.onConnectivityChanged.listen((result) {
      _connectionStatus.value = result;
      checkConnection(result);
    });
  }

  void initConnectivity() async {
    print("Iinitialisation de la connexion");
    ConnectivityResult connectivityResult;
    try {
      connectivityResult = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
      return;
    }
    // if (!mounted) {
    //   return;
    // }
    _connectionStatus.value = connectivityResult;
    checkConnection(connectivityResult);
  }

  void checkConnection(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      print("connexion non disponible !");
      Get.rawSnackbar(
        titleText: Container(
          width: double.infinity,
          height: Get.size.height * 0.954,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Icon(
                  Icons.wifi_off,
                  size: 120,
                ),
              ),
              Text("Aucune connexion internet !")
            ],
          ),
        ),
        messageText: Container(),
        backgroundColor: Colors.black87,
        isDismissible: false,
        duration: Duration(days: 1),
      );
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
