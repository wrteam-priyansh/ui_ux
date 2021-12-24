import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ui_ux/ui/screens/shoppingApp/productDetailsScreen.dart';

const List<String> youMayLikeWomenImages = [
  "assets/images/woman_a2.jpg",
  "assets/images/woman_a3.jpg",
  "assets/images/woman_a4.jpg",
  "assets/images/woman_g.jpg",
  "assets/images/woman_h.jpg",
  "assets/images/woman_i.jpg",
];

const List<String> youMayLikeMenImages = [
  "assets/images/man_a.jpg",
  "assets/images/man_a2.jpg",
  "assets/images/man_a3.jpg",
  "assets/images/man_a4.jpg",
  "assets/images/man_a5.jpg",
];

const List<String> youMayLikeKidsImages = [
  "assets/images/woman_a2.jpg",
  "assets/images/woman_a3.jpg",
  "assets/images/woman_a4.jpg",
  "assets/images/woman_g.jpg",
  "assets/images/woman_h.jpg",
  "assets/images/woman_i.jpg",
];

class Ad {
  final String image;
  final String title;
  final String subTitle;

  Ad({required this.image, required this.subTitle, required this.title});
}

final List<Ad> homeAds = [
  Ad(
      image: "assets/images/woman_a.jpg",
      subTitle: "Winter",
      title: "Top trending"),
  Ad(
      image: "assets/images/man_a.jpg",
      subTitle: "Summer",
      title: "For classy men"),
  Ad(image: "assets/images/image-1.png", subTitle: "Spring", title: "New born"),
];

const int heroDurationInMilliSeconds = 400;

class ShoppingHomeScreen extends StatefulWidget {
  ShoppingHomeScreen({Key? key}) : super(key: key);

  @override
  _ShoppingHomeScreenState createState() => _ShoppingHomeScreenState();
}

