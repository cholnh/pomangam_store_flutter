import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/providers/order/order_view_sort_model.dart';
import 'package:pomangam/views/mobile/widgets/order/view/sort/order_view_sort_type.dart';
import 'package:provider/provider.dart';

class OrderViewSortPickerItemWidget extends StatelessWidget {

  final OrderViewSortType type;
  final Function onChanged;

  OrderViewSortPickerItemWidget({this.type, this.onChanged});

  @override
  Widget build(BuildContext context) {
    OrderViewSortType current = context.watch<OrderViewSortModel>().sortType;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 10),
                Text('${convertGroupSortTypeToText(type)}', style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: current == type
                    ? FontWeight.bold
                    : FontWeight.normal,
                  color: current == type
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.subtitle1.color
                )),
                const Padding(padding: EdgeInsets.all(3)),
                if (current == type) Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                  size: 18.0
                )
                else Container()
              ],
            ),
            onTap: () => _onSelected(type),
          )
        ),
        Divider(height: 0.5, thickness: 0.5)
      ],
    );
  }

  void _onSelected(OrderViewSortType sortType) async {
    Get.back();
    Get.context.read<OrderViewSortModel>().changeSortType(sortType);
    onChanged();
  }
}
