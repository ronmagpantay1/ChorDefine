import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chordefine/main.dart';
import 'package:chordefine/screens/progress.dart';
import 'package:chordefine/screens/tunerscreen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'dart:async';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:image/image.dart' as img;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minor Chords',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PracticeScreenMinor(
        title: 'Minor Chords',
      ),
    );
  }
}

class PracticeScreenMinor extends StatefulWidget {
  const PracticeScreenMinor({Key? key, required String title})
      : super(key: key);

  @override
  _PracticeScreenMinorState createState() => _PracticeScreenMinorState();
}

class _PracticeScreenMinorState extends State<PracticeScreenMinor> {
  final List<String> exploreItems = [
    'A Minor',
    'B Minor',
    'C Minor',
    'D Minor',
    'E Minor',
    'F Minor',
    'G Minor',
  ];

  
  int getExpectedFret(String chordName) {
    switch (chordName) {
      case 'C':
      case 'B':
      case 'E':
      case 'F':
        return 2; // 2nd fret
      case 'A':
      case 'D':
        return 1; // 1st fret
      case 'G':
        return 3;
      default:
        return 1; // Default to 1st fret
    }
  }

  final PracticeScreenMinorController controller =
      Get.put(PracticeScreenMinorController());

  final Map<String, List<String>> songImages = {
    'A Minor': [
      'assets/picture/13.png',
      'assets/picture/12.png',
      'assets/picture/18.png',
      'assets/picture/8.png',
      'assets/picture/am.png'
    ],
    'B Minor': [
      'assets/picture/13.png',
      'assets/picture/12.png',
      'assets/picture/14.png',
      'assets/picture/9.png',
      'assets/picture/bm.png'
    ],
    'C Minor': [
      'assets/picture/13.png',
      'assets/picture/12.png',
      'assets/picture/cminor1.jpg',
      'assets/picture/cminor.jpg',
      'assets/picture/bm.png'
    ],
    'D Minor': [
      'assets/picture/13.png',
      'assets/picture/12.png',
      'assets/picture/15.png',
      'assets/picture/10.png',
      'assets/picture/dm.png'
    ],
    'E Minor': [
      'assets/picture/13.png',
      'assets/picture/12.png',
      'assets/picture/16.png',
      'assets/picture/11.png',
      'assets/picture/em.png'
    ],
    'F Minor': [
      'assets/picture/13.png',
      'assets/picture/12.png',
      'assets/picture/fminor1.jpg',
      'assets/picture/fminor.jpg',
      'assets/picture/bm.png'
    ],
    'G Minor': [
      'assets/picture/13.png',
      'assets/picture/12.png',
      'assets/picture/gminor1.jpg',
      'assets/picture/gminor.jpg',
      'assets/picture/bm.png'
    ],
  };

