import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grizzly/constants.dart';
import 'package:grizzly/music.dart';
import 'package:lottie/lottie.dart';

class MusicListPage extends StatefulWidget {
  const MusicListPage({super.key});

  @override
  State<MusicListPage> createState() => _MusicListPageState();
}

class _MusicListPageState extends State<MusicListPage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // adjust duration as needed
    );
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grizzly"),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: musicList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              _onTap();
              setState(() {
                _currentIndex = index;
              });
            },
            leading: CircleAvatar(
              foregroundImage:
                  AssetImage("assets/images/img_${musicList[index].image}.png"),
              radius: 30,
            ),
            title: Text(musicList[index].title),
            subtitle: Text(musicList[index].author),
            trailing: Icon(Icons.stacked_bar_chart,
                color: _currentIndex == index ? Colors.white : Colors.white30),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Center(
          child: GestureDetector(
            onTap: _onTap,
            child: ListTile(
              leading: CircleAvatar(
                foregroundImage: AssetImage(
                    "assets/images/img_${musicList[_currentIndex].image}.png"),
                radius: 25,
              ),
              title: Text(musicList[_currentIndex].title),
              subtitle: Text(musicList[_currentIndex].author),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                //  spacing: 6,
                children: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(CupertinoIcons.play)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.forward_end))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onTap() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  title: Text(musicList[_currentIndex].title),
                ),
              ),
            ),
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              "assets/images/img_${musicList[_currentIndex].image}.png"))),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
                    child: Container(),
                  ),
                ),
                _musicContainer()
              ],
            )));
  }

  _musicContainer() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.white, // Change this to your desired color
                    BlendMode.srcATop,
                  ),
                  child: Lottie.asset('assets/anim/anim_1.json',
                      height: 250, width: 250, animate: true),
                ),
                RotationTransition(
                  turns: _controller,
                  child: const Icon(
                    CupertinoIcons.music_note_2,
                    color: Colors.white,
                    size: 50,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
