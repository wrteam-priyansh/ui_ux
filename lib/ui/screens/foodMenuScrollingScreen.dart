import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodMenuScrollingScreen extends StatefulWidget {
  FoodMenuScrollingScreen({Key? key}) : super(key: key);

  @override
  _FoodMenuScrollingScreenState createState() =>
      _FoodMenuScrollingScreenState();
}

class FoodMenuItemModel {
  final String menuTitle;
  final List<Map<String, int>> subMenu;

  FoodMenuItemModel({required this.menuTitle, required this.subMenu});
}

List<FoodMenuItemModel> foodMenu = [
  FoodMenuItemModel(menuTitle: "Pizza", subMenu: [
    {"Veg Pizze": 5},
    {"Non-veg Pizze": 5}
  ]),
  FoodMenuItemModel(menuTitle: "Burger", subMenu: [
    {"Veg Burger": 5},
    {"Non-veg Burger": 2}
  ]),
  FoodMenuItemModel(menuTitle: "Sandwhich", subMenu: [
    {"Veg Sandwhich": 2},
    {"Non-veg Sandwhich": 5}
  ]),
  FoodMenuItemModel(menuTitle: "Momos", subMenu: [
    {"Veg Momos": 3},
    {"Non-veg Momos": 1}
  ]),
  FoodMenuItemModel(menuTitle: "Dabeli", subMenu: [
    {"Hot Dabeli": 1},
    {"Cold Dabeli ": 1}
  ]),
];

double foodItemHeight = 100;

class _FoodMenuScrollingScreenState extends State<FoodMenuScrollingScreen> {
  int currentSelectedMenuIndex = 0;

  late ScrollController foodMenuScrollController = ScrollController();

  late ScrollController primarySliverScrollController = ScrollController();

  late bool scrollPrimaryViewInScrollNotificationListener = false;

  late List<GlobalKey> foodItemGlobalKeys = [];

  @override
  void initState() {
    for (var _ in foodMenu) {
      foodItemGlobalKeys.add(GlobalKey<FoodMenuTitleAndItemsContainerState>());
    }
    super.initState();
  }

  void changeMenuIndex(int index) {
    setState(() {
      currentSelectedMenuIndex = index;
    });
  }

  void changePrimaryScrollPosition() {
    //initial scroll offset means height of other data that is above the foodItems
    double scrollOffset = MediaQuery.of(context).size.height * (0.25);

    for (var i = 0; i < currentSelectedMenuIndex; i++) {
      scrollOffset = scrollOffset +
          (foodItemGlobalKeys[i].currentContext?.size?.height ?? 0);
    }

    primarySliverScrollController.animateTo(scrollOffset,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void changeFoodMenuScrollPosition() {
    foodMenuScrollController.animateTo(
        context
            .read<FoodMenuTextSizeProvider>()
            .getSumOfPreviousTextSize(currentSelectedMenuIndex),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut);
  }

  void changeMenuIndexAndScrollToMenuItems(int index) {
    if (index != currentSelectedMenuIndex) {
      changeMenuIndex(index);
      changePrimaryScrollPosition();
    }
  }

  double _foodMenuItemMinPosition(int index) {
    double position = MediaQuery.of(context).size.height * (0.25);

    for (var i = 0; i < index; i++) {
      position =
          (foodItemGlobalKeys[i].currentContext?.size?.height ?? 0) + position;
    }

    return position;
  }

  double _getFoodMenuItemHeight(int index) {
    return (foodItemGlobalKeys[index].currentContext?.size?.height ?? 0);
  }

  int _getFoodMenuIndexBasedOnScrollPosition() {
    int foodMenuIndex = 0;

    if (primarySliverScrollController.offset ==
        primarySliverScrollController.position.maxScrollExtent) {
      return foodItemGlobalKeys.length - 1;
    }

    for (var i = 0; i < foodItemGlobalKeys.length; i++) {
      final minValue = _foodMenuItemMinPosition(i);

      if (minValue <= primarySliverScrollController.offset &&
          primarySliverScrollController.offset <
              minValue + _getFoodMenuItemHeight(i)) {
        foodMenuIndex = i;
        break;
      }
    }

    return foodMenuIndex;
  }

  @override
  void dispose() {
    foodMenuScrollController.dispose();
    primarySliverScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              changeMenuIndex(_getFoodMenuIndexBasedOnScrollPosition());
            }
            return true;
          },
          child: CustomScrollView(
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
                    foodMenu: foodMenu.map((e) => e.menuTitle).toList(),
                    currentSelectedMenuIndex: currentSelectedMenuIndex,
                    scrollController: foodMenuScrollController,
                    changeMenuIndex: changeMenuIndexAndScrollToMenuItems),
              ),
              SliverToBoxAdapter(
                child: Column(
                    children: foodMenu
                        .map((e) => FoodMenuTitleAndItemsContainer(
                              foodMenuItemModel: e,
                              key: foodItemGlobalKeys[foodMenu.indexOf(e)],
                            ))
                        .toList()),
              ),
              SliverToBoxAdapter(
                child: Container(
                    height: MediaQuery.of(context).size.height * (0.25),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blueAccent),
              ),
            ],
          ),
        ));
  }
}

class FoodMenuTitleAndItemsContainer extends StatefulWidget {
  final FoodMenuItemModel foodMenuItemModel;
  FoodMenuTitleAndItemsContainer({Key? key, required this.foodMenuItemModel})
      : super(key: key);

  @override
  State<FoodMenuTitleAndItemsContainer> createState() =>
      FoodMenuTitleAndItemsContainerState();
}

class FoodMenuTitleAndItemsContainerState
    extends State<FoodMenuTitleAndItemsContainer> {
  int totalFoodItems() {
    int totalFoodItems = 0;

    final subMenu = widget.foodMenuItemModel.subMenu;

    for (var foodSubMenu in subMenu) {
      totalFoodItems = totalFoodItems + foodSubMenu[foodSubMenu.keys.first]!;
    }

    return totalFoodItems;
  }

  Widget _buildFoodItem(int index) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      color: Colors.black26,
      height: foodItemHeight,
      child: Center(child: Text("Food ${index + 1}")),
    );
  }

  Widget _buildSubmenuTitleAndItems(Map<String, int> subMenu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          alignment: Alignment.centerLeft,
          child: Text(
            subMenu.keys.first,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        ...List.generate(subMenu.values.first, (index) => index)
            .map((e) => _buildFoodItem(e))
            .toList()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.foodMenuItemModel.menuTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ...widget.foodMenuItemModel.subMenu
              .map((e) => _buildSubmenuTitleAndItems(e))
              .toList()
        ],
      ),
      margin: EdgeInsets.only(
          bottom: 10.0,
          left: MediaQuery.of(context).size.width * (0.05),
          right: MediaQuery.of(context).size.width * (0.05)),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade200),
    );
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
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        return true;
      },
      child: Container(
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
      ),
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
    if (_textSizes.length < foodMenu.length) {
      _textSizes.add(size);
      notifyListeners();
    }
  }

  //

  int getMenuIndex(double currentScroll) {
    int menuIndex = 0;
    for (var i = 0; i < foodMenu.length; i++) {
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
      sumOfSize =
          sumOfSize + _textSizes[i].width + 20; //20 is calculated padding
    }
    return sumOfSize;
  }
}
