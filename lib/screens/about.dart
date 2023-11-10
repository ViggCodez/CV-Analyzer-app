import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'About Us',
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Our Journey',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          'CV Reimagined, is a tool which will be using AI and data analytics to enhance resumes for career success. It provides expert suggestions, market trends analysis, and personalized recommendations. The user-friendly interface caters to both recent graduates and seasoned professionals. The app is designed to stay ahead of the curve in the competitive job market, making CVs a powerful asset for unlocking career opportunities. The apps potential is significant in career development and CV optimization. Our journey with the creation of the CV Reimagined app is a testament to our dedication and vision in the field of software development. It all began as a college project, where we embarked on a mission to build a cutting-edge application that would not only cater to the academic requirements of our masters program but also leave a lasting impact on the world of career development.'),
                  TextSpan(text: "                                 "),
                  TextSpan(
                    text:
                        'Check more details or contact us on our website www.cvreimagined.com ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
