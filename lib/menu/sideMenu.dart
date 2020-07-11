import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:universitour/models/building.dart';
import 'package:universitour/models/course.dart';
import 'package:universitour/models/enrollment.dart';
import 'package:universitour/models/instructor.dart';
import 'package:universitour/models/purpose.dart';
import 'package:universitour/models/room.dart';
import 'package:universitour/myFunctions/searchDelegate.dart';
import 'package:universitour/outdoor/map.dart';
import 'package:universitour/restAPI/onlineDB.dart';

class SideMenu extends StatefulWidget {
  final Function addDestination, addDestLocation, setRouting;
  SideMenu(this.addDestination, this.addDestLocation, this.setRouting);
  @override
  _SideMenu createState() => _SideMenu();
}

class _SideMenu extends State<SideMenu> {
  Purpose selectedPurpose;
  Course selectedCourse;

  List<Purpose> purpose = [];
  List<Course> course = [];
  List<Building> building = [];
  List<Building> suggestionbuilding = [];
  List<Room> roomList = [];
  List<Room> suggestedRoom = [];
  List<Instructor> instructor = [];
  List<Instructor> suggestedInstructor = [];
  List<Enrollment> enrollmentList = [];
  List<Enrollment> todoEnrollment = [];

  bool isEnrollment = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //
    onStartup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: isEnrollment ? Text("Enrollment") : Text("Select a Purpose"),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : isEnrollment ? enrollment() : selection());
  }

  Widget enrollment() {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Container(child: Text("Select Course")),
          Container(
            padding: EdgeInsets.all(5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<Course>(
                    hint: course.length != 0
                        ? Text(course[0].course_name)
                        : Text("Please wait..."),
                    value: selectedCourse,
                    onChanged: (Course newValue) {
                      setState(() {
                        selectedCourse = newValue;
                      });
                    },
                    items: course.map((Course course) {
                      return DropdownMenuItem<Course>(
                        value: course,
                        child: Text(
                          course.course_name,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                )),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.all(5),
          ),
          Container(
            height: 50,
            width: 150,
            child: FlatButton(
              color: Colors.blue,
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                  for (int x = 0; x < enrollmentList.length; x++) {
                    if (enrollmentList[x].course_id ==
                        selectedCourse.course_id) {
                      todoEnrollment.add(enrollmentList[x]);
                    }
                  }
                  for (int x = 0; x < todoEnrollment.length; x++) {
                     double desX = 0.0 , desY = 0.0;
                     String floor = "";
                     String room = todoEnrollment[x].room_num.toString() == "null"? "0": todoEnrollment[x].room_num.toString();
                     if(todoEnrollment[x].room_x != null && todoEnrollment[x].room_y != null){
                       setState(() {
                         desX = double.parse(todoEnrollment[x].room_x);
                         desY = double.parse(todoEnrollment[x].room_y);
                         floor = todoEnrollment[x].floor;
                       });
                     }
                     widget.addDestLocation(LatLng(todoEnrollment[x].latitude, todoEnrollment[x].longitude),desX,desY,floor);
                     widget.addDestination(todoEnrollment[x].blngName,todoEnrollment[x].description +" "+todoEnrollment[x].bldgNumber.toString()+"-"+ room);
                  }
                  widget.setRouting();
                 

                  
                 
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ' Navigate',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
          ),
          Container(
            height: 50,
            width: 150,
            child: FlatButton(
              color: Colors.blue,
              onPressed: () {
                setState(() {
                  isEnrollment = false;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ' Back',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          )
        ]));
  }

  Widget selection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 50,
          width: 200,
          child: FlatButton(
            color: Colors.blue,
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                      3,
                      suggestedInstructor,
                      instructor,
                      widget.addDestination,
                      widget.addDestLocation,
                      widget.setRouting,
                      closeContext));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  ' Visit Instructor',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
        ),
        Container(
          height: 50,
          width: 200,
          child: FlatButton(
            color: Colors.blue,
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                      2,
                      suggestionbuilding,
                      building,
                      widget.addDestination,
                      widget.addDestLocation,
                      widget.setRouting,
                      closeContext));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  ' Find Building',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
        ),
        Container(
          height: 50,
          width: 200,
          child: FlatButton(
            color: Colors.blue,
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                      4,
                      suggestedRoom,
                      roomList,
                      widget.addDestination,
                      widget.addDestLocation,
                      widget.setRouting,
                      closeContext));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  ' Find Room',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
        ),
        Container(
          height: 50,
          width: 200,
          child: FlatButton(
            color: Colors.blue,
            onPressed: () {
              setState(() {
                isEnrollment = true;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  ' Enrollment',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
        ),
        Container(child: Text("Other Purpose")),
        Container(
          padding: EdgeInsets.all(5),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<Purpose>(
                  hint: purpose.length != 0
                      ? Text(purpose[0].purposeName)
                      : Text("Please wait..."),
                  value: selectedPurpose,
                  onChanged: (Purpose newValue) {
                    setState(() {
                      selectedPurpose = newValue;
                    });
                  },
                  items: purpose.map((Purpose purpose) {
                    return DropdownMenuItem<Purpose>(
                      value: purpose,
                      child: Text(
                        purpose.purposeName,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              )),
            )
          ],
        ),
        Container(
          padding: EdgeInsets.all(5),
        ),
        Container(
          height: 50,
          width: 150,
          child: FlatButton(
            color: Colors.blue,
            onPressed: () {
                 Navigator.pop(context);
                widget.addDestLocation(LatLng(selectedPurpose.latitude, selectedPurpose.longitude),0.0,0.0, " ");
                widget.addDestination(selectedPurpose.blngName,selectedPurpose.purposeName);
                widget.setRouting();
               
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.directions,
                  color: Colors.white,
                ),
                Text(
                  ' Navigate',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
      ],
    );
  }

  void onStartup() async {
    var _fetchpurpose = await getPurpose();
    var _fetchcourse = await getCourse();
    var _fetchBuilding = await getBuildings();
    var _fetchRoom = await getRooms();
    var _fetchinstructor = await getInstructor();
    var _fetchEnrollment = await getEnrollment();
    setState(() {
      enrollmentList = _fetchEnrollment;
      purpose = _fetchpurpose;
      course = _fetchcourse;
      building = _fetchBuilding;
      roomList = _fetchRoom;
      instructor = _fetchinstructor;
      suggestedInstructor = instructor;

      if (building.length > 5) {
        for (int x = 0; x < 5; x++) {
          suggestionbuilding.add(building[x]);
        }
      } else {
        suggestionbuilding = building;
      }
      if (roomList.length > 5) {
        for (int x = 0; x < 5; x++) {
          suggestedRoom.add(roomList[x]);
        }
      } else {
        suggestedRoom = roomList;
      }
      isLoading = false;
    });
    print(enrollmentList.length);
    print(enrollmentList.length);
    print(enrollmentList.length);
  }

  closeContext() {
    Navigator.pop(context);
  }
}
