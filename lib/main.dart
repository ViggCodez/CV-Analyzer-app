// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/settings.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV Reimagined',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isViewed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      function: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('onBoard')) {
          isViewed = prefs.getBool('onBoard') ?? false;
        } else {
          await prefs.setBool("onBoard", false);
        }
      },
      splash: Column(
        children: [
          Expanded(
              child: Image.asset(
            'assets/images/icon.png',
            height: 250,
            width: 250,
          )),
          const SizedBox(
            height: 20,
          ),
          const Expanded(
            child: Text(
              'CV Reimagined',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green,
      nextScreen: const MyHomePage(title: 'CV Reimagined'),
      splashIconSize: 350,
      duration: 100,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(seconds: 1),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/cvrlogo.jpg',
              width: 250,
              height: 250,
            ),
            const SizedBox(height: 30),
            const Text(
              'Welcome to CV Analyzer',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Upload your CV to get a comprehensive analysis of your skills and qualifications. '
                'We will provide feedback and suggestions for improvement.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: () async {
                  final ApiService apiService = ApiService();
                  apiService.uploadCV().then((cvFile) {
                    if (cvFile != null) {
                      apiService.analyzeCV(cvFile).then((data) {
                        print(data.score);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                                analyzedData:
                                    data), // passing the data to the result screen
                          ),
                        );
                      }).catchError((error) {
                        print(error);
                      });
                    } else {
                      print('No file selected');
                    }
                  });
                },
                child: const Text('Upload CV')),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final CVAnalyzedData analyzedData;

  const ResultScreen({Key? key, required this.analyzedData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('CV Analysis Result'),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Score: ${analyzedData.score}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildFeedbackItem('Impact', analyzedData.feedback.impact),
                  _buildFeedbackItem('Brevity', analyzedData.feedback.brevity),
                  _buildFeedbackItem('Style', analyzedData.feedback.style),
                  _buildFeedbackItem(
                      'Sections', analyzedData.feedback.sections),
                  _buildFeedbackItem(
                      'Soft Skills', analyzedData.feedback.softSkill),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                _launchYouTubeVideo();
              },
              child: const Center(
                  child: Text('Click here to improve your Resume')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackItem(String title, String feedback) {
    return ListTile(
      title: Text(title),
      subtitle: Text(feedback.isNotEmpty ? feedback : 'Not available'),
    );
  }
}

class ApiService {
  final String serverUrl =
      "http://10.125.21.101:8000/cv/analyze"; //change to device ip

  Future<FilePickerResult?> uploadCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx'
      ], // Allow only PDF and Word files
    );

    return result;
  }

  Future<CVAnalyzedData> analyzeCV(FilePickerResult result) async {
    File file = File(result.files.single.path!);

    try {
      // Step 2: Create a multipart request for the file
      var request = http.MultipartRequest('POST', Uri.parse(serverUrl));
      request.files.add(
        http.MultipartFile(
          'file', // This field name 'file' should match the parameter expected by FastAPI
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path.split("/").last, // Include the filename
        ),
      );

      // Step 3: Send the request to the server
      var response = await request.send();

      // Step 4: Handle the response from the server
      if (response.statusCode == 200) {
        // On success, retrieve the response body
        final respStr = await response.stream.bytesToString();

        return CVAnalyzedData.fromJson(jsonDecode(respStr));
      } else {
        throw ('Failed to analyze CV. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}

class CVAnalyzedData {
  int score;
  Feedback feedback;

  CVAnalyzedData({
    required this.score,
    required this.feedback,
  });

  Map<String, dynamic> toJson() => {
        'score': score,
        'feedback': feedback.toJson(), // calling toJson on Feedback object
      };

  // Creating a new CVAnalyzedData object from a map structure
  factory CVAnalyzedData.fromJson(Map<String, dynamic> json) => CVAnalyzedData(
        score: json['score'],
        feedback: Feedback.fromJson(
            json['feedback']), // calling fromJson on Feedback map
      );
}

class Feedback {
  String impact;
  String brevity;
  String style;
  String sections;
  String softSkill;

  Feedback({
    this.impact = '',
    this.brevity = '',
    this.style = '',
    this.sections = '',
    this.softSkill = '',
  });

  Map<String, dynamic> toJson() => {
        'Impact': impact,
        'Brevity': brevity,
        'Style': style,
        'Sections': sections,
        'Soft Skills': softSkill,
      };

  // Creating a new Feedback object from a map
  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
        impact: json['Impact'],
        brevity: json['Brevity'],
        style: json['Style'],
        sections: json['Sections'],
        softSkill: json['Soft Skills'],
      );
}

final Uri _url = Uri.parse('https://youtu.be/Tt08KmFfIYQ');
Future<void> _launchYouTubeVideo() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
