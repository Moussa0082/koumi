import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/AlerteService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
 
class AddAlerte extends StatefulWidget {
  const AddAlerte({super.key});

  @override
  State<AddAlerte> createState() => _AddAlerteState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _AddAlerteState extends State<AddAlerte> {
  TextEditingController _titreController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final recorder = FlutterSoundRecorder();
  final formkey = GlobalKey<FormState>();
  bool isRecorderReady = false;
  late Acteur acteur = Acteur();
  bool _isLoading = false;
  String? imageSrc;
  File? photoUploaded;
  File? _videoUploaded;
  late String videoSrc;
  File? audiosUploaded;
  final _tokenTextController = TextEditingController();
  final _tokenAudioController = TextEditingController();
  final _tokenImageController = TextEditingController();
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
      _tokenTextController.text = _videoUploaded!.path.toString();
      videoSrc = videoFile.path;
      _hasUploadStarted = true;
    });

    // Mocking upload progress
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 40));
      setProgress(i / 100);
    }

    setState(() {
      _hasUploadStarted = false;
    });
  }

  Future<void> _showVideoSourceDialog() async {
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
        _tokenImageController.text = photoUploaded!.path.toString();

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
    _tokenAudioController.dispose();
    _tokenImageController.dispose();
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
    print("Path audio : $path");
    final audioFile = File(path!);
    audiosUploaded = audioFile;
    _tokenAudioController.text = audiosUploaded!.path.toString();
    print('Recorded audio : $audioFile');
    print('audiosUploaded : $audiosUploaded');
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
        isLoading: _isLoading,
        child: Scaffold(
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
                  "Ajout Alerte ",
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
                    Form(
                        key: formkey,
                        child: Column(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 22,
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Titre Alerte",
                                style: TextStyle(
                                    color: (Colors.black), fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Veuillez remplir les champs";
                                }
                                return null;
                              },
                              controller: _titreController,
                              decoration: InputDecoration(
                                hintText: "titre Alerte",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
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
                                style: TextStyle(
                                    color: (Colors.black), fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
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
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _tokenTextController.text.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 22,
                                  ),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Video Source",
                                      style: TextStyle(
                                          color: (Colors.black), fontSize: 18),
                                    ),
                                  ),
                                )
                              : Container(),
                          _tokenTextController.text.isNotEmpty
                              ? _videoUploade()
                              : Container(),
                          _tokenImageController.text.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 22,
                                  ),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Image Source",
                                      style: TextStyle(
                                          color: (Colors.black), fontSize: 18),
                                    ),
                                  ),
                                )
                              : Container(),
                          _tokenImageController.text.isNotEmpty
                              ? _imageUploade()
                              : Container(),
                          _tokenAudioController.text.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 22,
                                  ),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Audio Source",
                                      style: TextStyle(
                                          color: (Colors.black), fontSize: 18),
                                    ),
                                  ),
                                )
                              : Container(),
                          _tokenAudioController.text.isNotEmpty
                              ? _audioUploade()
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          !recorder.isRecording
                              ? Container()
                              : SizedBox(
                                  child: Center(
                                    child: StreamBuilder<RecordingDisposition>(
                                      stream: recorder.onProgress,
                                      builder: (context, snapshot) {
                                        final duration = snapshot.hasData
                                            ? snapshot.data!.duration
                                            : Duration.zero;

                                        String twoDigits(int n) =>
                                            n.toString().padLeft(60);
                                        final twoDigiMinutes = twoDigits(
                                            duration.inMinutes.remainder(60));
                                        final twoDigiSeconds = twoDigits(
                                            duration.inSeconds.remainder(60));

                                        return Center(
                                          child: Text(
                                            '$twoDigiMinutes:$twoDigiSeconds',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                          _hasUploadStarted
                              ? LinearProgressIndicator(
                                  color: d_colorGreen,
                                  backgroundColor: d_colorOr,
                                  value: _progressValue,
                                )
                              : Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.camera,
                                  size: 30,
                                ),
                                onPressed: _showImageSourceDialog,
                              ),
                              IconButton(
                                  onPressed: _showVideoSourceDialog,
                                  icon: Icon(
                                    Icons.video_camera_front_rounded,
                                    size: 30,
                                  )),
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
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  final String titre = _titreController.text;
                                  final String description =
                                      _descriptionController.text;
                                  final String videoFile =
                                      _tokenTextController.text;
                                  try {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    if (_videoUploaded != null ||
                                        photoUploaded != null ||
                                        audiosUploaded != null) {
                                      await AlertesService()
                                          .creerAlertes(
                                              titreAlerte: titre,
                                              descriptionAlerte: description,
                                              videoAlerte: _videoUploaded,
                                              audioAlerte: audiosUploaded,
                                              photoAlerte: photoUploaded)
                                          .then((value) => {
                                                _titreController.clear(),
                                                _descriptionController.clear(),
                                                _tokenTextController.clear(),
                                                _tokenAudioController.clear(),
                                                _tokenImageController.clear(),
                                                setState(() {
                                                  _videoUploaded = null;
                                                  photoUploaded = null;
                                                  audiosUploaded = null;
                                                  _isLoading = false;
                                                }),
                                                Provider.of<AlertesService>(
                                                        context,
                                                        listen: false)
                                                    .applyChange(),
                                                Navigator.of(context).pop()
                                              })
                                          .catchError((onError) => {
                                                print("Error: " +
                                                    onError.toString()),
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Row(
                                                      children: [
                                                        Text(
                                                          "Une erreur est survenu lors de l'ajout",
                                                          style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      ],
                                                    ),
                                                    duration:
                                                        Duration(seconds: 5),
                                                  ),
                                                )
                                              });
                                    } else {
                                      await AlertesService()
                                          .creerAlertes(
                                              titreAlerte: titre,
                                              descriptionAlerte: description)
                                          .then((value) => {
                                                _titreController.clear(),
                                                _descriptionController.clear(),
                                                _tokenTextController.clear(),
                                                setState(() {
                                                  _isLoading = false;
                                                }),
                                                Provider.of<AlertesService>(
                                                        context,
                                                        listen: false)
                                                    .applyChange(),
                                                Navigator.of(context).pop()
                                              })
                                          .catchError((onError) => {
                                                print("Error: " +
                                                    onError.toString())
                                              });
                                    }
                                  } catch (e) {
                                    print("Error: " + e.toString());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Row(
                                          children: [
                                            Text(
                                              "Une erreur est survenu lors de l'ajout",
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                        duration: Duration(seconds: 5),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.orange, // Orange color code
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
                        ]))
                  ]),
            )));
  }

  Widget _videoUploade() {
    return Padding(
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
    );
  }

  Widget _imageUploade() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        cursorColor: d_colorGreen,
        decoration: InputDecoration(
          hintText: "Image upload",
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        controller: _tokenImageController,
      ),
    );
  }

  Widget _audioUploade() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        cursorColor: d_colorGreen,
        decoration: InputDecoration(
          hintText: "Audio upload",
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        controller: _tokenAudioController,
      ),
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
