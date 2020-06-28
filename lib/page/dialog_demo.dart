import 'package:flutter/material.dart';
import '../widget/date_picker.dart' as picker;
class DialogDemo extends StatefulWidget {
  @override
  _DialogDemoState createState() => _DialogDemoState();
}

class _DialogDemoState extends State<DialogDemo> {
  GlobalKey _leftTopKey = GlobalKey();
  GlobalKey _centerTopKey = GlobalKey();
  GlobalKey _centerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DialogDemo"),
      ),
      body: Container(
        color: Colors.blueAccent[400],
        child: Stack(
          children: <Widget>[
            Positioned(
              key: _leftTopKey,
              left: 0,
              top: 0,
              child: RaisedButton(
                child: Text("BUTTON"),
                onPressed: () {
                  showPositionDialog(_leftTopKey);
                },
              ),
            ),
            Positioned(
              key: _centerTopKey,
              left: MediaQuery.of(context).size.width/2.0,
              top: 0,
              child: RaisedButton(
                child: Text("BUTTON"),
                onPressed: () {
                  showPositionDialog(_centerTopKey);
                },
              ),
            ),
            Positioned(
              key: _centerKey,
              left:  MediaQuery.of(context).size.width/2.0,
              top:  MediaQuery.of(context).size.height/2.0,
              child: RaisedButton(
                child: Text("BUTTON"),
                onPressed: () {
                  showPositionDialog(_centerKey);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPositionDialog(GlobalKey<State<StatefulWidget>> globalKey) async {
    RenderBox dateBox = globalKey.currentContext.findRenderObject();
    Size dateBoxSize = dateBox.size;
    Offset dateBoxOffset = dateBox.localToGlobal(Offset(0, 0));
    Offset offset =
        Offset(dateBoxOffset.dx, dateBoxOffset.dy + dateBoxSize.height/2);
    print("offset = $offset");
    DateTime toDay = DateTime.now();
    DateTime firstDay = toDay.subtract(Duration(days: 1));
    DateTime lastDate = toDay.add(Duration(days: 30));
    DateTime dateTime = await picker.showDatePicker(
        context: context,
        offset: offset,
        width: 350,
        height: 240,
        initialDate: toDay,
        firstDate: firstDay,
        lastDate: lastDate,
        showBottomButton: false,
        onTapFirst: (DateTime firstTime) {
          print("fistTime = $firstTime");
        },
        onTapSecond: (DateTime secondTime) {
          print("secondTime = $secondTime");
        },
        onConfirm: () {
          print("onConfirm");
        });
    print("dateTime = $dateTime");
  }
}
