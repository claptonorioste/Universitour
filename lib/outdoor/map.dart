/*
  @author Orioste, Christian Clapton Edison G.
  BS - IT
  USTP Final Thesis Implementation 2020
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:universitour/indoor/ict-building.dart';
import 'package:universitour/models/building.dart';
import 'package:universitour/models/course.dart';
import 'package:universitour/models/instructor.dart';
import 'package:universitour/models/purpose.dart';
import 'package:universitour/models/room.dart';
import 'package:universitour/myFunctions/defaultOptions.dart';
import 'package:universitour/myFunctions/otherFunctions.dart';
import 'package:universitour/myFunctions/routeRestAPI.dart';
import 'package:universitour/outdoor/customWidgets.dart';
import 'package:universitour/restAPI/onlineDB.dart';

class MapUI extends StatefulWidget {
  @override
  MapUIState createState() => MapUIState();
}

class MapUIState extends State<MapUI> {
  //var declaration

  List<Building> bldg = [];

  List<Room> rl = [];

  List<Instructor> ins = [];

  List searchList = [];

  double desX = 99999, desY = 99999;

  bool findingRoute = false;

  ProgressDialog pr;

  List<ListTile> task = [];

  List<LatLng> pointsList = [];

  List<Symbol> markers = [];

  List<Symbol> tempMarkers = [];

  CameraPosition _position;

  MapboxMapController mapController;

  Line _routeLine, _borderLine;

  String desFloor = "hello";

  Symbol _sourceSymbol,
      _destinationSymbol,
      _civilTech,
      _foodTech,
      _studentCenter,
      _comArts,
      _collegePolicy,
      _lrc,
      _printingPress,
      _scholarship,
      _drawingBldng,
      _cafeteria,
      _gym,
      _gymLobby,
      _ictBldng,
      _adminBldng,
      _elecTech,
      _automotive,
      _guidance,
      _sped,
      _itb,
      _tcl,
      _ceab,
      _alumni,
      _scienceCentre,
      _scicom,
      _chem,
      _engrCom1,
      _engrCom2,
      _lastSymbolTap = null;

  Location location = Location();

  bool isMoving = false,
      _viewInfo = false,
      _isRouting = false,
      _isDesInBounds = false,
      _isIndoor = false,
      _viewBldng = false,
      _symbolTap = false;

  String _totalDistance = "0.0",
      _routeStatus = "None",
      bldngName = "",
      bldngInfo = "",
      imageName = "";

  LatLng destination = LatLng(0.0, 0.0);

  List<LatLng> destinations = [];



  final CameraPosition _kInitialPosition;

  final CameraTargetBounds _cameraTargetBounds;

  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;

  double size = 0.7;

  Offset iconOffset = Offset(0.0, -16.0);
  //end var declaration

  MapUIState._(this._kInitialPosition, this._position, this._cameraTargetBounds);

  @override
  void initState() {
    super.initState();
    initiateDefaultSymbol();
    location.onLocationChanged().listen((LocationData currentLocation) async {
      if (_isRouting) {
        String status = "";
        var res = await getRoutes(
            currentLocation.longitude.toString(),
            currentLocation.latitude.toString(),
            destinations[0].longitude.toString(),
            destinations[0].latitude.toString());

        status = res;

        if (status == "done") {
          _updateRoute(currentLocation);
          mapController.moveCamera(CameraUpdate.newLatLng(
              LatLng(destinations[0].latitude,  destinations[0].longitude)));
          setState(() {
            _totalDistance = getDistance().toString();
            double.parse(_totalDistance) < 100.0
                ? _isIndoor = true
                : _isIndoor = false;
            _routeStatus = "Route fetch";
            pr.hide();
          });
        }
      }
    });
    onStartup();
  }

  double getDistance() {
    double totalDistance = 0;
    for (var i = 0; i < pointsList.length - 1; i++) {
      totalDistance += calculateDistance(
          pointsList[i].latitude,
          pointsList[i].longitude,
          pointsList[i + 1].latitude,
          pointsList[i + 1].longitude);
    }
    return totalDistance;
  }

  Future<String> getRoutes(String sourceLat, String sourceLng,
      String destinationLat, destinationLng) async {
    var getPoints = await getUniversityRoute(
        sourceLat, sourceLng, destinationLat, destinationLng);
    pointsList = getPoints.cast<LatLng>();
    pointsList.add(
        LatLng(double.parse(destinationLng), double.parse(destinationLat)));
    return "done";
  }

  @override
  void dispose() {
    if (mapController != null) {
      mapController.removeListener(_onMapChanged);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     pr = ProgressDialog(context);
     pr.style(
      message: "Finding Best Route ...",
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: SpinKitWave(
        color: Color(0xff086375),
        size: 30.0,
      ),
      elevation: 5.0,
      insetAnimCurve: Curves.bounceIn,
      progressTextStyle: TextStyle(
          color: Color(0xff086375),
          fontSize: 13.0,
          fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Color(0xff086375),
          fontSize: 19.0,
          fontWeight: FontWeight.w600),
    );
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildMapBox(context),
          CustomWidgets(context).menuDialog(searchList,addDestination,addDestLocation,setRouting),
          _viewBldng ? bldngInfoDialog(bldngName, bldngInfo) : Container(),
          CustomWidgets(context).sideMenu(mapController,location,_sourceSymbol,_isRouting,task,destinations,stopRoute,addDestination,addDestLocation,setRouting,bldngName,desX,desY)
        ],
      ),
    );
  }

  // Widget infoDialog() {
  //   return Align(
  //     alignment: FractionalOffset.bottomCenter,
  //     child: Container(
  //       child: Column(
  //         children: <Widget>[
  //           Text("Destination: Latitude = " +
  //               destination.latitude.toStringAsFixed(5) +
  //               " Longitude = " +
  //               destination.longitude.toStringAsFixed(5)),
  //           Text("Destination Distance: " + _totalDistance + " meters"),
  //           Text("My location w/in map?: " + _isDesInBounds.toString()),
  //           Text("My location w/in building?: " + _isIndoor.toString()),
  //           Text("Status: " + _routeStatus,
  //               style: TextStyle(
  //                   color: _routeStatus == "Fetching route"
  //                       ? Colors.red
  //                       : _routeStatus == "Route fetch" ? Colors.green : null)),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               OutlineButton(
  //                 child: Text("Start Route"),
  //                 onPressed: () {
  //                   setState(() {
  //                     destination = LatLng(8.4859, 124.6566);
  //                     _routeStatus = "Fetching route";
  //                     _isRouting = true;
  //                   });
  //                 },
  //                 color: Colors.blue,
  //               ),
  //               OutlineButton(
  //                 child: Text("Stop Route"),
  //                 onPressed: () {
  //                   _stopRoute();
  //                   _removeRoute();
  //                 },
  //                 color: Colors.blue,
  //               ),
  //               OutlineButton(
  //                 child: Text("Goto Indoor"),
  //                 onPressed: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => ICTBldng()),
  //                   );
  //                 },
  //                 color: Colors.blue,
  //               )
  //             ],
  //           )
  //         ],
  //       ),
  //       decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.all(Radius.circular(10))),
  //       padding: EdgeInsets.all(5.0),
  //       margin: EdgeInsets.only(bottom: 10.0),
  //       height: 160,
  //       width: 360,
  //     ),
  //   );
  // }
  
  void addDestination(String bldngName,String sub){
    task.add(ListTile(
      title: Text("To "+bldngName,style: TextStyle(fontSize: 13),), 
      subtitle: Text(sub),
    ),);
  }
  void addDestLocation(LatLng dest,double x,double y,String des){
    destinations.add(dest);
    setState(() {
      desX = x;
      desY = y;
      desFloor = des;
    });

  }
  void setRouting(){
    setState(() {
      pr.show();
      _isRouting = true;
    });
  }
  void stopRoute(){
    setState(() {
      desX = 99999;
      desY = 99999;
      desFloor = "";
      _isRouting = false;
      _stopRoute();
      _removeRoute();
    });
  }

  Widget bldngInfoDialog(String bldngName, String bldngInfo) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Image.asset(
                  imageName,
                  fit: BoxFit.fill,
                ),
              ),
              height: 130,
              margin: EdgeInsets.only(bottom: 10.0),
            ),
            Text(
              bldngName,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              bldngInfo,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                    child: FlatButton(
                      color: Colors.blue,
                      onPressed: () async {
                        pr.show();
                        var myLocation = await location.getLocation();
                        _isDesInBounds = contains(
                            LatLng(myLocation.latitude, myLocation.longitude));
                        if (true){
                        
                          destinations.add(destination);
                          print(destinations);
                          _isRouting = true;
                          setState(() {
                           addDestination(bldngName," ");
                          });
                        }
                        else
                          CustomWidgets(context).errDialog();
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.directions,
                            color: Colors.white,
                          ),
                          Text(
                            ' Directions',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: OutlineButton(
                      onPressed: () {
                        if(bldngName == "Bldg. 9 - ICT"){
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ICTBldng(task: task,destinations: destinations,addDestination: addDestination,addDestLocation: addDestLocation,setRouting:setRouting,stopRoute: stopRoute,desX: desX, desY:desY,desFloor: desFloor,)),
                        );
                        }else{
                          print("No indoor data");
                        }
                        
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.navigation,
                            color: Colors.blue,
                          ),
                          Text(
                            ' View Indoor',
                          )
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.only(bottom: 10.0),
        height: 260,
        width: 360,
      ),
    );
  }

  MapboxMap _buildMapBox(BuildContext context) {
    return MapboxMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: this._kInitialPosition,
        trackCameraPosition: true,
        compassEnabled: defaultOption(MapOptions.compassEnabled),
        compassViewMargins: Point(40, 320),
        onStyleLoadedCallback: _onStyleLoadedCallback,
        cameraTargetBounds: _cameraTargetBounds,
        minMaxZoomPreference: defaultOption(MapOptions.minMaxZoomPreference),
        styleString: defaultOption(MapOptions.styleString),
        rotateGesturesEnabled: defaultOption(MapOptions.rotateGesturesEnabled),
        scrollGesturesEnabled: defaultOption(MapOptions.scrollGesturesEnabled),
        tiltGesturesEnabled: defaultOption(MapOptions.tiltGesturesEnabled),
        zoomGesturesEnabled: defaultOption(MapOptions.zoomGesturesEnabled),
        onMapClick: (point, coordinates) {
          if (_symbolTap) {
            _symbolTap = false;
          } else {
            setState(() {
              _viewBldng = false;
            });
            if (!_isRouting && _lastSymbolTap != null) {
              mapController.updateSymbol(
                  _lastSymbolTap,
                  SymbolOptions(
                    iconImage: "assets/symbols/info-pin.png",
                  ));
              _lastSymbolTap = null;
              destination = LatLng(0.0, 0.0);
            }
          }
        },
        //  myLocationEnabled: true,
        // myLocationTrackingMode: _myLocationTrackingMode,
        onCameraTrackingDismissed: () {
          this.setState(() {
            _myLocationTrackingMode = MyLocationTrackingMode.None;
          });
        });
  }

  void onMapCreated(MapboxMapController controller) {
    mapController = controller;

    mapController.addListener(_onMapChanged);

    mapController.onSymbolTapped.add(_onSymbolTapped);
  }

  void _onStyleLoadedCallback() {
    
      _displayRoute();

  }

  void _extractMapInfo() {
    _position = mapController.cameraPosition;

    isMoving = mapController.isCameraMoving;
  }

  void _stopRoute() {
    setState(() {
      _isRouting = false;
      destination = LatLng(0.0, 0.0);
      _totalDistance = "0.0";
      _routeStatus = "None";
    });
  }

  void _displayRoute() async {
    var destinationSymbol = await mapController.addSymbol(
      SymbolOptions(
        geometry: LatLng(0.0, -10.0),
        iconSize: size,
        iconOffset: iconOffset,
        iconImage: "assets/symbols/dest-pin.png",
      ),
    );

    var sourceSymbol = await mapController.addSymbol(
      SymbolOptions(
        geometry: LatLng(0.0, 0.0),
        iconImage: "assets/symbols/walking-pin.png",
        iconSize: 3.0,
      ),
    );

    setSymbolOnload(LatLng(8.48661, 124.65494), iconOffset, size);
    setSymbolOnload(LatLng(8.48636, 124.65540), iconOffset, size);
    setSymbolOnload(LatLng(8.48610, 124.65518), iconOffset, size);
    setSymbolOnload(LatLng(8.48685, 124.65531), iconOffset, size);
    setSymbolOnload(LatLng(8.48578, 124.65531), iconOffset, size);
    setSymbolOnload(LatLng(8.48665, 124.65580), iconOffset, size);
    setSymbolOnload(LatLng(8.48669, 124.65612), iconOffset, size);
    setSymbolOnload(LatLng(8.48634, 124.65616), iconOffset, size);
    setSymbolOnload(LatLng(8.48656, 124.65667), iconOffset, size);
    setSymbolOnload(LatLng(8.48591, 124.65699), iconOffset, size);
    setSymbolOnload(LatLng(8.48585, 124.65671), iconOffset, size);
    setSymbolOnload(LatLng(8.48610, 124.65650), iconOffset, size);
    setSymbolOnload(LatLng(8.48624, 124.65744), iconOffset, size);
    setSymbolOnload(LatLng(8.48603, 124.65726), iconOffset, size);
    setSymbolOnload(LatLng(8.48626, 124.65787), iconOffset, size);
    setSymbolOnload(LatLng(8.48602, 124.65789), iconOffset, size);
    setSymbolOnload(LatLng(8.48631, 124.65830), iconOffset, size);
    setSymbolOnload(LatLng(8.48587, 124.65833), iconOffset, size);
    setSymbolOnload(LatLng(8.48606, 124.65850), iconOffset, size);
    setSymbolOnload(LatLng(8.48622, 124.65852), iconOffset, size);
    setSymbolOnload(LatLng(8.48573, 124.65763), iconOffset, size);
    setSymbolOnload(LatLng(8.48561, 124.65603), iconOffset, size);
    setSymbolOnload(LatLng(8.48580, 124.65572), iconOffset, size);
    setSymbolOnload(LatLng(8.48504, 124.65723), iconOffset, size);
    setSymbolOnload(LatLng(8.48538, 124.65722), iconOffset, size);
    setSymbolOnload(LatLng(8.48480, 124.65712), iconOffset, size);
    setSymbolOnload(LatLng(8.48486, 124.65679), iconOffset, size);

    var borderLine = await mapController.addLine(LineOptions(
        geometry: [LatLng(0.0, 0.0)], lineColor: "black", lineWidth: 9.0));

    var routeLine = await mapController.addLine(LineOptions(
        geometry: [LatLng(0.0, 0.0)], lineColor: "#629749", lineWidth: 7.0));

    _routeLine = routeLine;

    _borderLine = borderLine;

    _sourceSymbol = sourceSymbol;

    _destinationSymbol = destinationSymbol;

    for (int symbolIndex = 0; symbolIndex < markers.length; symbolIndex++)
      markers[symbolIndex] = tempMarkers[symbolIndex];
  }

  void _updateRoute(LocationData currentLocation) {
    try {
      mapController.updateLine(
          _routeLine,
          LineOptions(
            geometry: pointsList,
          ));

      mapController.updateLine(
          _borderLine,
          LineOptions(
            geometry: pointsList,
          ));

      mapController.updateSymbol(
          _sourceSymbol, SymbolOptions(geometry: pointsList[0]));

      mapController.updateSymbol(
          _destinationSymbol, SymbolOptions(geometry: destination));
    } catch (e) {
      print(e);
    }
  }

  _removeRoute() {
    mapController.updateLine(
        _routeLine, LineOptions(geometry: [LatLng(0.0, 0.0)]));

    mapController.updateLine(
        _borderLine, LineOptions(geometry: [LatLng(0.0, 0.0)]));

    mapController.updateSymbol(
        _sourceSymbol, SymbolOptions(geometry: LatLng(0.0, 0.0)));

    mapController.updateSymbol(
        _destinationSymbol, SymbolOptions(geometry: LatLng(0.0, 0.0)));
  }

  void _onSymbolTapped(Symbol symbol) {
    _symbolTap = true;
    if (_lastSymbolTap != null) {
      mapController.updateSymbol(
          _lastSymbolTap,
          SymbolOptions(
            iconImage: "assets/symbols/info-pin.png",
          ));
    }
    setState(() {
      _viewBldng = true;
    });
    switch (symbol.id) {
      case "0":
        print("source");
        break;
      case "1":
        print("destination");
        break;

      case "2":
        setBuildingInfo("Bldg. 37 - Civil Technology Building", "Civil Technology Building", LatLng(8.48661, 124.65494000000001), 'assets/buildings/samp.png',symbol);
        break;
      case "3":
        setBuildingInfo("Bldg. 24 - Food Technology Building", "Food Technology Building", LatLng(8.48636, 124.65539999999999), 'assets/buildings/samp.png',symbol);
        break;
      case "4":
        setBuildingInfo("Bldg. 36 - Student Center", "Student Center", LatLng(8.4861, 124.65517999999997), 'assets/buildings/samp.png',symbol);
        break;
      case "5":
        setBuildingInfo("Communication Arts Building", "Communication Arts Building", LatLng(8.48685, 124.65530999999999), 'assets/buildings/samp.png',symbol);
        break;
      case "6":
        setBuildingInfo("Bldg. 35 - Education Building", "Education Building", LatLng(8.48578, 124.65530999999999), 'assets/buildings/samp.png',symbol);
        break;
      case "7":
        setBuildingInfo("Bldg. 23 - LRC", "Learning Resource Center",LatLng(8.48665, 124.65580), 'assets/buildings/lrc.jpg',symbol);
        break;
      case "8":
        setBuildingInfo("Printing Press", "Printing Press",LatLng(8.48669, 124.65611999999999), 'assets/buildings/samp.png',symbol);
        break;
      case "9":
        setBuildingInfo("Bldg. 25 - Food Innovation Centr","Food Innovation Centr", LatLng(8.48634, 124.65616), 'assets/buildings/food.jpg',symbol);
        break;
      case "10":
        setBuildingInfo("Bldg.13 - Drawing Building","Drawing Building", LatLng(8.48656, 124.65667000000002), 'assets/buildings/drawing.jpg',symbol);
        break;
      case "11":
        setBuildingInfo("Cafeteria","Cafeteria", LatLng(8.48591, 124.65699000000001), 'assets/buildings/cafet.jpg',symbol);
        break;
      case "12":
        setBuildingInfo("Bldg. 16 - Gym","USTP Gymnasium", LatLng(8.48585, 124.65671), 'assets/buildings/gym.jpg',symbol);
        break;
      case "13":
        setBuildingInfo("Gym Lobby","USTP Gymnasium Lobby", LatLng(8.4861, 124.6565), 'assets/buildings/gym.jpg',symbol);
        break;
      case "14":
        setBuildingInfo("Bldg. 9 - ICT","Information and Communication Technology Building", LatLng(8.48624, 124.65744), 'assets/buildings/ict.jpg',symbol);
        break;
      case "15":
        setBuildingInfo("Admin Building","Administration Building", LatLng(8.48603, 124.65726000000001), 'assets/buildings/ict.jpg',symbol);
        break;
       case "16":
        setBuildingInfo("Bldg. 7 - ETM","Electrical Technology Building", LatLng(8.48626, 124.65787), 'assets/buildings/etm.jpg',symbol);
        break;
      case "17":
        setBuildingInfo("Bldg. 6 - ATM","Automated Technology Building", LatLng(8.48602, 124.65789000000001), 'assets/buildings/atm.jpg',symbol);
        break;
      case "18":
        setBuildingInfo("Bldg. 2 - Guidance","Guidance and Testing Center", LatLng(8.48631, 124.6583), 'assets/buildings/guide.jpg',symbol);
        break;
      case "19":
        setBuildingInfo("SPED Center","SPED Center", LatLng(8.48587, 124.65832999999998), 'assets/buildings/sped.jpg',symbol);
        break;
      case "20":
        setBuildingInfo("Bldg. 3 - ITB","Integrated Technology Building", LatLng(8.48606, 124.6585), 'assets/buildings/itb.jpg',symbol);
        break;
      case "21":
        setBuildingInfo("Bldg. 1 - Arts and Culture","Arts and Culture", LatLng(8.48622, 124.65852000000001), 'assets/buildings/samp.png',symbol);
        break;
      case "22":
        setBuildingInfo("Bldg. 5 - Old CEA Building","Old College of Engineering and Architecture Bldg.", LatLng(8.48573, 124.65762999999998), 'assets/buildings/old_cea.jpg',symbol);
        break;
      case "23":
        setBuildingInfo("Bldg. 41 - SciCom","Science Complex", LatLng(8.48561, 124.65602999999999), 'assets/buildings/scicom.jpg',symbol);
        break;
      case "24":
        setBuildingInfo("Bldg. 28 - Science Building","Science Building", LatLng(8.4858, 124.65571999999997), 'assets/buildings/samp.png',symbol);
        break;
      case "25":
        setBuildingInfo("Bldg. 19 - Science Centrum","Science Centrum", LatLng(8.48504, 124.65723000000003), 'assets/buildings/samp.png',symbol);
        break;
      case "26":
        setBuildingInfo("Bldg. 18 - Alumni Building","Alumni Building", LatLng(8.48538, 124.65722), 'assets/buildings/samp.png',symbol);
        break;
      case "27":
        setBuildingInfo("Bldg. 42 - EngCom (A)","Engineering Complex (A)", LatLng(8.4848, 124.65712000000002), 'assets/buildings/engcom.jpg',symbol);
        break;
      case "28":
        setBuildingInfo("Bldg. 43 - EngCom (B)","Engineering Complex (B)", LatLng(8.48486, 124.65679), 'assets/buildings/engcom.jpg',symbol);
        break;
      default:
        print(symbol.id);
        print(symbol.options.geometry);
        break;
    }
    
  }

  static CameraPosition _getCameraPosition() {
    return CameraPosition(
      target: defaultOption(MapOptions.centerMap),
      zoom: defaultOption(MapOptions.defaultZoom),
    );
  }

  factory MapUIState() {
    CameraPosition cameraPosition = _getCameraPosition();

    return MapUIState._(cameraPosition, cameraPosition,
        CameraTargetBounds(defaultOption(MapOptions.universityBounds)));
  }
  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  setBuildingInfo(String _bldgName,String _bldngInfo,LatLng _destination,String _imageLocation,Symbol symbolTap){
    setState(() {
      bldngName = _bldgName;
      bldngInfo = _bldngInfo;
      destination = _destination;
      imageName = _imageLocation;
      
    });
    _lastSymbolTap = symbolTap;
    
    mapController.updateSymbol(
        _lastSymbolTap,
        SymbolOptions(
          iconImage: "assets/symbols/dest-pin.png",
        ));
  }

  setSymbolOnload(LatLng markerLocation, Offset iconOffset, double size) async {
    Symbol _marker;

    var marker = await mapController.addSymbol(
      SymbolOptions(
        iconOffset: iconOffset,
        geometry: markerLocation,
        iconImage: "assets/symbols/info-pin.png",
        iconSize: size,
      ),
    );

    _marker = marker;

    tempMarkers.add(_marker);
  }

  initiateDefaultSymbol(){
    markers = [
    _civilTech,
    _foodTech,
    _studentCenter,
    _comArts,
    _collegePolicy,
    _lrc,
    _printingPress,
    _scholarship,
    _drawingBldng,
    _cafeteria,
    _gym,
    _gymLobby,
    _ictBldng,
    _adminBldng,
    _elecTech,
    _automotive,
    _guidance,
    _sped,
    _itb,
    _tcl,
    _ceab,
    _alumni,
    _scienceCentre,
    _scicom,
    _chem,
    _engrCom1,
    _engrCom2
    ];
  }

  void onStartup() async {
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
