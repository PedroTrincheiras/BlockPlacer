import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blockplacer/Management/colorscheme.dart';
import 'package:blockplacer/Management/gamegestor.dart';
import 'package:blockplacer/Pages/game_page.dart';
import 'package:blockplacer/Transitions/bouncypagetransition.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  Future<int> hightScore;
  Future<bool> dark;

  MyColorScheme mcs;

  @override
  Widget build(BuildContext context) {
    hightScore = _pref.then((SharedPreferences prefs) {
      return (prefs.getInt('hightScore') ?? 0);
    });

    dark = _pref.then((SharedPreferences prefs) {
      return (prefs.getBool('dark') ?? false);
    });

    return MaterialApp(
      home: FutureBuilder(
          future: dark,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            mcs = MyColorScheme(snapshot.data);
            mcs.addListener(() {
              setState(() {});
            });
            return Container(
              color: mcs.pageBG(),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TypewriterAnimatedTextKit(
                      text: ["BlockPlacer"],
                      speed: Duration(milliseconds: 200),
                      isRepeatingAnimation: false,
                      textStyle: TextStyle(
                          color: mcs.bg(),
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.none,
                          fontSize: 40),
                    ),
                    FutureBuilder(
                        future: hightScore,
                        builder: (BuildContext context,
                            AsyncSnapshot<int> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const CircularProgressIndicator();
                            default:
                              if (snapshot.hasError) {
                                return Text('Error');
                              } else {
                                return Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          color: mcs.starColor(),
                                          size: 40,
                                        ),
                                        Text(
                                          snapshot.data.toString(),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: mcs.bg(),
                                              fontWeight: FontWeight.w100,
                                              decoration: TextDecoration.none,
                                              fontSize: 40),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    RaisedButton(
                                      color: mcs.bg(),
                                      splashColor: mcs.gameBg2(),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(20.0),
                                      ),
                                      elevation: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            right: 30,
                                            left: 30),
                                        child: Text(
                                          "New Game",
                                          style: TextStyle(
                                              color: mcs.grid(),
                                              fontWeight: FontWeight.w500,
                                              decoration: TextDecoration.none,
                                              fontSize: 25),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            BouncyPageRoute(
                                                widget: GamePage(
                                              mcs: mcs,
                                              gestor: Gestor(snapshot.data),
                                            )));
                                      },
                                    )
                                  ],
                                );
                              }
                          }
                        }),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