  final Map<String, String> expectedChords = {
    'A Minor': 'E',
    'B Minor': 'F',
    'C Minor': 'F',
    'D Minor': 'C',
    'E Minor': 'A',
    'F Minor': 'F',
    'G Minor': 'F',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Minor Chords',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemCount: exploreItems.length,
                  itemBuilder: (context, index) {
                    final songTitle = exploreItems[index];
                    final expectedChord = expectedChords[songTitle]!;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChordDetailsMinor(
                              title: songTitle,
                              images: songImages[songTitle]!,
                              expectedChord: expectedChords[
                                  songTitle]!, // Extracts "A" from "A Minor"
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(245, 245, 110, 15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() {
                              return Icon(
                                controller.completedChords.contains(songTitle)
                                    ? Icons.music_note
                                    : Icons.music_note_outlined,
                                color: controller.completedChords
                                        .contains(songTitle)
                                    ? Colors.green
                                    : const Color.fromARGB(255, 255, 255, 255),
                              );
                            }),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    songTitle,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Tap to view details',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward,
                                  color: Color.fromARGB(247, 255, 255, 255)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CameraScreenMinor(
                                      chordNamees: songTitle,
                                      expectedChord: expectedChord,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PracticeScreenMinorController extends GetxController {
  final completedChords = <String>{}.obs; // Using Set to prevent duplicates

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('minorCompletedChords', completedChords.toList());
  }

  Future<void> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final savedChords = prefs.getStringList('minorCompletedChords');
    if (savedChords != null) {
      completedChords.addAll(savedChords);
    }
  }

  void addCompletedChord(String chord) {
    if (!completedChords.contains(chord)) {
      completedChords.add(chord);
      saveNotifications(); // Save after adding a new chord
    }
  }

  void clearNotifications() {
    completedChords.clear();
    saveNotifications();
  }

  // Function to check if all Minor chords are completed
  bool areAllChordsCompleted() {
    return completedChords.length == 7; // 7 Minor chords in total
  }
}

class ChordDetailsMinor extends StatelessWidget {
  final String title;
  final List<String> images;
  final String expectedChord;

  const ChordDetailsMinor({
    Key? key,
    required this.title,
    required this.images,
    required this.expectedChord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              items: images
                  .map((imagePath) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 500.0,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                autoPlay: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    minimumSize: const Size(150, 50),
                    backgroundColor: const Color.fromARGB(245, 245, 110, 15),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _showConfirmationDialog(
                      context, expectedChord, title), // Pass expectedChord
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    minimumSize: const Size(150, 50),
                    backgroundColor: const Color.fromARGB(245, 245, 110, 15),
                  ),
                  child: const Text(
                    'Proceed',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Add getExpectedFret here, or make it a global function
  int getExpectedFret(String chordName) {
    switch (chordName) {
      case 'C':
      case 'B':
      case 'E':
      case 'F':
        return 2; // 2nd fret
      case 'A':
      case 'D':
        return 1; // 1st fret
      case 'G':
        return 3;
      default:
        return 1; // Default to 1st fret
    }
  }

  void _showConfirmationDialog(BuildContext context, String expectedChord, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Are you sure you want to proceed to the camera?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog

                // Navigate to FretDetectionScreenMinor
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FretDetectionScreenMinor(
                      expectedChord: expectedChord,
                      expectedFret: getExpectedFret(expectedChord),
                      songTitle: title,
                      title: title, 
                    ),
                  ),
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}

class FretDetectionScreenMinor extends StatefulWidget {
  final String expectedChord;
  final int expectedFret; // Add expected fret
  final String songTitle;
  final String title;

  const FretDetectionScreenMinor(
      {Key? key, required this.expectedChord, required this.expectedFret, required this.songTitle, required this.title,})
      : super(key: key);

  @override
  _FretDetectionScreenMinorState createState() =>
      _FretDetectionScreenMinorState();
}

class _FretDetectionScreenMinorState extends State<FretDetectionScreenMinor> {
  late CameraController _controller;
  late FlutterVision _vision;
  bool _isCameraReady = false;
  bool _isDetecting = false;
  bool _showDetectionButton = true;
  String _detectionStatus = 'Position your finger on the fretboard';
  XFile? _capturedImage;
  int getExpectedFret(String chordName) {
    switch (chordName) {
      case 'C':
      case 'B':
      case 'E':
      case 'F':
        return 2; // 2nd fret
      case 'A':
      case 'D':
        return 1; // 1st fret
      case 'G':
        return 3;
      default:
        return 1; // Default to 1st fret
    }
  }


  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeModel();
  }

  Future<void> _initializeCamera() async {
    final camera = cameras
        .firstWhere((cam) => cam.lensDirection == CameraLensDirection.front);
    _controller = CameraController(camera, ResolutionPreset.medium);

    await _controller.initialize();
    if (!mounted) return;
    setState(() => _isCameraReady = true);
  }

  Future<void> _initializeModel() async {
    _vision = FlutterVision();
    await _vision.loadYoloModel(
      modelPath: 'assets/fretmodel.tflite', // Your fret model
      labels: 'assets/fretlabels.txt', // Your fret labels
      modelVersion: "yolov8",
    );
  }

  Future<void> _captureAndDetect() async {
    if (!_isCameraReady || _isDetecting) return;

    setState(() {
      _detectionStatus = "Detecting fret position...";
    });

    _capturedImage = await _controller.takePicture();

    if (_capturedImage != null) {
      _processImage(await _capturedImage!.readAsBytes());
    }
    void _showConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Confirmation"),
            content:
                const Text("Are you sure you want to proceed to the camera?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FretDetectionScreenMinor(
                        expectedChord:
                            widget.expectedChord, // Use chordName here
                        expectedFret: getExpectedFret(widget.expectedChord),
                        songTitle: widget.songTitle, // Use widget.songTitle here
                      title: widget.songTitle,
                      ),
                    ),
                  );
                },
                child: const Text("Yes"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _processImage(Uint8List imgBytes) async {
  _isDetecting = true;
  try {
    final resizedBytes = await _preprocessImage(imgBytes);
    final results = await _vision.yoloOnImage(
      bytesList: resizedBytes,
      imageHeight: 640,
      imageWidth: 640,
      iouThreshold: 0.5,
      confThreshold: 0.5,
      classThreshold: 0.6,
    );

    if (results.isNotEmpty) {
      // Get the detected zones (excluding "Hand")
      final detectedZones = results
          .map((result) => result['tag'])
          .where((zone) => zone != 'Hand')
          .toList();

      // Check if the expected fret zone is NOT present in the detected zones
      final expectedFretZone = 'Zone${widget.expectedFret}';
      if (!detectedZones.contains(expectedFretZone)) {
        _showSuccessDialog();
      } else {
        setState(() => _detectionStatus =
            'Incorrect fret position.');
        _showFailDialog();
      }
    } else {
      setState(() => _detectionStatus =
          'Incorrect fret position.');
      _showFailDialog();
    }
  } catch (e) {
    print("Detection error: $e");
  } finally {
    _isDetecting = false;
  }
}

  Future<Uint8List> _preprocessImage(Uint8List imgBytes) async {
    img.Image? originalImage = img.decodeImage(imgBytes);
    if (originalImage != null) {
      img.Image resizedImage =
          img.copyResize(originalImage, width: 640, height: 640);
      return Uint8List.fromList(img.encodeJpg(resizedImage));
    } else {
      throw Exception('Failed to decode image');
    }
  }

  void _showSuccessDialog() {
    setState(() {
      _detectionStatus = 'Correct fret detected!';
    });

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Congratulations!",
      desc: "You have positioned your finger on the correct fret!",
      btnOkOnPress: () {
        // Navigate to CameraScreenMinor after success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CameraScreenMinor(
              chordNamees:widget.songTitle,
              expectedChord: widget.expectedChord,
            ),
          ),
        );
      },
    ).show();
  }

