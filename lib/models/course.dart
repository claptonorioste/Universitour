class Course {
  final int course_id;
  final String course_name;

  Course({this.course_id, this.course_name});

  @override
  String toString() {
    return '{ ${this.course_id},${this.course_name}, }';
  }

  Course.fromDb(Map<String, dynamic> map)
      : course_id = int.parse(map['course_id']),
        course_name = (map['course_name']);

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['course_id'] = course_id;
    map['course_name'] = course_name;

    return map;
  }
}
