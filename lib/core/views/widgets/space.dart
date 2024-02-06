import 'package:flutter/cupertino.dart';

class Space extends StatelessWidget {

  double width;
  double height;

  Space({Key? key,this.width = 0.0,this.height = 0.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
