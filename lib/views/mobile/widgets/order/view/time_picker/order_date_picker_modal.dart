import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';


class OrderDatePicker extends StatelessWidget {

  final DateTime initialDate;
  final Function(DateTime) onSelectedDate;

  OrderDatePicker({this.initialDate, this.onSelectedDate});

  @override
  Widget build(BuildContext context) {
    return CalendarCarousel<Event>(
      locale: 'ko',
      onDayPressed: (DateTime date, List<Event> events) => onSelectedDate(date),
      thisMonthDayBorderColor: Colors.white,
      weekendTextStyle: TextStyle(color: Colors.black),
      height: 420.0,
      selectedDateTime: initialDate,
      selectedDayBorderColor: Theme.of(Get.context).primaryColor,
      selectedDayButtonColor: Theme.of(Get.context).backgroundColor,
      selectedDayTextStyle: TextStyle(color: Colors.black),
      daysHaveCircularBorder: false,
      todayButtonColor: Colors.white,
      todayBorderColor: Colors.white,
      todayTextStyle: TextStyle(color: Theme.of(Get.context).primaryColor, fontWeight: FontWeight.bold),
      headerTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16.0),
      leftButtonIcon: Icon(Icons.chevron_left, color: Colors.black),
      rightButtonIcon: Icon(Icons.chevron_right, color: Colors.black),
    );
  }
}