  void _showFailDialog() {
    Future.delayed(Duration(seconds: 1), () {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        btnOkText: "Retry",
        title: "Keep Trying!",
        desc: "Make sure your finger is positioned correctly on the fret.",
        btnOkOnPress: () {
          _captureAndDetect();
        },
      ).show();
    });
  }

  Future<void> _closeResources() async {
    await _controller.stopImageStream();
    await _controller.dispose();
    await _vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  'Detecting ${widget.songTitle} Chord '
                  'Fret Position',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  child: _isCameraReady
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: CameraPreview(_controller),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
              Text(
                _detectionStatus,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              if (_showDetectionButton)
              ElevatedButton(
                onPressed: () {
                  _captureAndDetect(); // Call the capture and detect function
                  setState(() {
                    _showDetectionButton =
                        false; // Set the button visibility to false
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      245, 245, 110, 15), // Set your desired button color here
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // Optional padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Optional rounded corners
                  ),
                ),
                child: const Text(
                  "Start Detection",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                _closeResources();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const PracticeScreenMinor(title: 'Minor Chords')),
                );
              },
              backgroundColor: const Color.fromARGB(245, 245, 110, 15),
              child: const Icon(Icons.cancel),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _closeResources();
    super.dispose();
  }
}

class CameraScreenMinor extends StatefulWidget {
  final String expectedChord;
  final String chordNamees;

  const CameraScreenMinor({Key? key, required this.expectedChord, required this.chordNamees,})
      : super(key: key);

  @override
  _CameraScreenMinorState createState() => _CameraScreenMinorState();
}

class _CameraScreenMinorState extends State<CameraScreenMinor> {
  bool _showDetectionButton = true;
  late CameraController _controller;
  late FlutterVision _vision;
  bool _isCameraReady = false;
  bool _isDetecting = false;
  String _detectionStatus = '...';
  XFile? _capturedImage;
  bool _showDetectionArea = true; // Controls visibility of camera detection UI

  // Audio Detection variables
  final NoteChordControllerMinor _audioController =
    Get.put(NoteChordControllerMinor(expectedChord: '', chordNamees: '')); 
  bool _isAudioDetecting = false;

