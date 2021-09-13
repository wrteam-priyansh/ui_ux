import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<String> messages = [
  "hypocrisy ki bhi seema hoti hai",
  "Aee safed kapda",
  "Modi hai to mumkin hai",
  "Paheli fursat me nikal",
];

class GameChatMessageScreen extends StatefulWidget {
  GameChatMessageScreen({Key? key}) : super(key: key);

  @override
  _GameChatMessageScreenState createState() => _GameChatMessageScreenState();
}

class _GameChatMessageScreenState extends State<GameChatMessageScreen> with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 350), reverseDuration: Duration(milliseconds: 300));
  late Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutBack));

  double profileHeightAndWidth = 70.0;

  String message = "hypocrisy ki bhi seema hoti hai";

  Timer? timer;

  //time to show chat message send by user
  final messageShowTimeInSeconds = 3;
  late int seconds = messageShowTimeInSeconds;

  void addMessage(MessageCubit messageCubit, String message) async {
    messageCubit.addMessage(message);
    addMessageDeleteTimer();
  }

  void addMessageDeleteTimer() {
    if (seconds != messageShowTimeInSeconds) {
      seconds = messageShowTimeInSeconds;
    }
    print("Start timer");
    timer = Timer.periodic(Duration(seconds: messageShowTimeInSeconds), (timer) {
      if (seconds == 0) {
        timer.cancel();
        context.read<MessageCubit>().removeMessage();
      } else {
        print("Time left to disappear the message : $seconds");
        seconds--;
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageCubit, MessageState>(
      bloc: context.read<MessageCubit>(),
      listener: (context, state) {
        if (state is MessageFetchedSuccess) {
          if (state.message.isEmpty) {
            animationController.reverse();
          } else {
            animationController.forward();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () async {}, icon: Icon(Icons.add)),
          ],
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: 5.0,
                  left: MediaQuery.of(context).size.width * (0.025),
                ),
                child: Container(
                  width: profileHeightAndWidth,
                  height: profileHeightAndWidth,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: profileHeightAndWidth * 1.35,
                  right: MediaQuery.of(context).size.width * (0.025),
                ),
                child: ScaleTransition(
                  alignment: Alignment(0.5, 1.0), //-0.5 left side nad 0.5 is right side
                  scale: animation,
                  child: CustomPaint(
                    painter: TriangleCustomPainter(false),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      alignment: Alignment.center,
                      child: BlocBuilder<MessageCubit, MessageState>(
                        builder: (context, state) {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 175),
                            child: state is MessageFetchedSuccess
                                ? Text(
                                    state.message,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                : Container(),
                          );
                        },
                      ),
                      height: 50,
                      width: MediaQuery.of(context).size.width * (0.4),
                    ),
                  ),
                ),
              ),
            ),

            //
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: 5.0,
                  right: MediaQuery.of(context).size.width * (0.025),
                ),
                child: Container(
                  width: profileHeightAndWidth,
                  height: profileHeightAndWidth,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: IconButton(
                    onPressed: () {
                      showModalBottomSheet<String>(
                          isDismissible: false,
                          enableDrag: false,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )),
                          context: context,
                          builder: (context) => MessagesBottomSheet()).then((value) async {
                        if (value != null) {
                          if (value.isNotEmpty) {
                            MessageCubit messageCubit = context.read<MessageCubit>();
                            //if user has any old message delete the message
                            if (messageCubit.hasAnyMessage()) {
                              //remove message
                              messageCubit.removeMessage();
                              //cancel timer
                              timer?.cancel();
                              await Future.delayed(Duration(milliseconds: 400));
                              addMessage(messageCubit, value);
                            } else {
                              addMessage(messageCubit, value);
                            }
                          }
                        }
                      });
                    },
                    icon: Icon(CupertinoIcons.conversation_bubble)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TriangleCustomPainter extends CustomPainter {
  bool triangleIsLeft;

  TriangleCustomPainter(this.triangleIsLeft);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();

    Paint paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    path.moveTo(size.width * (0.1), 0);
    path.lineTo(size.width * (0.9), 0);
    //add curve effect
    path.quadraticBezierTo(size.width, 0, size.width, size.height * 0.2);
    path.lineTo(size.width, size.height * (0.8));
    //add curve
    path.quadraticBezierTo(size.width, size.height, size.width * (0.9), size.height);
    //add triangle here
    path.lineTo(size.width * (triangleIsLeft ? 0.35 : 0.65), size.height);
    //to add how long triangle will go down
    path.lineTo(size.width * (triangleIsLeft ? 0.25 : 0.75), size.height * (1.3)); //75,25
    path.lineTo(size.width * (triangleIsLeft ? 0.15 : 0.85), size.height); //85,15
    //
    path.lineTo(size.width * (0.1), size.height);
    //add curve
    path.quadraticBezierTo(0, size.height, 0, size.height * (0.8));
    path.lineTo(0, size.height * (0.2));
    //add curve
    path.quadraticBezierTo(0, 0, size.width * (0.1), 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageFetchedSuccess extends MessageState {
  final String message;
  MessageFetchedSuccess(this.message);
}

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial()) {
    addMessage("");
  }

  void addMessage(String message) {
    emit(MessageFetchedSuccess(message));
  }

  void removeMessage() {
    emit(MessageFetchedSuccess(""));
  }

  bool hasAnyMessage() {
    if (state is MessageFetchedSuccess) {
      return (state as MessageFetchedSuccess).message.isNotEmpty;
    }
    return false;
  }
}

class MessagesBottomSheet extends StatefulWidget {
  MessagesBottomSheet({Key? key}) : super(key: key);

  @override
  _MessagesBottomSheetState createState() => _MessagesBottomSheetState();
}

class _MessagesBottomSheetState extends State<MessagesBottomSheet> {
  int currentSelectedMessageIndex = -1;

  Widget _buildMessageContainer(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentSelectedMessageIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10,
        ),
        child: Text(
          messages[index],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: index == currentSelectedMessageIndex ? Colors.blueAccent : Colors.grey,
        ),
      ),
    );
  }

  List<Widget> _buildMessages() {
    List<Widget> childern = [];
    for (var i = 0; i < messages.length; i++) {
      childern.add(_buildMessageContainer(i));
    }
    return childern;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 5.0,
              runSpacing: 10.0,
              children: _buildMessages(),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(currentSelectedMessageIndex == -1 ? "" : messages[currentSelectedMessageIndex]);
                },
                child: Text("Send message"))
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        )),
      ),
    );
  }
}
