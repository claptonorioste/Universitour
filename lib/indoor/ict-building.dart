import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:universitour/indoorFunctions/circle.dart';
import 'package:universitour/indoorFunctions/location.dart';
import 'package:universitour/indoorFunctions/zoom.dart';
import 'package:universitour/myFunctions/searchDelegate.dart';
import 'package:flutter/services.dart';
import 'package:universitour/outdoor/customWidgets.dart';


class ICTBldng extends StatefulWidget {

  final List<ListTile> task;

  final List<LatLng> destinations;

  ICTBldng({Key key, @required this.task , @required this.destinations}) : super(key: key);

  @override
  _ICTBldng createState() => _ICTBldng(task,destinations);

}

class _ICTBldng extends State<ICTBldng> {

  List<ListTile> task;

  List<LatLng> destinations;

  _ICTBldng(this.task,this.destinations);
  
  double x = 0.0;
  double y = 0.0;



  bool _viewInfo = false;

  Offset userPosition;

  final String groundFloor = "assets/floorplan/ict-building/ICT-GrndFlr.png";

  final String secondFloor = "assets/floorplan/ict-building/ICT-2ndFlr.png";

  final String thirdFloor = "assets/floorplan/ict-building/ICT-3rdFlr.png";

  final String fourthFloor = "assets/floorplan/ict-building/ICT-4thFlr.png";

  String floor = "";

  String floorLabel = "";

  String wifiF = "";

  String wifiS = "";

  String wifiT = "";

  String wifiSF = "";

  String wifiSS = "";

  String wifiST = "";

  var points = [
    Offset(160, 700),
    Offset(170, 650),
    Offset(173, 630),
    Offset(180, 580),
    Offset(180, 560),
    Offset(185, 510),
    Offset(185, 500),
    Offset(185, 440),
    Offset(185, 420),
    Offset(185, 380),
    Offset(185, 360),
    Offset(185, 310),
    Offset(180, 290),
    Offset(176, 260),
    Offset(160, 200),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      floor = groundFloor;
      floorLabel = "G";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ictMapBuilder(context),
        menuDialog(),
        sideMenu(),
      ],
    ));
  }

  Widget sideMenu() {
    return Align(
      alignment: FractionalOffset.centerRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: FlatButton(
              child: Text(
                'OUT',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            margin: EdgeInsets.only(right: 10, bottom: 10),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    child: Icon(
                      Icons.arrow_upward,
                      size: 30.0,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        if (floor == groundFloor) {
                          floor = secondFloor;
                          floorLabel = "2";
                        } else if (floor == secondFloor) {
                          floor = thirdFloor;
                          floorLabel = "3";
                        } else if (floor == thirdFloor) {
                          floor = fourthFloor;
                          floorLabel = "4";
                        }
                      });
                    },
                  ),
                ),
                Text(
                  floorLabel,
                  style: TextStyle(fontSize: 25.0, color: Colors.blue,),
                ),
                Expanded(
                  child: FlatButton(
                    child: Icon(
                      Icons.arrow_downward,
                       color: Colors.blue,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        if (floor == secondFloor) {
                          floor = groundFloor;
                          floorLabel = "G";
                        } else if (floor == thirdFloor) {
                          floor = secondFloor;
                          floorLabel = "2";
                        } else if (floor == fourthFloor) {
                          floor = thirdFloor;
                          floorLabel = "3";
                        }
                      });
                    },
                  ),
                ),
               
              ],
            ),
            margin: EdgeInsets.only(right: 10),
            width: 60,
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          Container(
            child: FlatButton(
              child: Icon(
                Icons.assignment,
                size: 30.0,
                color: Colors.green,
              ),
              onPressed: () {
                CustomWidgets(context).questDialog(task,destinations);
              },
            ),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            margin: EdgeInsets.only(right: 10, top: 10),
          ),
           FlatButton(child: Icon(Icons.arrow_upward),onPressed: (){
             setState(() {
               y -= 5;
               print('Y Axis: '+y.toString());
               print('X Axis: '+x.toString());
             });
           },),
           FlatButton(child: Icon(Icons.arrow_downward),onPressed: (){setState(() {
             y += 5;
               print('Y Axis: '+y.toString());
               print('X Axis: '+x.toString());
           });},),
           FlatButton(child: Icon(Icons.arrow_back),onPressed: (){
            setState(() {
               x -= 5;
                print('Y Axis: '+y.toString());
               print('X Axis: '+x.toString());
            });
           },),
           FlatButton(child: Icon(Icons.arrow_forward),onPressed: (){setState(() {
             x += 5;
              print('Y Axis: '+y.toString());
               print('X Axis: '+x.toString());
           });},)
        ],
      ),
    );
  }

  Widget ictMapBuilder(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
            color: Colors.grey[350],
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: ZoomableWidget(
              child: Container(
                margin: EdgeInsets.only(top: 60,right: 20),
                padding: EdgeInsets.all(70),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                     
                      image: DecorationImage(
                          image: ExactAssetImage(floor), fit: BoxFit.contain)),
                  child: Stack(
                    children: <Widget>[
                      CustomPaint(
                        painter: DrawLocation(Offset(x, y)),
                      ),
                     CustomPaint(painter: DrawCircle(Colors.red),)
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }


  Widget infoDialog() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        child: Column(
          children: <Widget>[
           ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.only(bottom: 10.0),
        height: 160,
        width: 360,
      ),
    );
  }

  Widget menuDialog() {
    return Align(
      alignment: FractionalOffset.topCenter,
      child: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.menu),
                  ),
                  Container(
                    width: 250,
                    child: GestureDetector(
                      onTap: () {
                        showSearch(
                            context: context, delegate: CustomSearchDelegate());
                      },
                      child: Container(
                        child: Text('Search Here'),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                  ),
                ],
              )
            ]),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.only(top: 50.0),
        height: 58,
        width: 360,
      ),
    );
  }
}
