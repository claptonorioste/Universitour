class Enrollment {
  final int enrollment_id;
  final int course_id;
  final int sequence;
  final String room_num;
  final int  bldgNumber;
  final String description;
  final String blngName;
  final String room_x;
  final String room_y;
  final String floor;
  final double latitude,longitude;
  

  Enrollment({this.enrollment_id,this.room_x,this.room_y, this.floor,this.bldgNumber,this.course_id, this.sequence,this.room_num, this.description, this.blngName, this.latitude , this.longitude});

  
  Enrollment.fromDb(Map<String, dynamic> map)
      : enrollment_id = int.parse(map['enrollment_id']),
        bldgNumber = int.parse(map['bldgNumber']),
        course_id = int.parse(map['course_id']),
        sequence = int.parse(map['sequence']),
        room_num = map['room_num'],
        blngName = map['blngName'],
        room_x = map['room_x'],
        room_y = map['room_y'],
        floor = map['floor'],
        description = map['description'],
        latitude = double.parse(map['latitude']),
        longitude = double.parse(map['longitude']);

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['enrollment_id'] = enrollment_id;
    map['bldgNumber'] = bldgNumber;
    map['course_id'] = course_id;
    map['sequence'] = sequence;
    map['room_num'] = room_num;
    map['blngName'] = blngName;

    map['room_x'] = room_x;
    map['room_y'] = room_y;
    map['floor'] = floor;

    map['description'] = description;
    map['latitude'] = latitude;
    map['longitude'] = longitude;

    return map;
  }
}
