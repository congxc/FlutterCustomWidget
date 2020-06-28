import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'page/clear_text_field_demo.dart';
import 'page/map_view_demo.dart';
import 'page/swipe_menu_list_demo.dart';
import 'page/dialog_demo.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle translucentStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(translucentStyle);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter custom widget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter custom widget'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: ListView(
          children: <Widget>[
            buildItem(context, "侧滑删除","SwipeMenuList",SwipeMenuListDemo()),
            buildItem(context, "带输出图标的TextFiled","ClearTextFiled",ClearTextFiledDemo()),
            buildItem(context, "弹出指定位置Dialog","PositionedDialog",DialogDemo()),
            buildItem(context, "地图","MapViewPage",MapViewPage()),
          ],
        ));
  }

  ListTile buildItem(BuildContext context, String title,String subTitle, Widget widget) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle,style: Theme.of(context).textTheme.subtitle,),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return widget;
          },
        ));
      },
    );
  }
}