  final double _iouThreshold = 0.5;
  final double _confThreshold = 0.5;
  final double _classThreshold = 0.6;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeModel();
    _audioController.expectedChord =
        widget.expectedChord; // Set the expected chord for audio detection
  }

  Future<void> _initializeCamera() async {
    final camera = cameras
        .firstWhere((cam) => cam.lensDirection == CameraLensDirection.front);
    _controller = CameraController(camera, ResolutionPreset.medium);

    await _controller.initialize();
    if (!mounted) return;
    setState(() => _isCameraReady = true);
  }

  Future<void> _initializeModel() async {
    _vision = FlutterVision();
    await _vision.loadYoloModel(
      modelPath: 'assets/major.tflite',
      labels: 'assets/labels.txt',
      modelVersion: "yolov8",
    );
  }

  Future<void> _captureAndDetect() async {
    if (!_isCameraReady || _isDetecting) return;

    setState(() {
      _detectionStatus = "Capturing Chord...";
    });

    _capturedImage = await _controller.takePicture();

    if (_capturedImage != null) {
      setState(() => _detectionStatus = "Processing Chord...");
      _processImage(await _capturedImage!.readAsBytes());
    }
  }

  Future<void> _processImage(Uint8List imgBytes) async {
    _isDetecting = true;
    try {
      final resizedBytes = await _preprocessImage(imgBytes);
      final results = await _vision.yoloOnImage(
        bytesList: resizedBytes,
        imageHeight: 640,
        imageWidth: 640,
        iouThreshold: _iouThreshold,
        confThreshold: _confThreshold,
        classThreshold: _classThreshold,
      );

      if (results.isNotEmpty) {
        final detectedChord = results[0]['tag'];
        if (detectedChord == widget.expectedChord) {
          _showSuccessDialog();
        } else {
          setState(() => _detectionStatus = 'Incorrect chord detected');
          _showFailDialog();
        }
      } else {
        setState(() => _detectionStatus = 'Incorrect chord detected');
        _showFailDialog();
      }
    } catch (e) {
      print("Detection error: $e");
    } finally {
      _isDetecting = false;
    }
  }

  Future<Uint8List> _preprocessImage(Uint8List imgBytes) async {
    img.Image? originalImage = img.decodeImage(imgBytes);
    if (originalImage != null) {
      img.Image resizedImage =
          img.copyResize(originalImage, width: 640, height: 640);
      return Uint8List.fromList(img.encodeJpg(resizedImage));
    } else {
      throw Exception('Failed to decode image');
    }
  }

  void _showSuccessDialog() {
    setState(() {
      _detectionStatus = '${widget.chordNamees} chord detected';
      _showDetectionArea = false; // Hide camera detection UI
      _isAudioDetecting = true; // Start audio detection
      _audioController.startCapture(); // Start audio capture
    });

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Congratulations!",
      desc: "You have performed the chord correctly!",
      btnOkOnPress: () {},
    ).show();
  }

  void _showFailDialog() {
    Future.delayed(const Duration(seconds: 1), () {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        btnOkText: "Retry",
        title: "Keep Trying!",
        desc: "Make sure you are performing the chord correctly.",
        btnOkOnPress: () {
          _captureAndDetect();
        },
      ).show();
    });
  }

  Future<void> _closeResources() async {
    await _controller.stopImageStream();
    await _controller.dispose();
    await _vision.closeYoloModel();
    _audioController.onClose(); // Close audio resources
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera Preview
          _isCameraReady
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: CameraPreview(_controller),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),

          // Detection Area (Conditional rendering)
          if (_showDetectionArea)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text(
                    'Detecting ${widget.chordNamees} Chord',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Text(
                  _detectionStatus,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                if (_showDetectionButton) // Conditional rendering of the button
                  ElevatedButton(
                    onPressed: () {
                      _captureAndDetect();
                      setState(() => _showDetectionButton = false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(245, 245, 110, 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Start Detection",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            ),

          // Audio Detection UI (Conditional rendering)
          if (_isAudioDetecting)
            Column(
              children: [
                // Retain the detecting text from the camera screen
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text(
                    'Detecting ${widget.chordNamees} Chord',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),

                // Spacer to push the icon and text below the camera preview
                const Spacer(),

                // Icon and Text in the middle below the camera
                Expanded(
                  // Use Expanded to take available space
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center the elements vertically
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Image.asset(
                          'assets/images/mike.png',
                          height: 120,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() => Text(
                            "Recognized Chord: ${_audioController.recognizedChord.value}",
                            style: const TextStyle(fontSize: 15),
                            textAlign: TextAlign.center,
                          )),
                      const SizedBox(height: 20),
                      Obx(() => Text(
                            _audioController.output.value,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _audioController.output.value ==
                                      "Correct! You played ${widget.expectedChord}"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          )),
                    ],
                  ),
                ),

                // Add some bottom padding to avoid overlap with buttons
                const SizedBox(height: 100),
              ],
            ),

          // Cancel Button
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                _closeResources();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const PracticeScreenMinor(title: 'Minor Chords')),
                );
              },
              backgroundColor: const Color.fromARGB(245, 245, 110, 15),
              child: const Icon(Icons.cancel),
            ),
          ),

          // Done Button (Audio Detection)
          if (_isAudioDetecting)
            Positioned(
              bottom: 20,
              right: 20,
              child: Obx(() {
                return _audioController.showDoneButton.value
                    ? FloatingActionButton(
                        onPressed: () {
                          _audioController.markChordAsCompleted();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyProgress()),
                          );
                        },
                        backgroundColor:
                            const Color.fromARGB(245, 245, 110, 15),
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : const SizedBox.shrink();
              }),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _closeResources();
    super.dispose();
  }
}

