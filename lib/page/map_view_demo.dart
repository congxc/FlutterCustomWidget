import 'dart:convert';
import '../bean/point_f.dart';
import '../res/style/style.dart';
import '../widget/map/map_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const double _KAppBarSize = 45.0;
const bool isDebug = true;

class MapViewPage extends StatefulWidget {
  static const sName = "home_page";

  @override
  _MapViewPageState createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  static const String main_channel = "main_channel";

  String _mapUrl;
  List<PointF> _pointList;
  PointF _currentLocation;
  MethodChannel _methodChannel;
  List<PointF> _routeList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _routeList = new List();
    if (isDebug) {
      _mapUrl = "/storage/emulated/0/map_0310.png";
      String res =
          '[{"pointId":"61be0b0450cc0038374c0b50249b882d","pointName":"电梯","x":322.0,"y":381.0},'
          '{"pointId":"81ff4ee4f5655f39008866c2f6d4bdbb","pointName":"走廊","x":351.0,"y":415.0},'
          '{"pointId":"692e92669c0ca340eff4fdcef32896ee","pointName":"北京","x":403.0,"y":458.0}]';
      List list = json.decode(res);
      _pointList = list.map((item) => PointF.fromJson(item)).toList();
    } else {
      _methodChannel = MethodChannel(main_channel)
        ..setMethodCallHandler(_handleMessage);
    }
  }

  Future<dynamic> _handleMessage(MethodCall call) async {
    if (call.method == "get_map_points") {
      String res = call.arguments;
      print("flutter json = " + res);
      List list = json.decode(res);
      List pointList = list.map((item) => PointF.fromJson(item)).toList();
      setState(() {
        _pointList = pointList;
      });
      return pointList;
    } else if (call.method == "get_map_url") {
      setState(() {
        _mapUrl = call.arguments;
        print("flutter mapUrl = " + _mapUrl);
      });
      return _mapUrl;
    } else if (call.method == "get_current_location") {
      String res = call.arguments;
      _currentLocation = PointF.fromJson(json.decode(res));
      print("flutter _currentLocation = " + _currentLocation.toString());
      return _currentLocation;
    }
  }

  void _onPositionSelected(PointF value) {
    if (_routeList.isNotEmpty && _routeList.last == value) {
      return;
    }
    _routeList.add(value);
    _routeList.map((item) {
      print("flutter routeItem = " + item.pointName);
    });
  }

  Future<bool> finish() async {
    Navigator.pop(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    print("flutter:_mapUrl = " + (_mapUrl == null ? "null" : _mapUrl));
    return WillPopScope(
      onWillPop: finish,
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Resources.getDrawable("bg_main.png")),
              fit: BoxFit.fill,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(_KAppBarSize),
              child: AppBar(
                backgroundColor: Color(0xDB040116),
                leading: IconButton(
                  onPressed: () {
                    finish();
                  },
                  icon: Image(
                    image: AssetImage(Resources.getDrawable("icon_back.png")),
                  ),
                ),
                toolbarOpacity: 0.86,
                centerTitle: true,
                title: Text(
                  "地图",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            body: Container(
              child: _mapUrl == null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(Resources.getDrawable("icon_no_map.png")),
                          Padding(
                            padding: EdgeInsets.only(top: 39),
                          ),
                          Text(
                            "还没有地图哟",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : MapView(
                      _mapUrl,
                      pointList: _pointList,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - _KAppBarSize,
                      onPositionSelected: _onPositionSelected,
                    ),
            ),
            resizeToAvoidBottomPadding: false,
          ),
        ),
      ),
    );
  }
}
