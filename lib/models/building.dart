class Building {
  final int id, bldgNumber;
  final String blngName, namenum;
  final double latitude, longitude; 


  Building({this.id,this.namenum, this.blngName, this .bldgNumber, this .latitude , this.longitude});

  @override
  String toString() {
    return '{ ${this.id},${this.blngName},${this.bldgNumber}, ${this.latitude}, ${this.longitude}}';
  }

  Building.fromDb(Map<String, dynamic> map)
      : id = int.parse(map['id']),
        namenum = int.parse(map['bldgNumber']) != 0 ? "Building "+(map['bldgNumber']+" "+map['blngName']) : (map['blngName']),
        blngName = (map['blngName']),
        bldgNumber = int.parse(map['bldgNumber']),
        latitude = double.parse(map['latitude']),
        longitude = double.parse(map['longitude']);

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['blngName'] = blngName;
    map['bldgNumber'] = bldgNumber;
    map['latitude'] = latitude;
    map['longitude'] = longitude;

    return map;
  }
}
