import 'dart:math';

class Point3D {
  
  final String name;
  final int x, y, z;

  const Point3D(this.name, this.x, this.y, this.z);

  double distanceTo(Point3D other) {
    final dx = x - other.x;
    final dy = y - other.y;
    final dz = z - other.z;

    return sqrt(dx * dx + dy * dy + dz * dz);
  }
}

class Point4D {
  
  final String name;
  final int x, y, z, a;

  const Point4D(this.name, this.x, this.y, this.z, this.a);

  double distanceTo(Point4D other) {
    final dx = x - other.x;
    final dy = y - other.y;
    final dz = z - other.z;
    final da = a - other.a;

    return sqrt(dx * dx + dy * dy + dz * dz + da * da);
  }
}
 

 // const point = Point3D('Search', 51, 102, 120);
