import 'package:flutter/material.dart';
import 'package:ui_ux/ui/screens/shoppingApp/shoppingPlayGround.dart';

class ShoppingHomeScreen extends StatefulWidget {
  ShoppingHomeScreen({Key? key}) : super(key: key);

  @override
  _ShoppingHomeScreenState createState() => _ShoppingHomeScreenState();
}

class _ShoppingHomeScreenState extends State<ShoppingHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        //
        Navigator.of(context).push(FromMenuRoute(prevPage: widget, nextPage: ShoppingPlayGround(imageUrl: "assets/images/woman_a.jpg")));
      }),
      body: Stack(
        children: [
          //Align(alignment: Alignment.bottomCenter, child: FadeTransition(opacity: ModalRoute.of(context)!.animation!, child: CircleAvatar())),
          Center(
            child: Hero(
              tag: "assets/images/woman_a.jpg",
              child: Container(
                height: MediaQuery.of(context).size.height * (0.5),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage("assets/images/woman_a.jpg"))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
                          return Material(shadowColor: Colors.black, elevation: 30.0 * animation.value, child: nextPage);
                        },
                      ),
                    )
                  ],
                ),
              );
            });
}
