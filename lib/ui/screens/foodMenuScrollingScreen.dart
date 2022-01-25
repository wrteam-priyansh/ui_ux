import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodMenuScrollingScreen extends StatefulWidget {
  FoodMenuScrollingScreen({Key? key}) : super(key: key);

  @override
  _FoodMenuScrollingScreenState createState() =>
      _FoodMenuScrollingScreenState();
}

class _FoodMenuScrollingScreenState extends State<FoodMenuScrollingScreen> {
  List<String> foodMenu = [
    "Pizza",
    "Burger",
    "Sandwhich",
    "Samosa",
    "Momos",
    "Dabeli",
    "Vadapau",
    "Soft-drink",
    "Vodka",
    "Beer",
    "Whisky",
  ];

  int currentSelectedMenuIndex = 0;

  late ScrollController foodMenuScrollController = ScrollController()
    ..addListener(foodMenuScrollListener);

  late ScrollController primarySliverScrollController = ScrollController();

  late bool isScrollingPrimarySliver = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      primarySliverScrollController.position.isScrollingNotifier
          .addListener(isScrollingOrNotListerner);
    });
    super.initState();
  }

  void isScrollingOrNotListerner() {
    isScrollingPrimarySliver =
        primarySliverScrollController.position.isScrollingNotifier.value;
    if (!isScrollingPrimarySliver) {
      findMenuItemIndexAfterScrollEnd();
    }
  }

  void changeMenuIndex(int index) {
    setState(() {
      currentSelectedMenuIndex = index;
    });
  }

  void changeMenuIndexAndScrollToMenuItems(int index) {
    changeMenuIndex(index);
    double scrollOffset =
        (index * (MediaQuery.of(context).size.height * 0.175 + 5)) +
            (MediaQuery.of(context).size.height * (0.25));
    primarySliverScrollController.animateTo(scrollOffset,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);

    foodMenuScrollController.animateTo(
        context
            .read<FoodMenuTextSizeProvider>()
            .getSumOfPreviousTextSize(index - 1),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut);
  }

  void findMenuItemIndexAfterScrollEnd() {
    double topContentHeights = MediaQuery.of(context).size.height * (0.25);

    //handle case for 0 index
    int menuItemIndex = -1;
    for (var i = 0; i < foodMenu.length; i++) {
      double minHeightChecker =
          i * MediaQuery.of(context).size.height * (0.175) + topContentHeights;
      if (primarySliverScrollController.offset >= minHeightChecker &&
          primarySliverScrollController.offset <=
              minHeightChecker +
                  (MediaQuery.of(context).size.height * (0.175))) {
        menuItemIndex = i;
        break;
      }
    }
    if (menuItemIndex != -1) {
      changeMenuIndexAndScrollToMenuItems(menuItemIndex);
    }
  }

  void foodMenuScrollListener() {
    //This can be use for changing menu based on how much user has scrolled
    // if (!isScrollingPrimarySliver) {
    //   int menuIndex = context
    //       .read<FoodMenuTextSizeProvider>()
    //       .getMenuIndex(foodMenuScrollController.offset);

    //   //TODO: improve here
    //   if (currentSelectedMenuIndex != menuIndex) {
    //     int indexDifference = currentSelectedMenuIndex - menuIndex;
    //     if (indexDifference == 1 || indexDifference == -1) {
    //       changeMenuIndexAndScrollToMenuItems(menuIndex);
    //     }
    //   }
    // }
  }

  @override
  void dispose() {
    foodMenuScrollController.removeListener(foodMenuScrollListener);

    foodMenuScrollController.dispose();
    primarySliverScrollController.dispose();
    super.dispose();
  }

  Widget _buildMenuItems(int index) {
    return Container(
      alignment: Alignment.center,
      child: Text("$index"),
      margin: EdgeInsets.only(bottom: 5.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * (0.175),
      decoration: BoxDecoration(border: Border.all()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: CustomScrollView(
          controller: primarySliverScrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: Colors.blueAccent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * (0.25),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: FoodMenuHeaderDelegate(
                  deviceHeight: MediaQuery.of(context).size.height,
                  foodMenu: foodMenu,
                  currentSelectedMenuIndex: currentSelectedMenuIndex,
                  scrollController: foodMenuScrollController,
                  changeMenuIndex: changeMenuIndexAndScrollToMenuItems),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                List.generate(11, (index) => index)
                    .map((e) => _buildMenuItems(e))
                    .toList(),
              ),
            ),
          ],
        ));
  }
}

class FoodMenuHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double deviceHeight;
  final List<String> foodMenu;
  final int currentSelectedMenuIndex;
  final Function changeMenuIndex;
  final ScrollController scrollController;

  FoodMenuHeaderDelegate(
      {required this.deviceHeight,
      required this.foodMenu,
      required this.currentSelectedMenuIndex,
      required this.scrollController,
      required this.changeMenuIndex});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
          controller: scrollController,
          itemCount: foodMenu.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return MenuItemContainer(
                text: foodMenu[index],
                onTapMenu: changeMenuIndex,
                index: index,
                selectedIndex: currentSelectedMenuIndex);
          }),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * (0.05),
    );
  }

  @override
  double get maxExtent => deviceHeight * (0.05);

  @override
  double get minExtent => deviceHeight * (0.05);

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class MenuItemContainer extends StatefulWidget {
  final String text;
  final int index;
  final int selectedIndex;
  final Function onTapMenu;
  MenuItemContainer(
      {Key? key,
      required this.text,
      required this.onTapMenu,
      required this.index,
      required this.selectedIndex})
      : super(key: key);

  @override
  State<MenuItemContainer> createState() => _MenuItemContainerState();
}

class _MenuItemContainerState extends State<MenuItemContainer> {
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context
          .read<FoodMenuTextSizeProvider>()
          .addTextSize(_textSize(widget.text, TextStyle()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTapMenu(widget.index);
      },
      child: Container(
        margin: EdgeInsets.only(top: 7.5, bottom: 7.5, left: 5.0),
        decoration: BoxDecoration(
            color: widget.selectedIndex == widget.index
                ? Colors.orangeAccent
                : Colors.transparent),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Text(
          widget.text,
          style: TextStyle(
            color: widget.selectedIndex == widget.index
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}

class FoodMenuTextSizeProvider with ChangeNotifier {
  List<Size> _textSizes = [];

  List<Size> get textSizes => _textSizes;

  void addTextSize(Size size) {
    if (_textSizes.length < 11) {
      _textSizes.add(size);
      notifyListeners();
    }
  }

  //

  int getMenuIndex(double currentScroll) {
    int menuIndex = 0;
    for (var i = 0; i < 11; i++) {
      if (getSumOfPreviousTextSize(i) >= currentScroll &&
          currentScroll <=
              (_textSizes[i].width + getSumOfPreviousTextSize(i))) {
        menuIndex = i;
        break;
      }
    }
    return menuIndex;
  }

  double getSumOfPreviousTextSize(int index) {
    double sumOfSize = 0;
    for (var i = 0; i < index; i++) {
      sumOfSize = sumOfSize +
          _textSizes[i].width +
          20; //20 is calculated calculated padding
    }
    return sumOfSize;
  }
}
