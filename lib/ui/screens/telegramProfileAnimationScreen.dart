import 'package:flutter/material.dart';
import 'package:ui_ux/convertNumber.dart';

class TelegramProfileAnimationScreen extends StatefulWidget {
  final Size deviceSize;
  TelegramProfileAnimationScreen({Key? key, required this.deviceSize})
      : super(key: key);

  @override
  State<TelegramProfileAnimationScreen> createState() =>
      _TelegramProfileAnimationScreenState();
}

class _TelegramProfileAnimationScreenState
    extends State<TelegramProfileAnimationScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController = ScrollController()
    ..addListener(_scrollListener);

  late AnimationController _appbarProfileAnimationController =
      AnimationController(vsync: this);

  void _scrollListener() {
    if (_scrollController.offset <=
        widget.deviceSize.height * (0.275) * (0.5)) {
      double animationControllerValue = ConvertNumber.inRange(
          currentValue: _scrollController.offset,
          minValue: 0.0,
          maxValue: widget.deviceSize.height * (0.275) * (0.5),
          newMaxValue: 1.0,
          newMinValue: 0.0);

      _appbarProfileAnimationController.value = animationControllerValue;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _appbarProfileAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, hasScroller) {
            return [
              SliverPersistentHeader(
                  pinned: true,
                  delegate: AppbarPersistentHeader(
                      animationController: _appbarProfileAnimationController,
                      deviceHeight: widget.deviceSize.height,
                      scrollController: _scrollController))
            ];
          },
          body: ListView.builder(
              itemCount: 25,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("$index"),
                );
              })),
    );
  }
}

class AppbarPersistentHeader extends SliverPersistentHeaderDelegate {
  final double deviceHeight;
  final ScrollController scrollController;
  final AnimationController animationController;

  AppbarPersistentHeader(
      {required this.deviceHeight,
      required this.scrollController,
      required this.animationController});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Container(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 30.0, top: MediaQuery.of(context).padding.top),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 25.0,
                      )),
                ),
              ),
              Positioned(
                left: 20.0 + 50 * animationController.value,
                top: MediaQuery.of(context).padding.top +
                    deviceHeight *
                        (0.275) *
                        (0.19) *
                        (1.0 - animationController.value),
                child: CircleAvatar(
                  radius: 23.0 - (3.0 * animationController.value),
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                      40.0 - (40.0 * animationController.value)),
                  bottomRight: Radius.circular(
                      40.0 - (40.0 * animationController.value)))),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * (0.275),
        );
      },
    );
  }

  @override
  double get maxExtent => deviceHeight * (0.25);

  @override
  double get minExtent => deviceHeight * (0.125);

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
