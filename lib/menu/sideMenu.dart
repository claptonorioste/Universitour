import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universitour/models/course.dart';
import 'package:universitour/models/purpose.dart';
import 'package:universitour/myFunctions/searchDelegate.dart';
import 'package:universitour/outdoor/map.dart';
import 'package:universitour/restAPI/onlineDB.dart';

GlobalKey<MapUIState> globalKey = GlobalKey();

class SideMenu extends StatefulWidget {
  final Function addDestination,addDestLocation,setRouting;
  SideMenu(this.addDestination,this.addDestLocation,this.setRouting);
  @override
  _SideMenu createState() => _SideMenu();
}

class _SideMenu extends State<SideMenu> {
  
  Purpose selectedPurpose;
  Course selectedCourse;
  List<Purpose> purpose = [];
  List<Course> course = [];
  bool isEnrollment = false;

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
        body: isEnrollment ? enrollment() : selection());
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
                    hint: course.length != 0 ? Text(course[0].course_name) : Text("Please wait..."),
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
                 widget.addDestLocation();
                 
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
              showSearch(context: context, delegate: CustomSearchDelegate());
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
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  ' Find Building / Room',
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
                  hint: purpose.length != 0 ? Text(purpose[0].purposeName) : Text("Please wait..."),
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
              print(selectedPurpose.id);
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
    setState(() {
      purpose = _fetchpurpose;
      course = _fetchcourse;
    });
    print(course);
  }
}