class _ShoppingHomeScreenState extends State<ShoppingHomeScreen>
    with TickerProviderStateMixin {
  Alignment _bottomNavigationContainerAlignment = Alignment.centerLeft;
  final Duration _bottomNavigationAnimationDuration =
      Duration(milliseconds: 300);
  int _currentSelectedBottomMenu = 0;

  //

  late PageController _adsPageController = PageController();

  late List<AnimationController> _adsTextAnimationControllers = [];

  @override
  void initState() {
    super.initState();
    homeAds.forEach((element) {
      _adsTextAnimationControllers.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: 800)));
    });
    _adsTextAnimationControllers.first.forward();
  }

  @override
  void dispose() {
    _adsPageController.dispose();
    _adsTextAnimationControllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  Widget _buildBottomNavContainer(int index, String title, double width) {
    return GestureDetector(
      onTap: () {
        _adsPageController
            .animateToPage(index,
                curve: Curves.easeInOut,
                duration: _bottomNavigationAnimationDuration)
            .then((value) {
          for (var i = 0; i < _adsTextAnimationControllers.length; i++) {
            if (i == _currentSelectedBottomMenu) {
              _adsTextAnimationControllers[i].forward();
            } else {
              _adsTextAnimationControllers[i].reverse();
            }
          }
        });
        setState(() {
          if (index != _currentSelectedBottomMenu) {
            //change bottom container alignment
            if (index == 0) {
              _bottomNavigationContainerAlignment = Alignment.centerLeft;
            } else if (index == 1) {
              _bottomNavigationContainerAlignment = Alignment.center;
            } else {
              _bottomNavigationContainerAlignment = Alignment.centerRight;
            }
            //update index of bottm menu
            _currentSelectedBottomMenu = index;
          }
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: width,
        child: AnimatedDefaultTextStyle(
            child: Text(title),
            style: _currentSelectedBottomMenu == index
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Colors.black),
            duration: _bottomNavigationAnimationDuration),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedAlign(
                curve: Curves.easeInOut,
                duration: _bottomNavigationAnimationDuration,
                alignment: _bottomNavigationContainerAlignment,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.orange),
                  width: constraints.maxWidth * (0.28),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBottomNavContainer(
                      0, "Women", constraints.maxWidth * 0.28),
                  _buildBottomNavContainer(
                      1, "Men", constraints.maxWidth * 0.28),
                  _buildBottomNavContainer(
                      2, "Kids", constraints.maxWidth * 0.28),
                ],
              )
            ],
          );
        }),
        margin: EdgeInsets.only(
            bottom: 25.0,
            right: MediaQuery.of(context).size.width * (0.1),
            left: MediaQuery.of(context).size.width * (0.1)),
        width: MediaQuery.of(context).size.width * (0.8),
        height: MediaQuery.of(context).size.height * (0.06),
      ),
    );
  }

  Widget _buildYouMayLikeItemContainer(
      String imagePath, BoxConstraints boxConstraints) {
    double itemContainerHeight = boxConstraints.maxHeight * (0.6);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            reverseTransitionDuration:
                Duration(milliseconds: heroDurationInMilliSeconds),
            transitionDuration:
                Duration(milliseconds: heroDurationInMilliSeconds),
            pageBuilder: (context, animation, _) {
              return ProductDetailsScreen(productImage: imagePath);
            }));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        margin: EdgeInsets.only(right: 20.0),
        width: boxConstraints.maxWidth * (0.4),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: boxConstraints.maxWidth * (0.025),
              bottom: boxConstraints.maxWidth * (0.35) * (0.115),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20.0,
                      )
                    ]),
                width: boxConstraints.maxWidth * (0.35),
                height: boxConstraints.maxWidth * (0.35),
              ),
            ),
            Container(
              height: itemContainerHeight * 0.9,
              color: Colors.white,
              child: Column(
                children: [
                  Hero(
                    tag: imagePath,
                    child: Container(
                      height: itemContainerHeight * (0.725) * (0.9),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover, image: AssetImage(imagePath)),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: itemContainerHeight * (0.045),
                  ),
                  Text(
                    "Lovely Jeans",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: itemContainerHeight * (0.02),
                  ),
                  Text(
                    "\$ 50",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildYouMayLikeItemList(
      List<String> items, BoxConstraints constraints) {
    return ListView.builder(
        padding:
            EdgeInsets.only(left: MediaQuery.of(context).size.width * (0.1)),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildYouMayLikeItemContainer(items[index], constraints);
        });
  }

  Widget _buildYouMayLikeContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: constraints.maxHeight * (0.1),
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * (0.1),
                  ),
                  Text(
                    "You may like",
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  //Icon(Icons.arrow_forward_ios_rounded),
                  SizedBox(
                    width: constraints.maxWidth * (0.1),
                  ),
                ],
              ),
              SizedBox(
                height: constraints.maxHeight * (0.075),
              ),
              SizedBox(
                height: constraints.maxHeight * (0.6),
                child: AnimatedSwitcher(
                  duration: _bottomNavigationAnimationDuration,
                  switchInCurve: Curves.easeInOut,
                  child: _currentSelectedBottomMenu == 0
                      ? _buildYouMayLikeItemList(
                          youMayLikeWomenImages, constraints)
                      : _currentSelectedBottomMenu == 1
                          ? _buildYouMayLikeItemList(
                              youMayLikeMenImages, constraints)
                          : _buildYouMayLikeItemList(
                              youMayLikeKidsImages, constraints),
                ),
              )
            ],
          );
        }),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * (0.45),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
            )),
      ),
    );
  }

  Widget _buildAdContainer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * (0.6),
      width: MediaQuery.of(context).size.width,
      child: PageView.builder(
          controller: _adsPageController,
          itemCount: homeAds.length,
          itemBuilder: (context, index) {
            return Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * (0.1),
                    left: MediaQuery.of(context).size.width * (0.125)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SlideTransition(
                      position: Tween<Offset>(
                              begin: Offset(-2.0, 0.0), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: _adsTextAnimationControllers[index],
                              curve: Curves.easeInOut)),
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: _adsTextAnimationControllers[index],
                                curve: Interval(0.0, 0.8,
                                    curve: Curves.easeInOut))),
                        child: Text(
                          homeAds[index].title,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SlideTransition(
                      position: Tween<Offset>(
                              begin: Offset(-2.0, 0.0), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: _adsTextAnimationControllers[index],
                              curve:
                                  Interval(0.3, 1.0, curve: Curves.easeInOut))),
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: _adsTextAnimationControllers[index],
                                curve: Interval(0.3, 1.0,
                                    curve: Curves.easeInOut))),
                        child: Text(
                          homeAds[index].subTitle,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    SlideTransition(
                      position: Tween<Offset>(
                              begin: Offset(-2.0, 0.0), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: _adsTextAnimationControllers[index],
                              curve: Interval(0.45, 1.0,
                                  curve: Curves.easeInOut))),
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: _adsTextAnimationControllers[index],
                                curve: Interval(0.45, 1.0,
                                    curve: Curves.easeInOut))),
                        child: Text(
                          "Collection",
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(homeAds[index].image)),
                ));
          }),
    );
  }

  Widget _buildExploreButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * (0.51),
        ),
        child: GestureDetector(
          onTap: () {
            //open bottom sheet
            showModalBottomSheet(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )),
                context: context,
                builder: (context) {
                  return BottomSheetContainer();
                });
          },
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "Explore",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                )),
            height: MediaQuery.of(context).size.height * 0.075,
            width: MediaQuery.of(context).size.width * (0.3),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildAdContainer(),
          //to remove gesture from pageview bulder
          Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height * (0.6),
            width: MediaQuery.of(context).size.width,
          ),

          _buildYouMayLikeContainer(),
          _buildExploreButton(),
          _buildBottomNavigation(),
        ],
      ),
    );
  }
}

