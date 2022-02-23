import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_ux/ui/screens/angleVisualization.dart';
import 'package:ui_ux/ui/screens/arrowUx.dart';
import 'package:ui_ux/ui/screens/blurhHashImageScreen.dart';
import 'package:ui_ux/ui/screens/buttonAnimationScreen.dart';
import 'package:ui_ux/ui/screens/curveScreen.dart';
import 'package:ui_ux/ui/screens/fitnessUx/fitnessHomeScreen.dart';
import 'package:ui_ux/ui/screens/flappyBirdBackground.dart';
import 'package:ui_ux/ui/screens/flipCardAnimation.dart';
import 'package:ui_ux/ui/screens/foodMenuScrollingScreen.dart';
import 'package:ui_ux/ui/screens/gameChatMessageScreen.dart';
import 'package:ui_ux/ui/screens/heartAnimationScreen.dart';
import 'package:ui_ux/ui/screens/hexagonTabbarScreen.dart';
import 'package:ui_ux/ui/screens/hotelRoomAnimation.dart';
import 'package:ui_ux/ui/screens/imageBlurAnimation.dart';
import 'package:ui_ux/ui/screens/imageShadowScreen.dart';
import 'package:ui_ux/ui/screens/innerScrollingImageSlider.dart';
import 'package:ui_ux/ui/screens/inputChipUxScreen.dart';
import 'package:ui_ux/ui/screens/lottieScreen.dart';
import 'package:ui_ux/ui/screens/mapAnimationScreen.dart';
import 'package:ui_ux/ui/screens/mathsEquation.dart';
import 'package:ui_ux/ui/screens/meditationUx.dart';
import 'package:ui_ux/ui/screens/movieCharacterUx/movieCharactersScreen.dart';
import 'package:ui_ux/ui/screens/musicPlayerUx/musicPlayerUxScreen.dart';
import 'package:ui_ux/ui/screens/nikePlusScreen.dart';
import 'package:ui_ux/ui/screens/noiseScreen.dart';
import 'package:ui_ux/ui/screens/popularVideoUx.dart';
import 'package:ui_ux/ui/screens/quizMenu.dart';
import 'package:ui_ux/ui/screens/quizPlayAreaScreen.dart';
import 'package:ui_ux/ui/screens/randomWalker.dart';
import 'package:ui_ux/ui/screens/readAlongTextScreen.dart';
import 'package:ui_ux/ui/screens/refreshNestedScrollview.dart';
import 'package:ui_ux/ui/screens/scrollDragAnimationScreen.dart';
import 'package:ui_ux/ui/screens/selectWordAnimationScreen.dart';
import 'package:ui_ux/ui/screens/shapesScreen.dart';
import 'package:ui_ux/ui/screens/shoppingApp/shoppingHomeScreen.dart';
import 'package:ui_ux/ui/screens/spinWheelScreen.dart';
import 'package:ui_ux/ui/screens/tabBarAnimationScreen.dart';
import 'package:ui_ux/ui/screens/tapAnimationScreen.dart';
import 'package:ui_ux/ui/screens/telegramProfileAnimationScreen.dart';
import 'package:ui_ux/ui/screens/travelApp/travelHomeScreen.dart';
import 'package:ui_ux/ui/screens/waveScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> examples = [
    "Quiz Play Area",
    "Scroll Drag Animation",
    "Select Word Animation",
    "Tap Animation",
    "Map Animation",
    "Blur Hash Image",
    "Read Along Text",
    "Lottie Screen",
    "Inner Scrolling Image Slider(AJIO)",
    "Curve",
    "Arrow Ux",
    "Flip Card",
    "Heart Animation",
    "Flappy Bird Background",
    "Game Chat Message",
    "Nike Plus",
    "Tab Bar Animation",
    "Angle Visualization",
    "Refresh Nested Scrollview",
    "Maths Equation",
    "Scratch Card UI",
    "Quiz Menu",
    "Hotel Room Ux",
    "Noise",
    "Random Walker",
    "Wave",
    "Meditation Ux",
    "Button Animation",
    "Image Blur Animation",
    "Popular Video Ux",
    "Hexagon Tabbar",
    "Input Chip Ux",
    "Shapes",
    "Travel App Ux",
    "Spin Wheel",
    "Shopping Ux",
    "Food Menu Scrolling",
    "Music Player Ux",
    "Image Shadow",
    "Telegram Profile",
    "Fitness Ux",
    "Movie Character Ux"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              if (examples[index] == "Quiz Play Area") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuizPlayAreaScreen()));
              } else if (examples[index] == "Scroll Drag Animation") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScrollDragAnimationScreen()));
              } else if (examples[index] == "Select Word Animation") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectWordAnimationScreen()));
              } else if (examples[index] == "Tap Animation") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TapAnimationScreen()));
              } else if (examples[index] == "Map Animation") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapAnimationScreen()));
              } else if (examples[index] == "Blur Hash Image") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlurHashImageScreen()));
              } else if (examples[index] == "Read Along Text") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReadAlongTextScreen()));
              } else if (examples[index] == "Lottie Screen") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LottieScreen()));
              } else if (examples[index] ==
                  "Inner Scrolling Image Slider(AJIO)") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InnerScrollingImageSliderScreen(
                              screenSize: MediaQuery.of(context).size,
                            )));
              } else if (examples[index] == "Curve") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CurveScreen()));
              } else if (examples[index] == "Arrow Ux") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ArrowUxScreen()));
              } else if (examples[index] == "Flip Card") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FlipCardAnimation()));
              } else if (examples[index] == "Heart Animation") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HeartAnimationScreen()));
              } else if (examples[index] == "Flappy Bird Background") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FlappyBirdBackground()));
              } else if (examples[index] == "Game Chat Message") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GameChatMessageScreen()));
              } else if (examples[index] == "Nike Plus") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NikePlusScreen()));
              } else if (examples[index] == "Tab Bar Animation") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TabBarAnimationScreen()));
              } else if (examples[index] == "Angle Visualization") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AngleVisualization()));
              } else if (examples[index] == "Refresh Nested Scrollview") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RefreshNestedScrollview()));
              } else if (examples[index] == "Maths Equation") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MathsEquation()));
              } else if (examples[index] == "Quiz Menu") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QuizMenu()));
              } else if (examples[index] == "Hotel Room Ux") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HotelRoomAnimation()));
              } else if (examples[index] == "Noise") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NoiseScreen()));
              } else if (examples[index] == "Random Walker") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RandomWalker()));
              } else if (examples[index] == "Wave") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WaveScreen()));
              } else if (examples[index] == "Meditation Ux") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MeditationUx()));
              } else if (examples[index] == "Button Animation") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ButtonAnimationScreen()));
              } else if (examples[index] == "Image Blur Animation") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageBlurAnimation()));
              } else if (examples[index] == "Popular Video Ux") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PopularVideoUx(
                              screenSize: MediaQuery.of(context).size,
                            )));
              } else if (examples[index] == "Hexagon Tabbar") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HexagonTabbarScreen()));
              } else if (examples[index] == "Input Chip Ux") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InputChipUxScreen()));
              } else if (examples[index] == "Shapes") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ShapesScreen()));
              } else if (examples[index] == "Travel App Ux") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TravelHomeScreen()));
              } else if (examples[index] == "Spin Wheel") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SpinWheelScreen(
                              screenSize: MediaQuery.of(context).size,
                            )));
              } else if (examples[index] == "Shopping Ux") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShoppingHomeScreen()));
              } else if (examples[index] == "Food Menu Scrolling") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChangeNotifierProvider<FoodMenuTextSizeProvider>(
                                create: (_) => FoodMenuTextSizeProvider(),
                                child: FoodMenuScrollingScreen())));
              } else if (examples[index] == "Music Player Ux") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MusicPlayerUxScreen()));
              } else if (examples[index] == "Image Shadow") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageShadowScreen()));
              } else if (examples[index] == "Telegram Profile") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TelegramProfileAnimationScreen(
                              deviceSize: MediaQuery.of(context).size,
                            )));
              } else if (examples[index] == "Fitness Ux") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FitnessHomeScreen()));
              } else if (examples[index] == "Movie Character Ux") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MovieCharactersScreen()));
              }
            },
            title: Text("${examples[index]}"),
          );
        },
        itemCount: examples.length,
      ),
      appBar: AppBar(
        title: Text("UI - UX"),
      ),
    );
  }
}
