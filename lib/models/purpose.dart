class Purpose {
  final int id;
  final String purposeName;

  Purpose({this.id, this.purposeName});

  @override
  String toString() {
    return '{ ${this.id},${this.purposeName}, }';
  }

  Purpose.fromDb(Map<String, dynamic> map)
      : id = int.parse(map['id']),
        purposeName = (map['purposeName']);

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['purposeName'] = purposeName;

    return map;
  }
}
