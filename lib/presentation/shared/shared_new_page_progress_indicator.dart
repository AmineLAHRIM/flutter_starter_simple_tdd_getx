import 'package:flutter/material.dart';

class SharedNewPageProgressIndicator extends StatelessWidget {
  const SharedNewPageProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Container(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}
