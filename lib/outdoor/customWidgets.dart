import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:universitour/indoor/ict-building.dart';
import 'package:universitour/menu/sideMenu.dart';
import 'package:universitour/myFunctions/searchDelegate.dart';

class CustomWidgets {
  final BuildContext context;

  CustomWidgets(this.context);

  void errDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            height: 160,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Opps",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )),
                Divider(
                  color: Colors.black26,
                ),
                Container(
                    width: 200,
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "User must be near USTP campus!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    )),
                Divider(
                  color: Colors.black26,
                ),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 138,
                          child: RawMaterialButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            child: Text(
                              "Dismiss",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ]),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void questDialog(
      List<ListTile> task, List<LatLng> destinations, Function stopRute) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(
          builder: (context, setStates) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Container(
                height: 800,
                width: 500,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Navigating",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        color: Colors.black12,
                        child: ListView.builder(
                            itemCount: task.length,
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? Card(
                                      child: task[index],
                                      color: Colors.green[100],
                                    )
                                  : Card(
                                      child: task[index],
                                    );
                            }),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            child: Text("Arrived"),
                            onPressed: () {
                              setStates(() {
                                destinations.removeAt(0);
                                task.removeAt(0);
                                if (destinations.length == 0) {
                                  stopRute();
                                }
                              });
                            },
                          ),
                          FlatButton(
                            child: Text("Clear"),
                            onPressed: () {},
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget menuDialog(List list, Function a, Function b, Function c) {
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SideMenu(a, b, c)),
                      );
                    },
                    icon: Icon(Icons.menu),
                  ),
                  Container(
                    width: 250,
                    child: GestureDetector(
                      onTap: () {
                        showSearch(
                            context: context,
                            delegate: CustomSearchDelegate(
                                1, list, list, a, b, c, null));
                      },
                      child: Container(
                          child: Text('Search Here',
                              style: TextStyle(color: Colors.black54))),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(
                              1, list, list, a, b, c, null));
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

  Widget sideMenu(
      MapboxMapController controller,
      Location location,
      Symbol symbol,
      bool _isRouting,
      List<ListTile> task,
      List<LatLng> destinations,
      Function stopRoute,
      Function addDestination,
      Function addDestLocation,
      Function setRouting,
      String bldngName,
      double desX,
      double desY) {
    return Align(
      alignment: FractionalOffset.centerRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: FlatButton(
              child: Text("IN"),
              onPressed: () {
                if (bldngName == "Bldg. 9 - ICT") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ICTBldng(
                              task: task,
                              destinations: destinations,
                              addDestination: addDestination,
                              addDestLocation: addDestLocation,
                              setRouting: setRouting,
                              stopRoute: stopRoute,
                              desX: desX,
                              desY: desY,
                            )),
                  );
                } else {
                  print("No indoor data");
                }
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
            child: FlatButton(
              child: Icon(
                Icons.location_searching,
                size: 30.0,
                color: Colors.blue,
              ),
              onPressed: () async {
                if (_isRouting) {
                  controller.moveCamera(
                      CameraUpdate.newLatLng(symbol.options.geometry));
                } else {
                  var myLocation = await location.getLocation();
                  controller.moveCamera(CameraUpdate.newLatLng(
                      LatLng(myLocation.latitude, myLocation.longitude)));
                  controller.updateSymbol(
                      symbol,
                      SymbolOptions(
                          geometry: LatLng(
                              myLocation.latitude, myLocation.longitude)));
                }
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
            child: FlatButton(
              child: Icon(
                Icons.navigation,
                size: 30.0,
                color: Colors.green,
              ),
              onPressed: () {
                questDialog(task, destinations, stopRoute);
              },
            ),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            margin: EdgeInsets.only(right: 10),
          ),
        ],
      ),
    );
  }
}
