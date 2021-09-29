import 'package:flutter/material.dart';

class RefreshNestedScrollview extends StatefulWidget {
  RefreshNestedScrollview({Key? key}) : super(key: key);

  @override
  _RefreshNestedScrollviewState createState() => _RefreshNestedScrollviewState();
}

class _RefreshNestedScrollviewState extends State<RefreshNestedScrollview> with TickerProviderStateMixin {
  late TabController tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 5));
        },
        child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate.fixed([
              Container(
                width: 200,
                height: 500,
                color: Colors.red,
              ),
              Container(
                width: 200,
                height: 500,
                color: Colors.yellow,
              ),
              Container(
                width: 200,
                height: 500,
                color: Colors.red,
              ),
              Container(
                width: 200,
                height: 500,
                color: Colors.yellow,
              ),
              Container(
                width: 200,
                height: 500,
                color: Colors.red,
              ),
              Container(
                width: 200,
                height: 500,
                color: Colors.red,
              ),
            ]))
          ],
        ),
      ),
    );
  }
}
