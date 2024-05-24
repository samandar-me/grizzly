import 'dart:io';
import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grizzly/music.dart';
import 'package:lottie/lottie.dart';

class MusicListPage extends StatefulWidget {
  const MusicListPage({super.key});

  @override
  State<MusicListPage> createState() => _MusicListPageState();
}

class _MusicListPageState extends State<MusicListPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;
  Duration maxDuration = const Duration(seconds: 0);

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // adjust duration as needed
    );
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  getDuration() {
    _audioPlayer.getDuration().then((value) {
      maxDuration = value ?? const Duration(seconds: 0);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    getDuration();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grizzly"),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: musicList.length,
        itemBuilder: (context, index) {
          return ListTile(            onTap: () {
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
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
                extendBodyBehindAppBar: true,
                backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(100),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      //     title: Text(musicList[_currentIndex].title),
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
                    Center(
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      ColorFiltered(
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          // Change this to your desired color
                                          BlendMode.srcATop,
                                        ),
                                        child: Lottie.asset(
                                            'assets/anim/anim_1.json',
                                            height: 250,
                                            width: 250,
                                            animate: _audioPlayer.state ==
                                                PlayerState.playing),
                                      ),
                                      _rotation(),
                                    ],
                                  ),
                                  const Gap(20),
                                  Text(
                                    musicList[_currentIndex].title,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  Text(
                                    musicList[_currentIndex].author,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 70),
                                  StreamBuilder(
                                      stream: _audioPlayer.onPositionChanged,
                                      builder: (context, snapshot) {
                                        return ProgressBar(
                                          thumbCanPaintOutsideBar: false,
                                          thumbRadius: 15,
                                          thumbGlowRadius: 2,
                                          progressBarColor: Colors.red,
                                          baseBarColor: Colors.white,
                                          bufferedBarColor: Colors.black,
                                          thumbColor: Colors.white,
                                          thumbGlowColor: Colors.white,
                                          timeLabelTextStyle:
                                              const TextStyle(color: Colors.white),
                                          progress: snapshot.data ??
                                              const Duration(seconds: 0),
                                          total: maxDuration,
                                          onSeek: (duration) {
                                            _audioPlayer.seek(duration);
                                            setState(() {});
                                          },
                                        );
                                      }),
                                  const SizedBox(height: 60),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (_currentIndex > 0) {
                                            setState(() {
                                              _currentIndex--;
                                            });
                                            _audioPlayer.play(AssetSource(
                                                "music/music$_currentIndex.mp3"));
                                          }
                                        },
                                        icon: const Icon(
                                            CupertinoIcons.backward_end_alt),
                                        color: Colors.white,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2)),
                                        child: IconButton(
                                            onPressed: () async {
                                              if (_audioPlayer.state == PlayerState.playing) {
                                                await _audioPlayer.pause();
                                                _controller.stop();
                                              } else {
                                                _controller.repeat();
                                                await _audioPlayer.play(AssetSource("music/music$_currentIndex.mp3"));
                                              }
                                              setState(() {});
                                            },
                                            icon: Icon(
                                                _audioPlayer.state ==
                                                        PlayerState.playing
                                                    ? CupertinoIcons.pause
                                                    : CupertinoIcons.play,
                                                color: Colors.white)),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (_currentIndex <
                                              musicList.length - 1) {
                                            setState(() {
                                              _currentIndex++;
                                            });
                                            //_audioPlayer.release();
                                            _audioPlayer.play(AssetSource(
                                                "music/music$_currentIndex.mp3"));
                                          } else {
                                            setState(() {
                                              _currentIndex = 0;
                                            });
                                          }
                                        },
                                        icon: const Icon(
                                            CupertinoIcons.forward_end_alt),
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                  const Gap(50),
                                ])))
                  ],
                ));
          }
        ));
  }

  _rotation() {
    return RotationTransition(
      turns: _controller,
      child: const Icon(
        CupertinoIcons.music_note_2,
        color: Colors.white,
        size: 50,
      ),
    );
  }
}
