import 'package:flutter/material.dart';
import 'package:flutter_custom_widget/widget/swipe_layout.dart';

class SwipeMenuListDemo extends StatefulWidget {
  @override
  _SwipeMenuListDemoState createState() => _SwipeMenuListDemoState();
}

class _SwipeMenuListDemoState extends State<SwipeMenuListDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SwipeMenuListView"),
      ),
      body: ListView(
        children: buildList(),
      ),
    );
  }

  List<Widget> buildList() {
    List<SwipeLayout> list = [];
    for (int i = 0; i < 10; i++) {
      var key = GlobalKey<SwipeLayoutState>();
      Widget item = SwipeLayout(
        key: key,
        onSwipeStarted: () {
          list.forEach((item) {
            if (item.key != key) {
              item.key.currentState?.close();
            }
          });
        },
        mode: Mode.PullOut,
        content: Container(
          color: Colors.white,
          child: Container(
            height: 35,
            alignment: Alignment.center,
            child: Text(
              "内容$i",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        menuWidth: 160.0,
        menu: <Widget>[
          InkWell(
            onTap: () {},
            child: Container(
                width: 80,
                alignment: Alignment(0, 0),
                color: Colors.greenAccent,
                child: Text(
                  "编辑",
                  style: TextStyle(color: Colors.white),
                )),
          ),
          InkWell(
            onTap: () {},
            child: Container(
                width: 80,
                alignment: Alignment(0, 0),
                color: Colors.red,
                child: Text(
                  "删除",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      );
      list.add(item);
    }
    return list;
  }
}
