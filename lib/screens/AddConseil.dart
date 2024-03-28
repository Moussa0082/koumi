import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/ConseilService.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_uploader/video_uploader.dart';

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
  late Acteur acteur = Acteur();
  bool _isLoading = false;
  String? imageSrc;
  File? photoUploaded;
  File? _videoUploaded;
  late String videoSrc;
  File? audiosUploaded;
  final _tokenTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  double _progressValue = 0;
  bool _hasUploadStarted = false;

  void setProgress(double value) async {
    setState(() {
      _progressValue = value;
    });
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = path.basename(imagePath);
    final images = File('${directory.path}/$name');
    return images;
  }

  Future<void> _pickVideo(ImageSource source) async {
    final video = await ImagePicker().pickVideo(source: source);
    if (video == null) return;

    final videoFile = File(video.path);
    setState(() {
      _videoUploaded = videoFile;
      videoSrc = videoFile.path;
    });
  }

  Future<void> _showVideoSourceDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          child: AlertDialog(
            title: const Text('Choose a source'),
            content: Wrap(
              alignment: WrapAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close dialog
                    _pickVideo(ImageSource.camera);
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.videocam, size: 40),
                      Text('Camera'),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close dialog
                    _pickVideo(ImageSource.gallery);
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.video_library, size: 40),
                      Text('Gallery'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final images = await getImage(source);
    if (images != null) {
      setState(() {
        photoUploaded = images;
        imageSrc = images.path;
      });
    }
  }

  Future<File?> getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return null;

    return File(image.path);
  }

  Future<void> _showImageSourceDialog() async {
    final BuildContext context = this.context;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          child: AlertDialog(
            title: const Text('Choisir une source'),
            content: Wrap(
              alignment: WrapAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Fermer le dialogue
                    _pickImage(ImageSource.camera);
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.camera_alt, size: 40),
                      Text('Camera'),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Fermer le dialogue
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.image, size: 40),
                      Text('Galerie photo'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initRecoder();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
  }

  @override
  void dispose() {
    super.dispose();
    recorder.closeRecorder();
    _tokenTextController.dispose();
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
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 100,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: const Text(
            "Ajout conseil ",
            style: TextStyle(
              color: d_colorGreen,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          )),
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
            // _tokenTextController.text != null ? _videoUploade() : Container(),
            Row(
              children: [
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ButtonStyle(
                //     backgroundColor:
                //         MaterialStateProperty.all<Color>(Colors.transparent),
                //     elevation: MaterialStateProperty.all<double>(
                //         0), // Supprimer l'élévation du bouton
                //     overlayColor: MaterialStateProperty.all<Color>(Colors.grey
                //         .withOpacity(
                //             0.2)), // Couleur de l'overlay du bouton lorsqu'il est pressé
                //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                //       RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(18.0),
                //         side: BorderSide(
                //             color: d_colorGreen), // Bordure autour du bouton
                //       ),
                //     ),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 20, vertical: 10),
                //     child: Text(
                //       "Télécharger un audio",
                //       style: TextStyle(fontSize: 16, color: d_colorGreen),
                //     ),
                //   ),
                // ),
                IconButton(
                  icon: Icon(
                    Icons.camera,
                    size: 30,
                  ),
                  onPressed: _showImageSourceDialog,
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
                IconButton(
                    onPressed: _showVideoSourceDialog,
                    icon: Icon(
                      Icons.video_camera_front_rounded,
                      size: 30,
                    )),
              ],
            ),
            // _hasUploadStarted
            //     ? LinearProgressIndicator(
            //         color: d_colorGreen,
            //         backgroundColor: d_colorGreen,
            //         value: _progressValue,
            //       )
            //     : Container(),
            // _hasUploadStarted
            //     ? MaterialButton(
            //         color: d_colorGreen,
            //         child: const Text(
            //           "Cancel",
            //           style: TextStyle(
            //               color: Colors.white70, fontWeight: FontWeight.bold),
            //         ),
            //         onPressed: () async {
            //           try {
            //             await ApiVideoUploader.cancelAll();
            //           } catch (e) {
            //             log("Failed to cancel video: $e");
            //           }
            //         },
            //       )
            //     : Container(),
            photoUploaded != null
                ? Center(
                    child: Image.file(
                    photoUploaded!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ))
                : Text("aucun image"),
            if (_videoUploaded != null)
              Text('Video selected: ${_videoUploaded!.path}'),
            ElevatedButton(
                onPressed: () async {
                  // if (formkey.currentState!.validate()) {
                  final String titre = _titreController.text;
                  final String description = _descriptionController.text;
                  final String videoFile = _tokenTextController.text;
                  try {
                    // if (videoUploaded != null ||
                    //     photoUploaded != null ||
                    //     audiosUploaded != null) {}
                    await ConseilService()
                        .creerConseil(
                            titreConseil: titre,
                            descriptionConseil: description,
                            videoConseil: _videoUploaded,
                            photoConseil: photoUploaded,
                            // audioConseil: audiosUploaded,
                            acteur: acteur)
                        .then((value) => {
                              _titreController.clear(),
                              _descriptionController.clear(),
                              _tokenTextController.clear(),
                              setState(() {
                                _videoUploaded = null;
                                photoUploaded = null;
                                audiosUploaded = null;
                              })
                            })
                        .catchError((onError) => {
                              print("Error: " + onError.toString()),
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     content: Row(
                              //       children: [
                              //         Text(
                              //           "Une erreur est survenu lors de l'ajout",
                              //           style: TextStyle(overflow: TextOverflow.ellipsis),
                              //         ),
                              //       ],
                              //     ),
                              //     duration: Duration(seconds: 5),
                              //   ),
                              // )
                            });

                    // else {
                    //   await ConseilService()
                    //       .creerConseil(
                    //           titreConseil: titre,
                    //           descriptionConseil: description,
                    //           acteur: acteur)
                    //       .then((value) => {
                    //             _titreController.clear(),
                    //             _descriptionController.clear(),
                    //             _tokenTextController.clear(),
                    //           })
                    //       .catchError((onError) =>
                    //           {print("Error: " + onError.toString())});
                    // }
                  } catch (e) {
                    print("Error: " + e.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            Text(
                              "Une erreur est survenu lors de l'ajout",
                              style: TextStyle(overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Orange color code
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: const Size(290, 45),
                ),
                child: Text(
                  "Ajouter",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _videoUploade() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TextField(
            cursorColor: d_colorGreen,
            decoration: InputDecoration(
              hintText: "video upload",
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            controller: _tokenTextController,
          ),
        ),
        _hasUploadStarted
            ? LinearProgressIndicator(
                color: d_colorGreen,
                // backgroundColor: secondaryColor,
                value: _progressValue,
              )
            : Container(),
        _hasUploadStarted
            ? MaterialButton(
                color: d_colorGreen,
                child: const Text(
                  "Annuler",
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  try {
                    await ApiVideoUploader.cancelAll();
                  } catch (e) {
                    log("Failed to cancel video: $e");
                  }
                },
              )
            : Container(),
      ],
    );
  }

  void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.green);
  }

  void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(context, message,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 60),
        showCloseIcon: true);
  }

  void showSnackBar(BuildContext context, String message,
      {Color? backgroundColor,
      Duration duration = const Duration(seconds: 4),
      bool showCloseIcon = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        showCloseIcon: showCloseIcon,
      ),
    );
  }
}

extension ErrorExtension on Exception {
  String get message {
    if (this is PlatformException) {
      return (this as PlatformException).message ?? "Unknown error";
    }
    return toString();
  }
}
