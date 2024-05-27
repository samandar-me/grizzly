import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grizzly/constants.dart';
import 'package:grizzly/player.dart';
import 'package:lottie/lottie.dart';

import 'music.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  Duration maxDuration = const Duration(seconds: 0);

  getDuration() {
    Player.audioPlayer?.getDuration().then((value) {
      maxDuration = value ?? const Duration(seconds: 0);
      setState(() {});
    });
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // adjust duration as needed
    );
    Player.audioPlayer?.play(AssetSource(
        "music/music${Player.currentIndex}.mp3"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getDuration();
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
                          "assets/images/img_${musicList[Player.currentIndex].image}.png"))),
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
                                    animate: Player.audioPlayer?.state ==
                                        PlayerState.playing),
                              ),
                              _rotation(),
                            ],
                          ),
                          const Gap(20),
                          Text(
                            musicList[Player.currentIndex].title,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            musicList[Player.currentIndex].author,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 70),
                          StreamBuilder(
                              stream: Player.audioPlayer?.onPositionChanged,
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
                                    Player.audioPlayer?.seek(duration);
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
                                onPressed: () async {
                                  if (Player.currentIndex > 0) {
                                    setState(() {
                                      Player.currentIndex--;
                                    });
                                    await Player.audioPlayer?.play(AssetSource(
                                        "music/music$Player.currentIndex.mp3"));
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
                                      if (Player.audioPlayer?.state == PlayerState.playing) {
                                        await Player.audioPlayer?.pause();
                                        _controller.stop();
                                      } else {
                                        _controller.repeat();
                                        await Player.audioPlayer?.play(AssetSource("music/music${Player.currentIndex}.mp3"));
                                      }
                                      setState(() {});
                                    },
                                    icon: Icon(
                                        Player.audioPlayer?.state ==
                                            PlayerState.playing
                                            ? CupertinoIcons.pause
                                            : CupertinoIcons.play,
                                        color: Colors.white)),
                              ),
                              IconButton(
                                onPressed: () async {
                                  if (Player.currentIndex <
                                      musicList.length - 1) {
                                    setState(() {
                                      Player.currentIndex++;
                                    });
                                    //_audioPlayer.release();
                                    await Player.audioPlayer?.play(AssetSource(
                                        "music/music${Player.currentIndex}.mp3"));
                                  } else {
                                    setState(() {
                                      Player.currentIndex = 0;
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
