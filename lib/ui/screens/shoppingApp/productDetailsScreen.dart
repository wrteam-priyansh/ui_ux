import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:ui_ux/ui/screens/shoppingApp/shoppingHomeScreen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productImage;
  ProductDetailsScreen({Key? key, required this.productImage})
      : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with TickerProviderStateMixin {
  //To animate the back and searh button
  late AnimationController _backAndSearchButtonFadeAnimationController =
      AnimationController(
          reverseDuration: Duration(milliseconds: 225),
          vsync: this,
          duration: Duration(milliseconds: 450));

  late Animation<double> _backAndSearchButtonFadeAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _backAndSearchButtonFadeAnimationController,
          curve: Curves.easeInOut));

  //
  late AnimationController _addToBagAndFavoriteButtonAnimaitonController =
      AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 400),
          reverseDuration: Duration(milliseconds: 200));

  late Animation<Offset> _addToBagButtonAnimation =
      Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _addToBagAndFavoriteButtonAnimaitonController,
              curve: Curves.easeInOut));

  late Animation<Offset> _favoriteButtonAnimation =
      Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _addToBagAndFavoriteButtonAnimaitonController,
              curve: Interval(0.4, 1.0, curve: Curves.easeInOut)));

  //Can be converted into staggered animaiton all color,size and price
  late AnimationController _colorContainerAnimationController =
      AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 1000),
          reverseDuration: Duration(milliseconds: 0));

  late Animation<double> _colorContainerScaleAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _colorContainerAnimationController,
          curve: Interval(0.0, 0.5, curve: Curves.easeInOut)));

  late Animation<Offset> _colorContainerSlideUpAnimation =
      Tween<Offset>(begin: Offset.zero, end: Offset(0, -0.5)).animate(
          CurvedAnimation(
              parent: _colorContainerAnimationController,
              curve: Interval(0.4, 0.7, curve: Curves.easeInOut)));

  late Animation<Offset> _colorContainerSlideDownAnimation =
      Tween<Offset>(begin: Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _colorContainerAnimationController,
              curve: Interval(0.7, 1.0, curve: Curves.easeInOut)));

  late AnimationController _priceContainerAnimationController =
      AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 1000),
          reverseDuration: Duration(milliseconds: 0));

  late Animation<double> _priceContainerScaleAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _priceContainerAnimationController,
          curve: Interval(0.0, 0.5, curve: Curves.easeInOut)));

  late Animation<Offset> _priceContainerSlideUpAnimation =
      Tween<Offset>(begin: Offset(0.0, 0.1), end: Offset(0, -0.5)).animate(
          CurvedAnimation(
              parent: _priceContainerAnimationController,
              curve: Interval(0.4, 0.7, curve: Curves.easeInOut)));

  late Animation<Offset> _priceContainerSlideDownAnimation =
      Tween<Offset>(begin: Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _priceContainerAnimationController,
              curve: Interval(0.7, 1.0, curve: Curves.easeInOut)));

  late AnimationController _sizeContainerAnimationController =
      AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 1000),
          reverseDuration: Duration(milliseconds: 0));

  late Animation<double> _sizeContainerScaleAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _sizeContainerAnimationController,
          curve: Interval(0.0, 0.5, curve: Curves.easeInOut)));

  late Animation<Offset> _sizeContainerSlideUpAnimation =
      Tween<Offset>(begin: Offset(0.0, 0.2), end: Offset(0, -0.5)).animate(
          CurvedAnimation(
              parent: _sizeContainerAnimationController,
              curve: Interval(0.4, 0.7, curve: Curves.easeInOut)));

  late Animation<Offset> _sizeContainerSlideDownAnimation =
      Tween<Offset>(begin: Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _sizeContainerAnimationController,
              curve: Interval(0.7, 1.0, curve: Curves.easeInOut)));

  //Product details animations

  late AnimationController _productDetailsAnimationController =
      AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 1000),
          reverseDuration: Duration(milliseconds: 0));

  @override
  void initState() {
    super.initState();
    startAnimations();
  }

  void startAnimations() async {
    await Future.delayed(Duration(milliseconds: heroDurationInMilliSeconds));
    _backAndSearchButtonFadeAnimationController.forward();
    _addToBagAndFavoriteButtonAnimaitonController.forward();
    _productDetailsAnimationController.forward();
    _colorContainerAnimationController.forward();
    await Future.delayed(Duration(milliseconds: 100));
    _priceContainerAnimationController.forward();
    await Future.delayed(Duration(milliseconds: 100));
    _sizeContainerAnimationController.forward();
  }

  @override
  void dispose() {
    _backAndSearchButtonFadeAnimationController.dispose();
    _addToBagAndFavoriteButtonAnimaitonController.dispose();
    _colorContainerAnimationController.dispose();
    _priceContainerAnimationController.dispose();
    _sizeContainerAnimationController.dispose();
    _productDetailsAnimationController.dispose();

    super.dispose();
  }

  Widget _buildBackAndSearchButtonContainer() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * (0.06),
          left: MediaQuery.of(context).size.width * (0.075),
          right: MediaQuery.of(context).size.width * (0.075),
        ),
        child: FadeTransition(
          opacity: _backAndSearchButtonFadeAnimation,
          child: Row(
            children: [
              IconButton(
                  color: Colors.white,
                  onPressed: () {
                    _backAndSearchButtonFadeAnimationController.reverse();
                    _addToBagAndFavoriteButtonAnimaitonController.reverse();
                    _colorContainerAnimationController.reverse();
                    _priceContainerAnimationController.reverse();
                    _sizeContainerAnimationController.reverse();
                    _productDetailsAnimationController.reverse();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              Spacer(),
              IconButton(
                  color: Colors.white,
                  onPressed: () {
                    //Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.search)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddToBagAndFavoriteButtonContainer() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        height: MediaQuery.of(context).size.height * (0.075),
        width: MediaQuery.of(context).size.width * (0.35),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0))),
        child: LayoutBuilder(builder: (context, constraints) {
          return Row(
            children: [
              SlideTransition(
                position: _favoriteButtonAnimation,
                child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                      )),
                  width: constraints.maxWidth * (0.5),
                  height: constraints.maxHeight,
                ),
              ),
              SlideTransition(
                position: _addToBagButtonAnimation,
                child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.badge,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20.0),
                      )),
                  width: constraints.maxWidth * (0.5),
                  height: constraints.maxHeight,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildColorContainer() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * (0.55),
            left: MediaQuery.of(context).size.width * (0.075)),
        child: SlideTransition(
          position: _colorContainerSlideDownAnimation,
          child: SlideTransition(
            position: _colorContainerSlideUpAnimation,
            child: ScaleTransition(
                scale: _colorContainerScaleAnimation,
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(25.0)),
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Color",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceContainer() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * (0.55),
          //left: MediaQuery.of(context).size.width * (0.075)
        ),
        child: SlideTransition(
          position: _priceContainerSlideDownAnimation,
          child: SlideTransition(
            position: _priceContainerSlideUpAnimation,
            child: ScaleTransition(
                scale: _priceContainerScaleAnimation,
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(25.0)),
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Price",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildSizeContainer() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * (0.55),
            right: MediaQuery.of(context).size.width * (0.075)),
        child: SlideTransition(
          position: _sizeContainerSlideDownAnimation,
          child: SlideTransition(
            position: _sizeContainerSlideUpAnimation,
            child: ScaleTransition(
                scale: _sizeContainerScaleAnimation,
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(25.0)),
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Size",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetailsContainer() {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * (0.075),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          Container(
            alignment: Alignment.centerLeft,
            child: SlideTransition(
              child: Text(
                "Lovely Jeans",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              position: Tween<Offset>(begin: Offset(-1.5, 0), end: Offset.zero)
                  .animate(
                CurvedAnimation(
                  parent: _productDetailsAnimationController,
                  curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 10.0,
          ),

          Container(
            alignment: Alignment.centerLeft,
            child: SlideTransition(
              child: Text(
                "Grand Jeans",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              position: Tween<Offset>(begin: Offset(-1.5, 0), end: Offset.zero)
                  .animate(
                CurvedAnimation(
                  parent: _productDetailsAnimationController,
                  curve: Interval(0.2, 1.0, curve: Curves.easeInOut),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 25.0,
          ),
          SlideTransition(
            position:
                Tween<Offset>(begin: Offset(0.0, -0.25), end: Offset(0, 0.25))
                    .animate(CurvedAnimation(
                        parent: _productDetailsAnimationController,
                        curve: Interval(0.8, 1.0, curve: Curves.easeInOut))),
            child: SlideTransition(
              position:
                  Tween<Offset>(begin: Offset(0, 0.25), end: Offset(0.0, -0.25))
                      .animate(CurvedAnimation(
                          parent: _productDetailsAnimationController,
                          curve: Interval(0.6, 0.8, curve: Curves.easeInOut))),
              child: ScaleTransition(
                alignment: Alignment.bottomCenter,
                scale: Tween<double>(begin: 0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: _productDetailsAnimationController,
                        curve: Interval(0.4, 0.6, curve: Curves.easeInOut))),
                child: Text(
                  "Buy Now",
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 20.0,
          ),

          AnimatedBuilder(
            animation: _priceContainerAnimationController,
            builder: (context, child) {
              final double widthPercentage = Tween<double>(begin: 0, end: 1.0)
                  .animate(CurvedAnimation(
                      parent: _productDetailsAnimationController,
                      curve: Interval(0.5, 1.0, curve: Curves.easeInOut)))
                  .value;
              return Container(
                width:
                    MediaQuery.of(context).size.width * (0.1) * widthPercentage,
                height: 2.5,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5.0)),
              );
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          SlideTransition(
            child: FadeTransition(
              opacity:
                  Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: _productDetailsAnimationController,
                curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
              )),
              child: Text("""
In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available. """),
            ),
            position: Tween<Offset>(begin: Offset(0, 0.25), end: Offset(0.0, 0))
                .animate(
              CurvedAnimation(
                parent: _productDetailsAnimationController,
                curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Hero(
                        tag: widget.productImage,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(widget.productImage),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(40.0))),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * (0.65),
                        ),
                      ),
                    ),
                    _buildColorContainer(),
                    _buildPriceContainer(),
                    _buildSizeContainer(),
                  ],
                ),
                //
                _buildProductDetailsContainer(),
              ],
            ),
          ),
          _buildBackAndSearchButtonContainer(),
          _buildAddToBagAndFavoriteButtonContainer(),
        ],
      ),
    );
  }
}
