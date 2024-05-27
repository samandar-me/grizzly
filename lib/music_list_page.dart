import 'package:animations/animations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grizzly/constants.dart';
import 'package:grizzly/music.dart';
import 'package:grizzly/player.dart';
import 'package:grizzly/player_page.dart';

class MusicListPage extends StatefulWidget {
  const MusicListPage({super.key});

  @override
  State<MusicListPage> createState() => _MusicListPageState();
}

class _MusicListPageState extends State<MusicListPage> {

  @override
  void dispose() {
    Player.audioPlayer?.release();
    Player.audioPlayer = null;
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
          return OpenContainer(
              openColor: Colors.transparent,
              closedColor: Colors.transparent,
              closedElevation: 0,
              closedBuilder: (context, callback) {
                return ListTile(
                  onTap: () {
                    Player.currentIndex = index;
                    callback();
                    setState(() {

                    });
                  },
                  leading: CircleAvatar(
                    foregroundImage: AssetImage(
                        "assets/images/img_${musicList[index].image}.png"),
                    radius: 30,
                  ),
                  title: Text(musicList[Player.currentIndex].title),
                  subtitle: Text(musicList[Player.currentIndex].author),
                  trailing: Icon(Icons.stacked_bar_chart,
                      color: Player.currentIndex == index
                          ? Colors.white
                          : Colors.white30),
                );
              },
              openBuilder: (context, callback) => const PlayerPage());
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        padding: const EdgeInsets.only(bottom: 6),
        //elevation: 0,
        child: GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PlayerPage())),
          child: ListTile(
            leading: CircleAvatar(
              foregroundImage: AssetImage(
                  "assets/images/img_${musicList[Player.currentIndex].image}.png"),
              radius: 25,
            ),
            title: Text(musicList[Player.currentIndex].title),
            subtitle: Text(musicList[Player.currentIndex].author),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              //  spacing: 6,
              children: [
                IconButton(
                    onPressed: () async {
                      if (Player.audioPlayer?.state == PlayerState.playing) {
                        await Player.audioPlayer?.pause();
                      } else {
                        await Player.audioPlayer?.play(AssetSource("music/music${Player.currentIndex}.mp3"));
                      }
                      setState(() {});
                    },
                    icon: Icon(
                        Player.audioPlayer?.state == PlayerState.playing
                            ? CupertinoIcons.pause
                            : CupertinoIcons.play,
                        color: Colors.white)),
                IconButton(
                    onPressed: () async {
                      if (Player.currentIndex <
                          musicList.length - 1) {
                        Player.currentIndex++;
                        await Player.audioPlayer?.play(AssetSource(
                            "music/music${Player.currentIndex}.mp3"));
                      } else {
                        Player.currentIndex = 0;
                      }
                      setState(() {

                      });
                    },
                    icon: const Icon(CupertinoIcons.forward_end,
                        color: Colors.white))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
