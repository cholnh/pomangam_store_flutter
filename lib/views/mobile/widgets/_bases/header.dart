import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_shimmer.dart';

class Header extends StatelessWidget {

  final String title;
  final String subTitle;
  final Widget leading;
  final Widget action;
  final EdgeInsetsGeometry padding;
  final Function onTapTitle;
  final bool autoSized;
  final bool isShimmerMode;

  Header({
    this.title = '',
    this.subTitle = '',
    this.leading,
    this.action,
    this.padding = const EdgeInsets.only(bottom: 5.0, left: 20.0, right: 20.0),
    this.onTapTitle,
    this.autoSized = false,
    this.isShimmerMode = false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if(isShimmerMode) CustomShimmer(width: 60, height: 20)
              else GestureDetector(
                onTap: onTapTitle,
                child: Row(
                  crossAxisAlignment: autoSized
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.baseline,
                  children: [
                    SizedBox(width: 5),
                    SizedBox(
                      width: _sizedWidth(),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    if (leading == null) Container()
                    else leading,
                    if (subTitle != null) Row(
                      children: [
                        Text(
                          subTitle,
                          style: TextStyle(
                              color: Theme.of(context).textTheme.headline1.color,
                              fontSize: 13.0
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ),
            ],
          ),
          if(isShimmerMode) CustomShimmer(width: 70, height: 20)
          else action == null ? Container() : action
        ],
      ),
    );
  }

  double _sizedWidth() {
    Size textSize = _textSize();
    double w = MediaQuery.of(Get.context).size.width-30-25;
    w = textSize.width < w ? textSize.width + 15 : w;
    return w;
  }

  Size _textSize() {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: title, style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0
        )), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
