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
 

 // const point = Point3D('Search', 51, 102, 120);
