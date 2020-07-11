class Room {
  final int room_id;
  final String namenum;
  final String roomNum;
  final String floor;
  final String roomName;
  final double roomXCoor;
  final double roomYCoor;
  final int rssi1,rssi2,rssi3,rssi4;
  final String blngName;
  final int bldgNumber;
  final double latitude,longitude;

  Room({this.room_id,this.namenum, this.roomNum, this.floor, this.roomName,
  this.roomXCoor,this.roomYCoor,this.rssi1,this.rssi2,this.rssi3,this.rssi4,
  this.blngName,this.bldgNumber, this.latitude , this.longitude});

  
  Room.fromDb(Map<String, dynamic> map)
      : room_id = int.parse(map['room_id']),
        namenum = int.parse(map['bldgNumber']) != 0 ? (map['bldgNumber']+"-"+map['roomNum'])+" "+map['roomName']  : (map['blngName']+"-"+map['roomNum'])+" "+map['roomName'],
        roomNum = map['roomNum'],
        floor = map['floor'],
        roomName = map['roomName'],
        roomXCoor = double.parse(map['roomXCoor']),
        roomYCoor = double.parse(map['roomYCoor']),
        rssi1 = int.parse(map['rssi1']),
        rssi2 = int.parse(map['rssi2']),
        rssi3 = int.parse(map['rssi3']),
        rssi4 = int.parse(map['rssi4']),
        blngName = map['blngName'],
        bldgNumber = int.parse(map['bldgNumber']),
        latitude = double.parse(map['latitude']),
        longitude = double.parse(map['longitude']);

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['room_id'] = room_id;
    map['roomNum'] = roomNum;
    map['floor'] = floor;
    map['roomName'] = roomName;
    map['roomXCoor'] = roomXCoor;
    map['roomYCoor'] = roomYCoor;
    map['rssi1'] = rssi1;
    map['rssi2'] = rssi2;
    map['rssi3'] = rssi3;
    map['rssi4'] = rssi4;
    map['blngName'] = blngName;
    map['bldgNumber'] = bldgNumber;
    map['latitude'] = latitude;
    map['longitude'] = longitude;

    return map;
  }
}
