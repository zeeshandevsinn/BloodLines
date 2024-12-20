import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  const Empty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image(
        image: AssetImage('assets/nodata.png'),
      ),
    );
  }
}
