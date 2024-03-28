import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AddConseil extends StatefulWidget {
  const AddConseil({super.key});

  @override
  State<AddConseil> createState() => _AddConseilState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _AddConseilState extends State<AddConseil> {
  TextEditingController _titreController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  File? photoUploaded;
  File? videosUploaded;
  File? audiosUploaded;

  @override
  void initState() {
    super.initState();
    initRecoder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecoder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(Duration(milliseconds: 500));
  }

  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    if (!isRecorderReady) return;

    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    audiosUploaded = audioFile;
    print('Recorded audio : $audioFile');
    print('AudiosUploaded : $audiosUploaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 22,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Titre conseil",
                  style: TextStyle(color: (Colors.black), fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez remplir les champs";
                  }
                  return null;
                },
                controller: _titreController,
                decoration: InputDecoration(
                  hintText: "titre conseil",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 22,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Description",
                  style: TextStyle(color: (Colors.black), fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez remplir les champs";
                  }
                  return null;
                },
                controller: _descriptionController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Description",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            !recorder.isRecording
                ? Container()
                : StreamBuilder<RecordingDisposition>(
                    stream: recorder.onProgress,
                    builder: (context, snapshot) {
                      final duration = snapshot.hasData
                          ? snapshot.data!.duration
                          : Duration.zero;

                      String twoDigits(int n) => n.toString().padLeft(60);
                      final twoDigiMinutes =
                          twoDigits(duration.inMinutes.remainder(60));
                      final twoDigiSeconds =
                          twoDigits(duration.inSeconds.remainder(60));

                      return Text(
                        '$twoDigiMinutes:$twoDigiSeconds',
                        style: TextStyle(
                            fontSize: 80, fontWeight: FontWeight.bold),
                      );
                    }),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    elevation: MaterialStateProperty.all<double>(
                        0), // Supprimer l'élévation du bouton
                    overlayColor: MaterialStateProperty.all<Color>(Colors.grey
                        .withOpacity(
                            0.2)), // Couleur de l'overlay du bouton lorsqu'il est pressé
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                            color: d_colorGreen), // Bordure autour du bouton
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      "Télécharger un audio",
                      style: TextStyle(fontSize: 16, color: d_colorGreen),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    recorder.isRecording ? Icons.stop : Icons.mic,
                    size: 30,
                  ),
                  onPressed: () async {
                    if (recorder.isRecording) {
                      await stop();
                    } else {
                      await record();
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
