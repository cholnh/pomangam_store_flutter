import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailBottomWidget extends StatelessWidget {

  final bool isActiveLeft;
  final bool isActiveCenter;
  final String leftText;
  final String centerText;
  final String rightText;
  final Color centerColor;
  final Color rightColor;
  final Color rightFontColor;
  final Function onLeftTap;
  final Function onCenterTap;
  final Function onRightTap;
  final int leftFlex;
  final int centerFlex;
  final int rightFlex;

  OrderDetailBottomWidget({
    this.isActiveLeft = true,
    this.isActiveCenter = false,
    this.leftText = '',
    this.centerText = '',
    this.rightText = '',
    this.centerColor,
    this.rightColor,
    this.rightFontColor,
    this.onLeftTap,
    this.onCenterTap,
    this.onRightTap,
    this.leftFlex = 1,
    this.centerFlex = 1,
    this.rightFlex = 1
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        if(isActiveLeft) Expanded(
          flex: leftFlex,
          child: GestureDetector(
            onTap: onLeftTap,
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                  color: Theme.of(Get.context).backgroundColor,
                  border: Border.all(
                      color: Theme.of(Get.context).dividerColor,
                      width: 0.5
                  )
              ),
              child: Center(
                child: Text('$leftText', style: TextStyle(
                    color: Theme.of(Get.context).textTheme.headline1.color,
                    fontSize: 17
                )),
              ),
            ),
          ),
        ),
        if(isActiveCenter) Expanded(
          flex: centerFlex,
          child: GestureDetector(
            onTap: onCenterTap,
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                  color: centerColor == null ? Theme.of(Get.context).backgroundColor : centerColor,
                  border: Border.all(
                      color: Theme.of(Get.context).dividerColor,
                      width: 0.5
                  )
              ),
              child: Center(
                child: Text('$centerText', style: TextStyle(
                    color: Colors.white,
                    fontSize: 17
                )),
              ),
            ),
          ),
        ),
        Expanded(
          flex: rightFlex,
          child: GestureDetector(
            onTap: onRightTap,
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                  color: rightColor == null ? Theme.of(Get.context).primaryColor : rightColor,
                  border: Border.all(
                    color: Theme.of(Get.context).dividerColor,
                    width: 0.5
                  )
              ),
              child: Center(
                child: Text('$rightText', style: TextStyle(
                    color: rightFontColor == null ? Colors.white : rightFontColor,
                    fontSize: 17
                )),
              ),
            ),
          ),
        ),
      ]
    );
  }
}
