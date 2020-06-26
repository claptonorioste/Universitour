import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universitour/models/course.dart';
import 'package:universitour/models/purpose.dart';

var purpose = List<Purpose>();
var course  = List<Course>();

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