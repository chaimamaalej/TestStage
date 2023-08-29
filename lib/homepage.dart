import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geometry2/components/bottom_nav_bar.dart';
import 'package:geometry2/pages/cartPage.dart';
import 'package:geometry2/pages/informationPage.dart';
import 'package:geometry2/pages/navbar.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool isMusicOn = true; // Track the state of the music toggle
  late AudioPlayer audioPlayer;
  String audioFilePath = 'assets/mixkit-a-happy-child-532.mp3'; // Replace with the actual path
  Color _backgroundColor = Colors.blue; // Default background color


  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    if (isMusicOn) {
      playAudio(); // Start playing audio if music is on
    }
  }

  Future<void> playAudio() async {
    int result = await audioPlayer.play(audioFilePath, isLocal: true);

    if (result == 1) {
      print('Music playing');
    } else {
      print('Error playing music');
    }
  }

  Future<void> stopAudio() async {
    int result = await audioPlayer.stop();

    if (result == 1) {
      print('Music stopped');
    } else {
      print('Error stopping music');
    }
  }

  void toggleMusicState(bool newState) {
    setState(() {
      isMusicOn = newState;
      if (isMusicOn) {
        playAudio();
      } else {
        stopAudio();
      }
    });
  }

  void setBackgroundColor(Color color) {
    setState(() {
      _backgroundColor = color;
    });
  }

  void navigateBottomBar(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
    });
  }

  final List<Widget> _pages = [
    const InformationPage(),
    const CartPage(),
  ];

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(
        isMusicOn: isMusicOn,
        setMusicState: toggleMusicState,
        setBackgroundColor: setBackgroundColor, 
      ),
      appBar: AppBar(
        title: Text(''),
        backgroundColor: _backgroundColor, // Set the background color of the app bar
      ),
      backgroundColor: _backgroundColor,
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Let's play Name !",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'GloriaHallelujah',
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
