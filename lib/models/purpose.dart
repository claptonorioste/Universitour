class Purpose {
  final int id;
  final String purposeName;
  final String blngName;
   final double latitude, longitude; 

  Purpose({this.id, this.purposeName, this.blngName , this.latitude, this.longitude});

  @override
  String toString() {
    return '{ ${this.id},${this.purposeName}, }';
  }

  Purpose.fromDb(Map<String, dynamic> map)
      : id = int.parse(map['id']),
        purposeName = (map['purposeName']),
        blngName = (map['blngName']),
        latitude = double.parse(map['latitude']),
        longitude = double.parse(map['longitude'])
        ;

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['purposeName'] = purposeName;
    map['blngName'] = blngName;
    map['latitude'] = latitude;
    map['longitude'] = longitude;

    return map;
  }
}
