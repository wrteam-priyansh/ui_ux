import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_ux/ui/screens/gameChatMessageScreen.dart';
import 'package:ui_ux/ui/screens/homeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/images/map_finding.png"), context);

    precacheImage(AssetImage("assets/images/man_a.jpg"), context);

    precacheImage(AssetImage("assets/images/man_a2.jpg"), context);

    precacheImage(AssetImage("assets/images/man_a3.jpg"), context);

    precacheImage(AssetImage("assets/images/man_a4.jpg"), context);

    precacheImage(AssetImage("assets/images/man_a5.jpg"), context);

    precacheImage(AssetImage("assets/images/woman_a.jpg"), context);

    precacheImage(AssetImage("assets/images/woman_a2.jpg"), context);

    precacheImage(AssetImage("assets/images/woman_a3.jpg"), context);

    precacheImage(AssetImage("assets/images/woman_a4.jpg"), context);
    /*
    "assets/images/man_a.jpg",
  "assets/images/man_a2.jpg",
  "assets/images/man_a3.jpg",
  "assets/images/man_a4.jpg",
  "assets/images/man_a5.jpg",
  "assets/images/woman_a.jpg",
  "assets/images/woman_a2.jpg",
  "assets/images/woman_a3.jpg",
  "assets/images/woman_a4.jpg",
  */
    return BlocProvider<MessageCubit>(
      create: (context) => MessageCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