class NoteChordControllerMinor extends GetxController {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);

  var hasAudioPermission = false.obs;
  var currentPitch = 0.0.obs;
  var recognizedNote = ''.obs;
  var recognizedChord = ''.obs;
  var output = 'Listening...'.obs;
  var showDoneButton = false.obs;
  bool detectionComplete = false;

  final List<double> recentFrequencies = [];
  static const int frequencyBufferSize = 12;

  Timer? chordDetectionTimer;
  late final String expectedChord;
  final String chordNamees;

    NoteChordControllerMinor({required this.expectedChord, required this.chordNamees});

  @override
  void onInit() {
    super.onInit();
    requestAudioPermission();
  }

  Future<void> requestAudioPermission() async {
    if (await Permission.microphone.request().isGranted) {
      hasAudioPermission.value = true;
      startCapture();
    }
  }

  Future<void> startCapture() async {
    await _audioRecorder.start(listener, error,
        sampleRate: 44100, bufferSize: 1400);
    chordDetectionTimer =
        Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!detectionComplete) {
        recognizeChord();
      }
    });
  }

  void listener(dynamic obj) {
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();
    final result = pitchDetectorDart.getPitch(audioSample);

    if (result.pitched) {
      currentPitch.value = result.pitch;
      updateRecentFrequencies(result.pitch);
      recognizedNote.value = findClosestNote(result.pitch);
    }
  }

  void updateRecentFrequencies(double frequency) {
    if (recentFrequencies.isEmpty ||
        (frequency - recentFrequencies.last).abs() > 1.0) {
      recentFrequencies.add(frequency);
      if (recentFrequencies.length > frequencyBufferSize) {
        recentFrequencies.removeAt(0);
      }
    }
  }

  String findClosestNote(double frequency) {
    double minDifference = double.infinity;
    String closestNote = '';

    noteFrequencies.forEach((freq, note) {
      double difference = (frequency - freq).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closestNote = note;
      }
    });

    return minDifference < 2.0 ? closestNote : '';
  }

  void recognizeChord() {
  List<String> currentNotes = recentFrequencies
      .map((freq) => findClosestNote(freq))
      .where((note) => note.isNotEmpty)
      .toSet()
      .toList();

  if (currentNotes.length >= 3) {
    recognizedChord.value = identifyChord(currentNotes);

    // Extract the base note (e.g., "A" from "A minor")
    String baseChordName = chordNamees.split(' ')[0];

    if (recognizedChord.value == baseChordName) {
      output.value = "Correct! You played $chordNamees";  // Display full chordName for user feedback
      detectionComplete = true;
      showDoneButton.value = true;
    } else if (!detectionComplete) {
      output.value = "Incorrect. Try playing $chordNamees";  // Use full chordName in feedback
    }
  } else {
    recognizedChord.value = 'Not enough notes for chord';
  }
}

  String identifyChord(List<String> notes) {
    Set<String> noteSet = notes.toSet();

    if (noteSet.contains('A1') && noteSet.contains('A2')) {
      return 'A';
    } else if (noteSet.contains('B1')) {
      return 'B';
    } else if (noteSet.contains('C2') || noteSet.contains('C3')) {
      return 'C';
    } else if (noteSet.contains('D3') || noteSet.contains('D1')) {
      return 'D';
    } else if (noteSet.contains('#G3') ||
        noteSet.contains('E1') ||
        noteSet.contains('E2')) {
      return 'E';
    } else if (noteSet.contains('F1') || noteSet.contains('F2')) {
      return 'F';
    } else if (noteSet.contains('G1') || noteSet.contains('G2')) {
      return 'G';
    } else {
      return 'Unknown chord';
    }
  }

  void error(Object e) {
    print('Error in audio capture: $e');
  }

  void markChordAsCompleted() {
    Get.find<PracticeScreenMinorController>().addCompletedChord(expectedChord);
  }

  @override
  void onClose() {
    _audioRecorder.stop();
    chordDetectionTimer?.cancel();
    super.onClose();
  }
}

