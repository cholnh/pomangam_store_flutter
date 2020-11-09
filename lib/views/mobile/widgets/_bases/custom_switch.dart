import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {

  final bool value;
  final Widget onIcon;
  final Widget offIcon;
  final bool isLoading;

  CustomSwitch({this.value = true, this.onIcon, this.offIcon, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46.0,
      height: 30.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(360.0),
        color: Colors.transparent.withOpacity(0.5)),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            value
              ? SizedBox(width: 16)
              : Container(),
            Align(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 26.0,
                height: 26.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value
                    ? Colors.white
                    : Colors.grey[100]
                ),
                child: isLoading ? CupertinoActivityIndicator()
                : value
                  ? onIcon == null ? Icon(Icons.check, size: 20, color: Color.fromRGBO(0xff, 0x45, 0x00, 1.0)) : onIcon
                  : offIcon == null ? Icon(Icons.pause_sharp, size: 20, color: Colors.white) : offIcon
              ),
            ),
            !value
              ? SizedBox(width: 16)
              : Container(),
          ],
        ),
      ),
    );
  }
}
