import 'package:flutter/material.dart';

const List<String> images = [
  "assets/images/man_a.jpg",
  "assets/images/man_a2.jpg",
  "assets/images/man_a3.jpg",
  "assets/images/man_a4.jpg",
  "assets/images/man_a5.jpg",
  "assets/images/woman_a.jpg",
  "assets/images/woman_a2.jpg",
  "assets/images/woman_a3.jpg",
  "assets/images/woman_a4.jpg",
];

class InnerScrollingImageSliderScreen extends StatefulWidget {
  final Size screenSize;
  InnerScrollingImageSliderScreen({Key? key, required this.screenSize}) : super(key: key);

  @override
  _InnerScrollingImageSliderScreenState createState() => _InnerScrollingImageSliderScreenState();
}

class _InnerScrollingImageSliderScreenState extends State<InnerScrollingImageSliderScreen> {
  late PageController pageController = PageController();
  late double initialPosition = widget.screenSize.width * (0.4);
  late List<ScrollController> scrollControllers = [
    ScrollController(initialScrollOffset: initialPosition),
    ScrollController(initialScrollOffset: initialPosition),
    ScrollController(initialScrollOffset: initialPosition),
    ScrollController(initialScrollOffset: initialPosition),
    ScrollController(initialScrollOffset: initialPosition),
    ScrollController(initialScrollOffset: initialPosition),
    ScrollController(initialScrollOffset: initialPosition),
    ScrollController(initialScrollOffset: initialPosition),
    ScrollController(initialScrollOffset: initialPosition),
  ];

  int currentIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    scrollControllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  void changePageViewScrollPhysics() {}

  void onHorizontalDragStart(DragStartDetails dragStartDetails) {
    //print();
    print(widget.screenSize.width);
  }

  void onHorizontalDragDown(DragDownDetails dragDownDetails) {
    //print();
  }

  void onHorizontalDragCancel() {
    //print();
  }

  void onHorizontalDragEnd(DragEndDetails dragEndDetails) {
    //print();
  }

  void onHorizontalDragUpdate(DragUpdateDetails dragUpdateDetails) {
    if (dragUpdateDetails.primaryDelta! != 0.0) {
      double value = scrollControllers[currentIndex].offset - dragUpdateDetails.primaryDelta!;

      //if user has scrolled to the forward side end of the image
      //then it's time to scroll page view
      if (value >= scrollControllers[currentIndex].position.maxScrollExtent) {
        double pageControllerValue = pageController.offset - dragUpdateDetails.primaryDelta!;

        if (currentIndex != (images.length - 1)) {
          pageController.jumpTo(pageControllerValue);
        }
      } else {
        if (value < 0.0) {
          //if user has scrolled to the backword side end of the image
          //then it's time to scroll page view
          double pageControllerValue = pageController.offset - dragUpdateDetails.primaryDelta!;
          if (currentIndex != 0) {
            pageController.jumpTo(pageControllerValue);
          }
        } else {
          scrollControllers[currentIndex].jumpTo(value);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InnerScrollingImageSliderScreen(
                        screenSize: MediaQuery.of(context).size,
                      )));
        },
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onHorizontalDragStart: onHorizontalDragStart,
              onHorizontalDragCancel: onHorizontalDragCancel,
              onHorizontalDragDown: onHorizontalDragDown,
              onHorizontalDragEnd: onHorizontalDragEnd,
              onHorizontalDragUpdate: onHorizontalDragUpdate,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * (1.0),
                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return ImageScrollContainer(
                      index: index,
                      scrollController: scrollControllers[index],
                    );
                  },
                ),
              ),
            ),
          ),
          currentIndex != (images.length - 1)
              ? Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: IconButton(
                      onPressed: () {
                        pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      )),
                )
              : SizedBox(),
          currentIndex != 0
              ? Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    onPressed: () {
                      pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ))
              : SizedBox(),
        ],
      ),
    );
  }
}

class ImageScrollContainer extends StatefulWidget {
  final int index;
  final ScrollController scrollController;
  ImageScrollContainer({Key? key, required this.index, required this.scrollController}) : super(key: key);

  @override
  _ImageScrollContainerState createState() => _ImageScrollContainerState();
}

class _ImageScrollContainerState extends State<ImageScrollContainer> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      controller: widget.scrollController,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        width: MediaQuery.of(context).size.width * (1.8),
        child: Image.asset(
          images[widget.index],
          fit: BoxFit.fitHeight,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
