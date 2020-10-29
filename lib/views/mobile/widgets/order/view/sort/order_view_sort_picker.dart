import 'package:flutter/material.dart';
import 'package:pomangam/views/mobile/widgets/order/view/sort/order_view_sort_picker_item_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/view/sort/order_view_sort_type.dart';

class OrderViewSortPicker extends StatelessWidget {

  final Widget child;
  final Function onChanged;

  OrderViewSortPicker({this.child, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showModal(context),
      child: child,
    );
  }

  void _showModal(context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(13.0),
          topRight: Radius.circular(13.0)
        )
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(child: Text('제품 정렬')),
              ),
              Divider(height: 0.5, thickness: 3.0, color: Colors.grey[100]),
              Column(children: _items())
            ],
          ),
        );
      }
    );
  }

  List<Widget> _items() {
    return OrderViewSortType.values.map((sortType) {
      return OrderViewSortPickerItemWidget(
        type: sortType,
        onChanged: onChanged
      );
    }).toList();
  }
}