class AudioDetectionScreenMinor extends StatelessWidget {
  final String expectedChord;
  final String chordNamees;

  const AudioDetectionScreenMinor({
    Key? key,
    required this.chordNamees,
    required this.expectedChord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<NoteChordControllerMinor>()) {
      Get.delete<NoteChordControllerMinor>();
    }
    int wrongchordcount = 0;
    final controller = Get.put(NoteChordControllerMinor(
      expectedChord: expectedChord,
      chordNamees: chordNamees,  // Pass chordName to controller
    ));
    ever(controller.output, (String output) {
      if (output == "Correct! You played $expectedChord") {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          showCloseIcon: true,
          animType: AnimType.topSlide,
          title: "Congratulations!",
          desc: "You have played the chord correctly!",
          btnOkOnPress: () {},
          btnOkIcon: Icons.check,
        ).show();
      } else {
        wrongchordcount++;
      }
      if (wrongchordcount == 2) {
        Future.delayed(const Duration(seconds: 1), () {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            btnOkText: "Tune",
            title: "Wrong Chord!",
            btnCancelOnPress: () {},
            desc: "Have you tuned your guitar?",
            btnOkOnPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TunerScreen()),
              );
            },
          ).show();
        });
        wrongchordcount = 0;
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Obx(() {
                if (!controller.hasAudioPermission.value) {
                  return const Text("No audio permission provided");
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        'Detecting ${chordNamees}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Image.asset(
                        'assets/images/mike.png', // Placeholder for the microphone image
                        height: 50,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Recognized Chord: ${controller.recognizedChord.value}",
                      style: const TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      controller.output.value,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: controller.output.value == "Correct Chord"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PracticeScreenMinor(
                            title: 'Minor Chords',
                          )),
                );
              },
              backgroundColor: const Color.fromARGB(245, 245, 110, 15),
              child: const Icon(Icons.cancel),
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        return controller.showDoneButton.value
            ? FloatingActionButton(
                onPressed: () {
                  controller.markChordAsCompleted();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyProgress()),
                  );
                },
                backgroundColor: const Color.fromARGB(245, 245, 110, 15),
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : const SizedBox.shrink();
      }),
    );
  }
}

var noteFrequencies = {
  32.7: 'C1',
  34.65: '#C1',
  36.71: 'D1',
  38.89: '#D1',
  41.2: 'E1',
  43.65: 'F1',
  46.25: '#F1',
  49.0: 'G1',
  51.91: '#G1',
  55.0: 'A1',
  58.27: '#A1',
  61.74: 'B1',
  65.41: 'C2',
  69.3: '#C2',
  73.42: 'D2',
  77.78: '#D2',
  82.41: 'E2',
  87.31: 'F2',
  92.5: '#F2',
  98.0: 'G2',
  103.83: '#G2',
  110.0: 'A2',
  116.54: '#A2',
  123.47: 'B2',
  130.81: 'C3',
  138.59: '#C3',
  146.83: 'D3',
  155.56: '#D3',
  164.81: 'E3',
  174.61: 'F3',
  185.0: '#F3',
  196.0: 'G3',
  207.65: '#G3',
  220.0: 'A3',
  233.08: '#A3',
  246.94: 'B3',
  261.63: 'C4',
  277.18: '#C4',
  293.66: 'D4',
  311.13: '#D4',
  329.63: 'E4',
  349.23: 'F4',
  369.99: '#F4',
  392.0: 'G4',
  415.3: '#G4',
  440.0: 'A4',
  466.16: '#A4',
  493.88: 'B4',
  523.25: 'C5',
  554.37: '#C5',
  587.33: 'D5',
  622.25: '#D5',
  659.25: 'E5',
  698.46: 'F5',
  739.99: '#F5',
  783.99: 'G5',
  830.61: '#G5',
  880.0: 'A5',
  932.33: '#A5',
  987.77: 'B5',
  1046.5: 'C6',
  1108.73: '#C6',
  1174.66: 'D6',
  1244.51: '#D6',
  1318.51: 'E6',
  1396.91: 'F6',
  1479.98: '#F6',
  1567.98: 'G6',
  1661.22: '#G6',
  1760.0: 'A6',
  1864.66: '#A6',
  1975.53: 'B6',
  2093.0: 'C7',
};

