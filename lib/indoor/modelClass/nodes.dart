import 'package:flutter/widgets.dart';

class LocationNodes {
  
  final String name, floor; 

  final LocationNodes head, tail;

  final Offset offset;

  const LocationNodes(this.name,this.floor, this.head, this.tail, this.offset);
}