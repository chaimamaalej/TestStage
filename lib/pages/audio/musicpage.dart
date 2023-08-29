import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MyMusicPage extends StatefulWidget {
  @override
  _MyMusicPageState createState() => _MyMusicPageState();
}

class _MyMusicPageState extends State<MyMusicPage> {
  late AudioPlayer audioPlayer;
  String audioFilePath = 'assets/mixkit-a-happy-child-532.mp3'; // Replace with the actual path

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  void playAudio() async {
    int result = await audioPlayer.play(audioFilePath, isLocal: true);

    if (result == 1) {
      // Success
      print('Music playing');
    } else {
      // Error
      print('Error playing music');
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose(); // Dispose of the audio player when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Play Music',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => playAudio(),
              child: Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}
