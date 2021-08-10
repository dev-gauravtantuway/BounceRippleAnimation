import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(
    MaterialApp(
      title: 'Bounce Ripple Animation',
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  late AnimationController rippleController;
  late AnimationController centerCircleController;

  late Animation<double> rippleRadius;
  late Animation<double> rippleOpacity;
  late Animation<double> centerCircleRadius;

  @override
  void initState() {
    rippleController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 2500,
      ),
    );
    rippleRadius = Tween<double>(begin: 0, end: 150).animate(
      CurvedAnimation(
        parent: rippleController,
        curve: Curves.ease,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            rippleController.repeat();
          } else if (status == AnimationStatus.dismissed) {
            rippleController.forward();
          }
        },
      );

    rippleOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: rippleController,
        curve: Curves.ease,
      ),
    )
      ..addListener(
        () {
          setState(() {});
        },
      )
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            rippleController.repeat();
          } else if (status == AnimationStatus.dismissed) {
            rippleController.forward();
          }
        },
      );

    centerCircleController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 1250,
      ),
    );
    centerCircleRadius = Tween<double>(begin: 22, end: 16).animate(
        CurvedAnimation(
            parent: centerCircleController,
            curve: Curves.ease,
            reverseCurve: Curves.easeInOut))
      ..addListener(
        () {
          setState(() {});
        },
      )
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            centerCircleController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            centerCircleController.forward();
          }
        },
      );

    Timer(
      Duration(milliseconds: 1600),
      () {
        rippleController.forward();
      },
    );
    centerCircleController.forward();
    super.initState();
  }

  @override
  void dispose() {
    rippleController.dispose();
    centerCircleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Container(
          height: displayWidth,
          width: displayWidth,
          child: CustomPaint(
            painter: MyPainter(
              rippleRadius.value,
              rippleOpacity.value,
              centerCircleRadius.value,
            ),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double rippleRadius;
  final double rippleOpacity;
  final double centerCircleRadius;

  MyPainter(
    this.rippleRadius,
    this.rippleOpacity,
    this.centerCircleRadius,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var firstPaint = Paint()
    ..color = Colors.blue.withOpacity(rippleOpacity)
    ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * .5, size.height * .5),
      rippleRadius,
      firstPaint,
    );

    var secondPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * .5, size.height * .5),
      size.width / 11,
      secondPaint,
    );

    var thirdPaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * .5, size.height * .5),
      size.width / centerCircleRadius,
      thirdPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
