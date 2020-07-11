import 'package:flutter/material.dart';

class DrawCircle extends CustomPainter {
  
  List<Offset> thirdFloorPath = [
     //from circular stairs
    Offset(50,500),   //0
    Offset(65,490),   //1 path to 9-306
    Offset(75,452.0), //2 path to 9-311
    Offset(78,440.0), //3 path to 9-305
    Offset(85,405.0), //4 path to 9-310
    Offset(89,385.0), //5 path to 9-304
    Offset(95,350.0), //6 path to 9-309
    Offset(95,335.0), //7 path to 9-303
    Offset(95,300.0), //8 path to 9-308
    Offset(94,280.0), //9 path to 9-302
    Offset(91,245.0), //10 path to 9-307
    Offset(90,225.0), //11 path to 9-301
    Offset(80,180.0), //12 room entrance
    Offset(60,160.0), //13 near elevator
    Offset(55,125.0)  //14 outside elevator
  ];

  List<Offset> ictBldnStairs = [
    //circular stairs
    Offset(25,505),//0 down
    Offset(50,520),//1 up
    //near cr
    Offset(130,165.0),//2 near room
    Offset(125,140.0),//3 near cr

    Offset(70,120.0)//4 elevator
   ];

   List<Offset> thirdFloorRoom = [
    Offset(100,500.0),//306
    Offset(115,445.0),//305
    Offset(125,390.0),//304
    Offset(130,335.0),//303
    Offset(130,275.0),//302
    Offset(125,215.0),//301
    Offset(75,245.0), //307
    Offset(75,300.0), //308
    Offset(75,350.0), //309
    Offset(70,400.0), //310
    Offset(55,445.0), //311
   ];

   List<Offset> ictBlngPath = [
    Offset(45,500.0),//path to 9-x06 right door
    Offset(55,470.0),//path to 9 - x06 left
    Offset(60,455.0), //9-x05 right
    Offset(80,420.0), //9-x05 left
    Offset(85,405.0),//9-x04 right
    Offset(90,365.0), //9-x04 left
    Offset(90,350.0),//9-x03 right
    Offset(90,310.0),//9-x03 left
    Offset(90,300.0),//9-x02 right
    Offset(90,260.0), //9-x02 left
    Offset(90,245.0), //9-x02 right
    Offset(80,200.0), //9-x01 left
    Offset(90,260.0),//9-x02 right
    Offset(80,180.0), //6 room entrance
    Offset(60,160.0),//6 near elevator
    Offset(55,125.0),//elevator outside
   ];

  final Color color;
  
  Paint _paint;

  double cSize = 2.0;

  DrawCircle(this.color) {
    _paint = Paint()
      ..color = color
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for(int x = 0 ; x < ictBlngPath.length ; x++){
      canvas.drawCircle(ictBlngPath[x] , cSize, _paint);
    }
    
  
    //circulars stairs
    // canvas.drawCircle(Offset(25,505), cSize, _paint);//down
    // canvas.drawCircle(Offset(50,520), cSize, _paint);//up

    //path
    //from circular stairs
    // canvas.drawCircle(Offset(50,500), cSize, _paint);//0
    // canvas.drawCircle(Offset(65,490), cSize, _paint);//1 path to 9-306
    // canvas.drawCircle(Offset(75,452.0), cSize, _paint);//2 path to 9-311
    // canvas.drawCircle(Offset(78,440.0), cSize, _paint);//3 path to 9-305
    // canvas.drawCircle(Offset(85,405.0), cSize, _paint);//4 path to 9-310
    // canvas.drawCircle(Offset(89,385.0), cSize, _paint);//5 path to 9-304
    // canvas.drawCircle(Offset(95,350.0), cSize, _paint);//6 path to 9-309
    // canvas.drawCircle(Offset(95,335.0), cSize, _paint);//6 path to 9-303
    // canvas.drawCircle(Offset(95,300.0), cSize, _paint);//6 path to 9-308
    // canvas.drawCircle(Offset(94,280.0), cSize, _paint);//6 path to 9-302
    // canvas.drawCircle(Offset(91,245.0), cSize, _paint);//6 path to 9-307
    // canvas.drawCircle(Offset(90,225.0), cSize, _paint);//6 path to 9-301
   
    // canvas.drawCircle(Offset(100,500.0), cSize, _paint);//306
    // canvas.drawCircle(Offset(115,445.0), cSize, _paint);//305
    // canvas.drawCircle(Offset(125,390.0), cSize, _paint);//304
    // canvas.drawCircle(Offset(130,335.0), cSize, _paint);//303
    // canvas.drawCircle(Offset(130,275.0), cSize, _paint);//302
    // canvas.drawCircle(Offset(125,215.0), cSize, _paint);//301
    // canvas.drawCircle(Offset(75,245.0), cSize, _paint);//307
    // canvas.drawCircle(Offset(75,300.0), cSize, _paint);//308
    // canvas.drawCircle(Offset(75,350.0), cSize, _paint);//309
    // canvas.drawCircle(Offset(70,400.0), cSize, _paint);//310
    // canvas.drawCircle(Offset(55,445.0), cSize, _paint);//311

    // canvas.drawCircle(Offset(130,165.0), cSize, _paint);//6 stairs near room
    // canvas.drawCircle(Offset(125,140.0), cSize, _paint);//6 stairs near cr

    

    // canvas.drawCircle(Offset(55,125.0), cSize, _paint);//elevator outside
    // canvas.drawCircle(Offset(70,120.0), cSize, _paint);//elevator

    // //from circular
    // canvas.drawCircle(Offset(45,500.0), cSize, _paint);//path to 9-x06 right door
    // canvas.drawCircle(Offset(55,470.0), cSize, _paint);//path to 9 - x06 left
    // canvas.drawCircle(Offset(60,455.0), cSize, _paint);//9-x05 right
    // canvas.drawCircle(Offset(80,420.0), cSize, _paint);//9-x05 left
    // canvas.drawCircle(Offset(85,405.0), cSize, _paint);//9-x04 right
    // canvas.drawCircle(Offset(90,365.0), cSize, _paint);//9-x04 left
    // canvas.drawCircle(Offset(90,350.0), cSize, _paint);//9-x03 right
    // canvas.drawCircle(Offset(90,310.0), cSize, _paint);//9-x03 left
    // canvas.drawCircle(Offset(90,300.0), cSize, _paint);//9-x02 right
    // canvas.drawCircle(Offset(90,260.0), cSize, _paint);//9-x02 left
    // canvas.drawCircle(Offset(90,245.0), cSize, _paint);//9-x02 right
    // canvas.drawCircle(Offset(80,200.0), cSize, _paint);//9-x01 left
    // canvas.drawCircle(Offset(90,260.0), cSize, _paint);//9-x02 right

    // canvas.drawCircle(Offset(80,180.0), cSize, _paint);//6 room entrance
    // canvas.drawCircle(Offset(60,160.0), cSize, _paint);//6 near elevator
    // canvas.drawCircle(Offset(55,125.0), cSize, _paint);//elevator outside








  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}