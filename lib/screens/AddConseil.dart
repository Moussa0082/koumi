import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AddConseil extends StatefulWidget {
  const AddConseil({super.key});

  @override
  State<AddConseil> createState() => _AddConseilState();
}

class _AddConseilState extends State<AddConseil> {
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;

  

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
    if(!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
     if (!isRecorderReady) return;

    final path = await recorder.stopRecorder();
    final audioFile = File(path!);

    print('Recorded audio : $audioFile');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
            ),
            StreamBuilder<RecordingDisposition>(
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
                    style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                  );
                }),
            Center(
              child: ElevatedButton(
                child: Icon(
                  recorder.isRecording ? Icons.stop : Icons.mic,
                  size: 80,
                ),
                onPressed: () async {
                  if (recorder.isRecording) {
                    await stop();
                  } else {
                    await record();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
