import 'package:bloodlines/Components/Color.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class FloatingButton extends StatefulWidget {
  @override
  FloatingButtonState createState() => FloatingButtonState();
}

class FloatingButtonState extends State<FloatingButton>
    with TickerProviderStateMixin {
  int _angle = 90;
  bool _isRotated = true;

  AnimationController? _controller;
  Animation<double>? _animation;
  Animation<double>? _animation2;
  Animation<double>? _animation3;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Interval(0.0, 1.0, curve: Curves.linear),
    );

    _animation2 = CurvedAnimation(
      parent: _controller!,
      curve: Interval(0.5, 1.0, curve: Curves.linear),
    );

    _animation3 = CurvedAnimation(
      parent: _controller!,
      curve: Interval(0.8, 1.0, curve: Curves.linear),
    );
    _controller!.reverse();
    super.initState();
  }

  void _rotate() {
    setState(() {
      if (_isRotated) {
        _angle = 45;
        _isRotated = false;
        _controller!.forward();
      } else {
        _angle = 90;
        _isRotated = true;
        _controller!.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isRotated == false
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: Colors.black26,
              child: body(),
            ),
          )
        : body();
  }

  Stack body() {
    return Stack(children: <Widget>[
      Positioned(
          bottom: 200.0,
          left: 24.0,
          child: Row(
            children: <Widget>[
              ScaleTransition(
                scale: _animation3!,
                alignment: FractionalOffset.center,
                child: Container(
                  margin: EdgeInsets.only(left: 16.0),
                  child: Text(
                    'foo1',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontFamily: 'Roboto',
                      color: Color(0xFF9E9E9E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ScaleTransition(
                scale: _animation3!,
                alignment: FractionalOffset.center,
                child: Material(
                    color: Color(0xFF9E9E9E),
                    type: MaterialType.circle,
                    elevation: 6.0,
                    child: GestureDetector(
                      child: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: InkWell(
                            onTap: () {
                              if (_angle == 45.0) {
                                print("foo1");
                              }
                            },
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          )),
                    )),
              ),
            ],
          )),
      Positioned(
          bottom: 144.0,
          left: 24.0,
          child: Row(
            children: <Widget>[
              ScaleTransition(
                scale: _animation2!,
                alignment: FractionalOffset.center,
                child: Container(
                  margin: EdgeInsets.only(left: 16.0),
                  child: Text(
                    'foo2',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontFamily: 'Roboto',
                      color: Color(0xFF9E9E9E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ScaleTransition(
                scale: _animation2!,
                alignment: FractionalOffset.center,
                child: Material(
                    color: Color(0xFF00BFA5),
                    type: MaterialType.circle,
                    elevation: 6.0,
                    child: GestureDetector(
                      child: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: InkWell(
                            onTap: () {
                              if (_angle == 45.0) {
                                print("foo2");
                              }
                            },
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          )),
                    )),
              ),
            ],
          )),
      Positioned(
          bottom: 88.0,
          left: 24.0,
          child: Container(
            child: Row(
              children: <Widget>[
                ScaleTransition(
                  scale: _animation!,
                  alignment: FractionalOffset.center,
                  child: Container(
                    margin: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'foo3',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: 'Roboto',
                        color: Color(0xFF9E9E9E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ScaleTransition(
                  scale: _animation!,
                  alignment: FractionalOffset.center,
                  child: Material(
                      color: Color(0xFFE57373),
                      type: MaterialType.circle,
                      elevation: 6.0,
                      child: GestureDetector(
                        child: SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: InkWell(
                              onTap: () {
                                if (_angle == 45.0) {
                                  print("foo3");
                                }
                              },
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            )),
                      )),
                ),
              ],
            ),
          )),
      Positioned(
        bottom: 16.0,
        left: 32.0,
        child: Material(
            color: DynamicColors.primaryColorRed,
            type: MaterialType.circle,
            elevation: 6.0,
            child: GestureDetector(
              child: SizedBox(
                  width: 56.0,
                  height: 56.00,
                  child: InkWell(
                    onTap: _rotate,
                    child: Center(
                        child: RotationTransition(
                      turns: AlwaysStoppedAnimation(_angle / 360),
                      child: Icon(
                        Icons.add,
                        color: Color(0xFFFFFFFF),
                      ),
                    )),
                  )),
            )),
      ),
    ]);
  }
}
