import 'dart:ui';
import 'package:chordefine/screens/base_screen.dart';
import 'package:chordefine/screens/lyricspage.dart';
import 'package:chordefine/screens/major.dart';
import 'package:chordefine/screens/minor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProgress extends StatelessWidget {
  const MyProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize both Major and Minor controllers
    Get.lazyPut(() => PracticeScreenMajorController());
    Get.lazyPut(() => PracticeScreenMinorController());
    final PracticeScreenMajorController majorController = Get.find();
    final PracticeScreenMinorController minorController = Get.find();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        flexibleSpace: Stack(
          children: [
            _buildGlassMorphicAppBar(),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Completed Chords",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.white),
                onPressed: () {
                  majorController.clearNotifications();
                  minorController.clearNotifications();
                },
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          _buildGlassMorphicBackground(),
          Column(
            children: [
              // Progress Bar
              SizedBox(height: 70),
              Obx(() {
                final majorChords = majorController.completedChords.toList();
                final minorChords = minorController.completedChords.toList();
                final totalCompleted = majorChords.length + minorChords.length;
                final progress = (totalCompleted / 14) * 100;
                final isCompleted = progress == 100;

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Icon based on completion status
                      Icon(
                        isCompleted ? Icons.check_circle : Icons.cancel,
                        color: isCompleted ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 10), // Spacing between icon and bar
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progress / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(245, 245, 110, 15)),
                          minHeight: 10,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              // Progress text
              Obx(() {
                final majorChords = majorController.completedChords.toList();
                final minorChords = minorController.completedChords.toList();
                final totalCompleted = majorChords.length + minorChords.length;
                final progress = (totalCompleted / 14) * 100;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Progress: ${progress.toInt()}%',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),

              Expanded(
                child: Obx(() {
                  // Get completed chords from both controllers
                  final majorChords = majorController.completedChords.toList();
                  final minorChords = minorController.completedChords.toList();

                  if (majorChords.isEmpty && minorChords.isEmpty) {
                    return const Center(
                        child: Text("No completed chords yet."));
                  }

                  return ListView(
                    children: [
                      if (majorChords.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Major Chords",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        for (var chord in majorChords)
                          ListTile(
                            leading: const Icon(Icons.check_circle,
                                color: Colors.green),
                            title: Text(
                              "Congratulations! You've completed $chord Major.",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                      if (minorChords.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Minor Chords",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        for (var chord in minorChords)
                          ListTile(
                            leading: const Icon(Icons.check_circle,
                                color: Colors.green),
                            title: Text(
                              "Congratulations! You've completed $chord.",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ],
                  );
                }),
              ),
            ],
          ),
          Positioned(
            bottom: 80, // Adjust to control vertical position
            right: 10, // Adjust to control horizontal position
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BaseScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(245, 245, 110, 15),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
              ),
              child: const Icon(Icons.arrow_back,
                  color: Color.fromARGB(245, 255, 255, 255)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassMorphicAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(20), right: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: const Color.fromARGB(245, 245, 110, 15),
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(20), right: Radius.circular(20)),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassMorphicBackground() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(245, 255, 255, 255),
          ),
        ),
      ),
    );
  }
}
