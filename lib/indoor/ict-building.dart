import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:universitour/indoorFunctions/circle.dart';
import 'package:universitour/indoorFunctions/line.dart';
import 'package:universitour/indoorFunctions/location.dart';
import 'package:universitour/indoorFunctions/zoom.dart';
import 'package:universitour/models/building.dart';
import 'package:universitour/models/instructor.dart';
import 'package:universitour/models/room.dart';
import 'package:universitour/myFunctions/searchDelegate.dart';
import 'package:flutter/services.dart';
import 'package:universitour/outdoor/customWidgets.dart';
import 'dart:io';

import 'package:universitour/restAPI/onlineDB.dart';


class ICTBldng extends StatefulWidget {

  final List<ListTile> task;

  final List<LatLng> destinations;

  final Function addDestination,addDestLocation,setRouting,stopRoute;

  final double desX,desY;

  final String desFloor;

  ICTBldng({Key key, @required this.task , @required this.destinations, @required this.addDestination,@required this.addDestLocation,@required this.setRouting,@required this.stopRoute,@required this.desX,@required this.desY,@required this.desFloor}) : super(key: key);

  @override
  _ICTBldng createState() => _ICTBldng(task,destinations,addDestination,addDestLocation,setRouting,this.stopRoute);

}

 

class _ICTBldng extends State<ICTBldng> {

  List<Building> bldg = [];
  List<Room> rl = [];
  List<Instructor> ins = [];
  List searchList = [];

  List<ListTile> task;

  List<LatLng> destinations;

  Function addDestination,addDestLocation,setRouting,stopRoute;

  _ICTBldng(this.task,this.destinations,this.addDestination,this.addDestLocation,this.setRouting,this.stopRoute);
  
  double x = 0.0;
  double y = 0.0;
  double sourcX = 0.0;
  double sourcY = 0.0;


  List<Offset> ictBlngPath = [
    Offset(90,245.0), //9-x02 right
    Offset(80,200.0), //9-x01 left
    Offset(80,180.0),//9-x02 right
    Offset(130,170.0),//9-x02 right
   ];

    List<Offset> scndfloor = [
    Offset(135,275.0),//9-x02 right
    Offset(90,300.0),//9-x02 right
    Offset(90,260.0), //9-x02 left
    Offset(90,245.0), //9-x02 right
    Offset(80,200.0), //9-x01 left
    Offset(80,180.0),//9-x02 right
    Offset(130,170.0),//9-x02 right
    
   ];


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
  String desFloor = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.desFloor == "1"){
      desFloor = "G";
    }else{
      desFloor = widget.desFloor;
    }
    print(widget.desFloor);
    print(widget.desFloor);
    onStartup();
    setState(() {
      sourcX = ictBlngPath[0].dx;
      sourcY = ictBlngPath[0].dy;
      floor = groundFloor;
      floorLabel = "G";
    });
    changeLoc();
    
     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ictMapBuilder(context),
        menuDialog(addDestination,addDestLocation,setRouting),
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
                // Navigator.pop(context);
                ictBlngPath.removeAt(0);
                 
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
                CustomWidgets(context).questDialog(task,destinations,stopRoute);
              },
            ),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            margin: EdgeInsets.only(right: 10, top: 10),
          ),
           
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
                      // CustomPaint(
                      //   painter: DrawLocation(Offset(x, y),Colors.black),
                      // ),

                  
                    CustomPaint(
                        painter: floorLabel == desFloor ? DrawLocation(Offset(widget.desX,widget.desY),Colors.red):null,
                      ),


                    //  CustomPaint(painter: floorLabel == "G" ? DrawLine(ictBlngPath) : DrawLine(scndfloor),),
                    //   floorLabel == "G" ? CustomPaint(
                    //     painter: DrawLocation(Offset(sourcX,sourcY),Colors.blue),
                    //   ) : CustomPaint(
                    //     painter: DrawLocation(Offset(scndfloor[0].dx,scndfloor[0].dy),Colors.red),
                    //   )
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

  Widget menuDialog(Function a,b,c) {
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
                            context: context, delegate: CustomSearchDelegate(1,searchList,searchList,a,b,c,null));
                      },
                      child: Container(
                        child: Text('Search Here'),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                     
                    },
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
  changeLoc() async{
     for(int z = 0 ; z < 2 ; z++){
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        ictBlngPath.removeAt(0);
        sourcX = ictBlngPath[0].dx;
        sourcY = ictBlngPath[0].dy;
      });
      
    }
    gobackLoc();
  }
  gobackLoc() async{
    List<Offset> back = [Offset(80,200.0),Offset(90,245.0)];
     for(int z = 0 ; z < 2 ; z++){
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        ictBlngPath.insert(0,  back[z]);
       
        sourcX = ictBlngPath[0].dx;
        sourcY = ictBlngPath[0].dy;
      });
    }
  }
  void onStartup() async {
    print(widget.desX);
    print(widget.desY);
    var _fetchBuilding = await getBuildings();
    var _fetchRoom = await getRooms();
    var _fetchinstructor = await getInstructor();
    setState(() {
      bldg = _fetchBuilding;
      rl = _fetchRoom;
      ins = _fetchinstructor;
      for(int x = 0 ; x < bldg.length; x++){
        searchList.add(bldg[x]);
      }
      for(int x = 0 ; x < rl.length; x++){
        searchList.add(rl[x]);
      }
      for(int x = 0 ; x < ins.length; x++){
        searchList.add(ins[x]);
      }
      searchList.shuffle();
    });
    print("DONE");
  }

}
