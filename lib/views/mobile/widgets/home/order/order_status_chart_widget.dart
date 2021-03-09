import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/constants/endpoint.dart';
import 'package:pomangam/providers/order/order_view_model.dart';
import 'package:provider/provider.dart';

class OrderStatusChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isPcWebFullScreen = Get.context.read<OrderViewModel>().isFullScreen && kIsPcWeb(context: Get.context);

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[200],
          width: 1.0
        )
      ),
      child: Padding(
        padding: Get.context.read<OrderViewModel>().isFullScreen
          ? const EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 20)
          : const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 30),
        child: Column(
          children: [
            Row(
              children: [
                _colorInfo(color: Color(0x444af699), title: '한국항공대학교'),
                SizedBox(width: 10),
                _colorInfo(color: Color(0xffff4500), title: '일산 한화생명'),
                SizedBox(width: 10),
                _colorInfo(color: Color(0xff123400), title: '일산 테크노벨리')
              ],
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.height - 60)/2 - 30 - 10 - 30,
              child: LineChart(
                sampleData2(isPcWebFullScreen: isPcWebFullScreen),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorInfo({Color color, String title}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: Colors.black,
              width: 0.3
            )
          ),
        ),
        SizedBox(width: 5),
        Text('$title', style: TextStyle(
          fontSize: 13,
          color: Colors.black,
        ))
      ],
    );
  }

  LineChartData sampleData2({bool isPcWebFullScreen}) {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: false,
      ),
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: isPcWebFullScreen ? 16 : 13,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1/15';
              case 2:
                return '1/16';
              case 3:
                return '1/17';
              case 4:
                return '1/18';
              case 5:
                return '1/19';
              case 6:
                return '1/20';
              case 7:
                return '1/21';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: isPcWebFullScreen ? 14 : 12,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '30';
              case 2:
                return '60';
              case 3:
                return '90';
              case 4:
                return '120';
              case 5:
                return '150';
              case 6:
                return '180';
              case 7:
                return '210';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 2,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: 8,
      maxY: 8,
      minY: 0,
      lineBarsData: linesBarData2(),
    );
  }

  double _value(int n) {
    return (n * 7) / 210;
  }

  List<LineChartBarData> linesBarData2() {
    return [
      LineChartBarData(
        spots: [
          FlSpot(1, _value(10)),
          FlSpot(2, _value(30)),
          FlSpot(3, _value(50)),
          FlSpot(4, _value(70)),
          FlSpot(5, _value(100)),
          FlSpot(6, _value(60)),
          FlSpot(7, _value(150)),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0x444af699),
        ],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
      LineChartBarData(
        spots: [
          FlSpot(1, _value(50)),
          FlSpot(2, _value(60)),
          FlSpot(3, _value(50)),
          FlSpot(4, _value(40)),
          FlSpot(5, _value(70)),
          FlSpot(6, _value(110)),
          FlSpot(7, _value(150)),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0xffff4500),
        ],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
      LineChartBarData(
        spots: [
          FlSpot(1, _value(20)),
          FlSpot(2, _value(70)),
          FlSpot(3, _value(110)),
          FlSpot(4, _value(150)),
          FlSpot(5, _value(130)),
          FlSpot(6, _value(140)),
          FlSpot(7, _value(190)),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0xff123400),
        ],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
      // LineChartBarData(
      //   spots: [
      //     FlSpot(1, 1),
      //     FlSpot(3, 2.8),
      //     FlSpot(7, 1.2),
      //     FlSpot(10, 2.8),
      //     FlSpot(12, 2.6),
      //     FlSpot(13, 3.9),
      //   ],
      //   isCurved: true,
      //   colors: const [
      //     Color(0x99aa4cfc),
      //   ],
      //   barWidth: 4,
      //   isStrokeCapRound: true,
      //   dotData: FlDotData(
      //     show: false,
      //   ),
      //   belowBarData: BarAreaData(show: true, colors: [
      //     const Color(0x33aa4cfc),
      //   ]),
      // ),
      // LineChartBarData(
      //   spots: [
      //     FlSpot(1, 3.8),
      //     FlSpot(3, 1.9),
      //     FlSpot(6, 5),
      //     FlSpot(10, 3.3),
      //     FlSpot(13, 4.5),
      //   ],
      //   isCurved: true,
      //   curveSmoothness: 0,
      //   colors: const [
      //     Color(0x4427b6fc),
      //   ],
      //   barWidth: 2,
      //   isStrokeCapRound: true,
      //   dotData: FlDotData(show: true),
      //   belowBarData: BarAreaData(
      //     show: false,
      //   ),
      // ),
    ];
  }
}
