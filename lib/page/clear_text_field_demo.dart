import 'package:flutter/material.dart';
import 'package:flutter_custom_widget/widget/clear_textfield.dart';

class ClearTextFiledDemo extends StatefulWidget {
  @override
  _ClearTextFiledDemoState createState() => _ClearTextFiledDemoState();
}

class _ClearTextFiledDemoState extends State<ClearTextFiledDemo> {
  var controller1 = TextEditingController();
  var controller2 = TextEditingController();
  var controller3 = TextEditingController();
  var controller4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ClearTextFiledDemo"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child:ListView(
          children: <Widget>[
            ClearTextField(
              controller: controller1,
              height: 40,
              hintText: "请输入姓名",
              prefixIcon: Icons.people,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            ClearTextField(
              controller: controller2,
              height: 40,
              hintText: "请输入电话号码",
              prefixIcon: Icons.phone,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            ClearTextField(
              height: 40,
              controller: controller3,
              hintText: "请输入邮箱",
              prefixIcon: Icons.email,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            ClearTextField(
              controller: controller4,
              height: 40,
              hintText: "请输入密码",
              prefixIcon: Icons.cloud_queue,
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }
}
