import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universitour/models/building.dart';
import 'package:universitour/models/course.dart';
import 'package:universitour/models/enrollment.dart';
import 'package:universitour/models/instructor.dart';
import 'package:universitour/models/purpose.dart';
import 'package:universitour/models/room.dart';

var purpose = List<Purpose>();
var course  = List<Course>();
var building = List<Building>();
var room = List<Room>();
var instructor = List<Instructor>();
var enrollment = List<Enrollment>();

Future<List<Purpose>> getPurpose() async {
  final String url =
      'https://universitour.000webhostapp.com/UniversitourAPI/PurposeSELECT.php';
  try {
    http.Response response = await http.post(url);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      try {
        Iterable list = json.decode(response.body);
        purpose = list.map((model) => Purpose.fromDb(model)).toList();
        return purpose;
      } catch (e) {
        print("Empty database");
      }
    }
  } on http.ClientException catch (e) {print(e);}
  return [];
}
Future<List<Course>> getCourse() async {
  final String url =
      'https://universitour.000webhostapp.com/UniversitourAPI/CourseSelect.php';
  try {
    http.Response response = await http.post(url);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      try {
        Iterable list = json.decode(response.body);
        course = list.map((model) => Course.fromDb(model)).toList();
        return course;
      } catch (e) {
        print("Empty database");
      }
    }
  } on http.ClientException catch (e) {print(e);}
  return [];
}
Future<List<Building>> getBuildings() async {
  final String url =
      'https://universitour.000webhostapp.com/UniversitourAPI/BuildingSelect.php';
  try {
    http.Response response = await http.post(url);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      try {
        Iterable list = json.decode(response.body);
        building = list.map((model) => Building.fromDb(model)).toList();
        return building;
      } catch (e) {
        print("Empty database");
      }
    }
  } on http.ClientException catch (e) {print(e);}
  return [];
}
Future<List<Room>> getRooms() async {
  final String url =
      'https://universitour.000webhostapp.com/UniversitourAPI/RoomSelect.php';
  try {
    http.Response response = await http.post(url);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      try {
        Iterable list = json.decode(response.body);
        room = list.map((model) => Room.fromDb(model)).toList();
        return room;
      } catch (e) {
        print(e);
      }
    }
  } on http.ClientException catch (e) {print(e);}
  return [];
}
Future<List<Instructor>> getInstructor() async {
  final String url =
      'https://universitour.000webhostapp.com/UniversitourAPI/InstructorSelect.php';
  try {
    http.Response response = await http.post(url);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      try {
        Iterable list = json.decode(response.body);
        instructor = list.map((model) => Instructor.fromDb(model)).toList();
        return instructor;
      } catch (e) {
        print(e);
      }
    }
  } on http.ClientException catch (e) {print(e);}
  return [];
}

Future<List<Enrollment>> getEnrollment() async {
  final String url =
      'https://universitour.000webhostapp.com/UniversitourAPI/EnrollmentSelect.php';
  try {
    http.Response response = await http.post(url);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      try {
        Iterable list = json.decode(response.body);
        enrollment = list.map((model) => Enrollment.fromDb(model)).toList();
        return enrollment;
      } catch (e) {
        print(e);
      }
    }
  } on http.ClientException catch (e) {print(e);}
  return [];
}