import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameChatMessageScreen extends StatefulWidget {
  GameChatMessageScreen({Key? key}) : super(key: key);

  @override
  _GameChatMessageScreenState createState() => _GameChatMessageScreenState();
}

class _GameChatMessageScreenState extends State<GameChatMessageScreen> with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 350));
  late Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutBack));

  double profileHeightAndWidth = 70.0;

  String message = "hypocrisy ki bhi seema hoti hai";

  List<String> messages = [
    "hypocrisy ki bhi seema hoti hai",
    "Aee safed kapda",
    "Modi hai to mumkin hai",
    "Paheli fursat me nikal",
  ];

  Timer? timer;

  //time to show chat message send by user
  final messageShowTimeInSeconds = 3;
  late int seconds = messageShowTimeInSeconds;

  void addMessage(MessageCubit messageCubit) async {
    Random random = Random();
    messageCubit.addMessage(messages[random.nextInt(messages.length)]);
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
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(onPressed: () async {
          MessageCubit messageCubit = context.read<MessageCubit>();
          //if user has any old message delete the message
          if (messageCubit.hasAnyMessage()) {
            //remove message
            messageCubit.removeMessage();
            //cancel timer
            timer?.cancel();
            await Future.delayed(Duration(milliseconds: 400));
            addMessage(messageCubit);
          } else {
            addMessage(messageCubit);
          }
        }),
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
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: profileHeightAndWidth * 1.35,
                  left: MediaQuery.of(context).size.width * (0.025),
                ),
                child: ScaleTransition(
                  alignment: Alignment(-0.5, 1.0),
                  scale: animation,
                  child: CustomPaint(
                    painter: TriangleCustomPainter(),
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
          ],
        ),
      ),
    );
  }
}

class TriangleCustomPainter extends CustomPainter {
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
    path.lineTo(size.width * (0.35), size.height);
    //to add how loan triangle will go down
    path.lineTo(size.width * (0.25), size.height * (1.3));
    path.lineTo(size.width * (0.15), size.height);
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
