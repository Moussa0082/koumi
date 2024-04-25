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
    print("Initialisation de la connexion");
    ConnectivityResult connectivityResult;
    try {
      connectivityResult = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
      return;
    }
    _connectionStatus.value = connectivityResult;
    checkConnection(connectivityResult);
  }

  void checkConnection(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      print("Connexion non disponible !");
      showNoConnectionSnackbar();
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }

  void showNoConnectionSnackbar() {
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
                color: Colors.white,
              ),
            ),
            Text(
              "Aucune connexion internet !",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: Text('Quitter'),
            ),
          ],
        ),
      ),
      messageText: Container(),
      backgroundColor: Colors.black87,
      isDismissible: true,
      duration: Duration(days: 1),
    );
  }
}
