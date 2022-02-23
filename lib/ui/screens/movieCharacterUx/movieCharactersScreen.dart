import 'package:flutter/material.dart';
import 'package:ui_ux/convertNumber.dart';
import 'package:ui_ux/ui/screens/movieCharacterUx/characterDetailsScreen.dart';
import 'package:ui_ux/ui/screens/movieCharacterUx/models/character.dart';

final List<Character> characters = [
  Character(
      backgroundColor: Colors.redAccent,
      description:
          "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available",
      name: "Spider-Man"),
  Character(
      backgroundColor: Colors.blueAccent,
      description:
          "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available",
      name: "Ant-Man"),
  Character(
      backgroundColor: Colors.pinkAccent,
      description:
          "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available",
      name: "Iron-Man"),
];

class MovieCharactersScreen extends StatefulWidget {
  MovieCharactersScreen({Key? key}) : super(key: key);

  @override
  State<MovieCharactersScreen> createState() => _MovieCharactersScreenState();
}

class _MovieCharactersScreenState extends State<MovieCharactersScreen>
    with TickerProviderStateMixin {
  late PageController _pageController =
      PageController(initialPage: 1, viewportFraction: 0.75)
        ..addListener(pageControllerListener);

  late int currentCharacterIndex = 1;
  double _currentCharacterPage = 1.0;

  void pageControllerListener() {
    setState(() {
      _currentCharacterPage = _pageController.page!;
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(pageControllerListener);
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildTopMenu() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * (0.025),
            right: MediaQuery.of(context).size.width * (0.025),
            top: MediaQuery.of(context).padding.top +
                MediaQuery.of(context).size.height * (0.0125)),
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
            Spacer(),
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          ],
        ),
      ),
    );
  }

  void navigateToDetailsScreen(int characterIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        reverseTransitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, firstAnimation, secondAnimation) {
          return CharacterDetailsScreen(
            character: characters[characterIndex],
            characterIndex: characterIndex,
          );
        },
      ),
    );
  }

  Widget _buildCharacterPageView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * (0.6),
        child: LayoutBuilder(builder: (context, boxConstraints) {
          return PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  currentCharacterIndex = index;
                });
              },
              controller: _pageController,
              itemCount: characters.length,
              itemBuilder: (context, index) {
                double pageOffset = 1.0 * (index) - _currentCharacterPage;
                //to measure the scale of container
                double scale = 1.0;

                if (pageOffset >= 0) {
                  //TODO: Add more explaintion

                  scale = ConvertNumber.inRange(
                      currentValue: pageOffset,
                      minValue: 0.0,
                      maxValue: 1.0,
                      newMaxValue: 0.9,
                      newMinValue: 1.0);
                } else {
                  scale = ConvertNumber.inRange(
                      currentValue: pageOffset,
                      minValue: -1.0,
                      maxValue: 0.0,
                      newMaxValue: 1.0,
                      newMinValue: 0.9);
                }

                return Transform.scale(
                  scale: scale,
                  child: GestureDetector(
                    onTap: () {
                      navigateToDetailsScreen(index);
                    },
                    child: Container(
                      child: Stack(
                        children: [
                          Hero(
                            tag: "${index}backgroundColor",
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: characters[index].backgroundColor,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: boxConstraints.maxWidth * (0.075),
                                top: boxConstraints.maxHeight * (0.35),
                              ),
                              child: Hero(
                                tag: "${index}name",
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    "${characters[index].name}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: boxConstraints.maxWidth * (0.075),
                                right: boxConstraints.maxWidth * (0.075),
                                top: boxConstraints.maxHeight * (0.45),
                              ),
                              child: Hero(
                                tag: "${index}description",
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    "${characters[index].description}",
                                    textAlign: TextAlign.start,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                );
              });
        }),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * (0.025),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //
          _buildCharacterPageView(),
          _buildTopMenu(),
        ],
      ),
    );
  }
}
