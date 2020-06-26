/*
  @author Orioste, Christian Clapton Edison G.
  BS - IT
  USTP Final Thesis Implementation 2020
 */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

Future<List<LatLng>> getUniversityRoute(String sourceLat,String sourceLng,String destinationLat,destinationLng) async {
  List<LatLng> points = [];
  final String url ='https://api.mapbox.com/directions/v5/mapbox/walking/'+sourceLat+','+sourceLng+';'+destinationLat+','+destinationLng+'?overview=full&geometries=geojson&access_token=pk.eyJ1IjoiY2xhcHRvbjIzIiwiYSI6ImNrNXM4dmRrYjBsbG4zbXJ0eXlrdWpsMG0ifQ.x1_jfcz_EJmRJC_soX_isA';

  try{
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
      if (statusCode == 200) {
        final parse = json.decode(response.body);
        final wayPoints = parse['routes'][0]['geometry']['coordinates'] as List;
        wayPoints.forEach((element) {
          points.add(LatLng(element[1],element[0]));
        });
      }else{
        print(response.body);
      }
  }catch(e){
    print(e);
  }
  return points;
}
