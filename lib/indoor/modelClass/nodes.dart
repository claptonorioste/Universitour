import 'package:flutter/widgets.dart';

class LocationNodes {
  
  final String name;

  final LocationNodes head,tail;

  final Offset offset;

  const LocationNodes(this.name, this.head, this.tail, this.offset);
}