//It is custom menu route
class FromMenuRoute extends PageRouteBuilder {
  final Widget nextPage;
  final Widget prevPage;

  FromMenuRoute({required this.prevPage, required this.nextPage})
      : super(
            transitionDuration: Duration(milliseconds: 3000),
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return nextPage;
            },
            maintainState: true,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return Material(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.0),
                        end: const Offset(-0.3, 0.0),
                      ).animate(animation),
                      child: prevPage,
                    ),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: AnimatedBuilder(
                        animation: animation,
                        builder: (c, w) {
                          return Material(
                              shadowColor: Colors.black,
                              elevation: 30.0 * animation.value,
                              child: nextPage);
                        },
                      ),
                    )
                  ],
                ),
              );
            });
}

class BottomSheetContainer extends StatefulWidget {
  BottomSheetContainer({Key? key}) : super(key: key);

  @override
  _BottomSheetContainerState createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer>
    with TickerProviderStateMixin {
  late AnimationController _bottomSheetHeightAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
        ..forward();

  late Animation<double> _bottomSheetHeightDownAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _bottomSheetHeightAnimationController,
          curve: Interval(0.6, 1.0, curve: Curves.easeInOut)));

  late Animation<double> _bottomSheetHeightUpAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _bottomSheetHeightAnimationController,
          curve: Interval(0.0, 0.6, curve: Curves.easeInOut)));

  @override
  void dispose() {
    _bottomSheetHeightAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bottomSheetHeightAnimationController,
      builder: (context, child) {
        final height = _bottomSheetHeightUpAnimation.value *
                MediaQuery.of(context).size.height *
                (0.65) -
            MediaQuery.of(context).size.height *
                (0.1) *
                _bottomSheetHeightDownAnimation.value;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight * (0.125),
                ),
                SlideTransition(
                  position: Tween<Offset>(
                          begin: Offset(0.0, 0.5), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _bottomSheetHeightAnimationController,
                          curve: Interval(0.3, 0.7, curve: Curves.easeInOut))),
                  child: ScaleTransition(
                    alignment: Alignment.bottomCenter,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: _bottomSheetHeightAnimationController,
                            curve:
                                Interval(0.3, 0.7, curve: Curves.easeInOut))),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white),
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * (0.25),
                    ),
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * (0.075),
                ),
                /*
                SlideTransition(
                  position: Tween<Offset>(
                          begin: Offset(0.0, -0.25), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _bottomSheetHeightAnimationController,
                          curve: Interval(0.5, 1.0, curve: Curves.easeInOut))),
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: Offset(0.0, 3.0), end: Offset(0.0, -0.25))
                        .animate(CurvedAnimation(
                            parent: _bottomSheetHeightAnimationController,
                            curve:
                                Interval(0.0, 0.5, curve: Curves.easeInOut))),
                    child: ScaleTransition(
                      alignment: Alignment.center,
                      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: _bottomSheetHeightAnimationController,
                              curve: Curves.easeInOut)),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white),
                        width: constraints.maxWidth,
                        height: constraints.maxHeight * (0.25),
                      ),
                    ),
                  ),
                ),
                */
                Flexible(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return CategoryContainer(
                          index: index,
                        );
                      }),
                )
              ],
            );
          }),
          width: MediaQuery.of(context).size.width,
          height: height,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              )),
        );
      },
    );
  }
}

class CategoryContainer extends StatefulWidget {
  final int index;
  CategoryContainer({Key? key, required this.index}) : super(key: key);

  @override
  _CategoryContainerState createState() => _CategoryContainerState();
}

class _CategoryContainerState extends State<CategoryContainer>
    with TickerProviderStateMixin {
  late AnimationController animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 600));

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  void startAnimation() async {
    await Future.delayed(Duration(milliseconds: 150));
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 2.5), end: Offset.zero).animate(
          CurvedAnimation(
              parent: animationController, curve: Curves.easeInOut)),
      child: ScaleTransition(
        alignment: Alignment.center,
        scale: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeInOut)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0), color: Colors.white),
        ),
      ),
    );
  }
}
