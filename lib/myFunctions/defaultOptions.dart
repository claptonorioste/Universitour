/*
  @author Orioste, Christian Clapton Edison G.
  BS - IT
  USTP Final Thesis Implementation 2020
 */

import 'package:mapbox_gl/mapbox_gl.dart';

LatLngBounds mapBounds = LatLngBounds(
            southwest: LatLng(8.484429648156947, 124.65430910011742),
            northeast: LatLng(8.487486755722443, 124.65894100409298));


enum MapOptions{
     centerMap,
     compassEnabled,
     rotateGesturesEnabled,
     scrollGesturesEnabled,
     tiltGesturesEnabled,
     zoomGesturesEnabled,
     myLocationEnabled,
     defaultZoom,
     minMaxZoomPreference,
     styleString,
     universityBounds
   }

   defaultOption(MapOptions mapOptions){
     switch(mapOptions){
       case MapOptions.centerMap:
          return LatLng(8.4859, 124.6566);
        case MapOptions.compassEnabled:
          return true;
        case MapOptions.rotateGesturesEnabled:
          return true;
        case MapOptions.scrollGesturesEnabled:
          return true;
        case MapOptions.tiltGesturesEnabled:
          return true;
        case MapOptions.zoomGesturesEnabled:
          return true;
        case MapOptions.myLocationEnabled:
          return true;
        case MapOptions.defaultZoom:
          return 17.5;
        case MapOptions.minMaxZoomPreference:
          return MinMaxZoomPreference(17.5, 25.0);
        case MapOptions.styleString:
          return "mapbox://styles/mapbox/streets-v11";
        case MapOptions.universityBounds:
          return mapBounds;
     }
   }



  bool contains(LatLng point) {
   
    var sw2 = point;

    var ne2 = point;

    return containsBounds(LatLngBounds(northeast: ne2,southwest: sw2));
  }

  bool containsBounds(LatLngBounds bounds) {

    var sw2 = bounds.southwest;

    var ne2 = bounds.northeast;

    return (sw2.latitude >= mapBounds.southwest.latitude) &&
           (ne2.latitude <=  mapBounds.northeast.latitude) &&
           (sw2.longitude >= mapBounds.southwest.longitude) &&
           (ne2.longitude <= mapBounds.northeast.longitude);
  }