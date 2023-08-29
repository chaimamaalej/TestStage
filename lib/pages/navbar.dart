import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class NavBar extends StatefulWidget {
  final bool isMusicOn;
  final Function(bool) setMusicState;
  final Function(Color) setBackgroundColor;

  const NavBar({
    Key? key,
    required this.isMusicOn,
    required this.setMusicState,
    required this.setBackgroundColor,
  }) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  Color _selectedColor = Colors.blue;
  List<Color> colorOptions = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
  ];

  void _changeBackgroundColor() {
    setState(() {
      int currentIndex = colorOptions.indexOf(_selectedColor);
      int nextIndex = (currentIndex + 1) % colorOptions.length;
      _selectedColor = colorOptions[nextIndex];
      widget.setBackgroundColor(
          _selectedColor); // Call the callback to update homepage color
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              '',
              style: TextStyle(fontSize: 26), // Set the desired font size
            ),
            accountEmail: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Chaima Maalej',
                style: TextStyle(fontSize: 20), // Set the desired font size
              ),
            ),
            decoration: BoxDecoration(
              color: _selectedColor,
              image: DecorationImage(
                image: NetworkImage(
                  'lib/images/ADHD.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text(
              'Background Color',
              style: TextStyle(fontSize: 20), // Set the font size correctly
            ),
            onTap:
                _changeBackgroundColor, // Call the function to change the background color
          ),
          ListTile(
            leading: Icon(Icons.music_note), // Add the icon here
            title: Row(
              children: [
                Text(
                  'Music',
                  style: TextStyle(fontSize: 20), // Adjust the font size here
                ),
                SizedBox(width: 8), // Add spacing between "Music" and status
                Text(
                  widget.isMusicOn ? 'On' : 'Off',
                  style: TextStyle(
                    color: widget.isMusicOn ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: Switch(
              value: widget.isMusicOn,
              onChanged: (newValue) {
                widget.setMusicState(
                    newValue); // Use the callback to update the state
              },
            ),
          ),
        ],
      ),
    );
  }
}
