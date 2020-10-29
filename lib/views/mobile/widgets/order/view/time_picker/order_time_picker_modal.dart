import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomangam/providers/order/time/order_time_model.dart';
import 'package:pomangam/views/mobile/widgets/order/view/time_picker/order_date_picker_modal.dart';
import 'package:pomangam/views/mobile/widgets/order/view/time_picker/order_time_picker_modal_header_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/view/time_picker/order_time_picker_modal_item_widget.dart';
import 'package:provider/provider.dart';
import 'package:time/time.dart';

class OrderTimePickerModal extends StatefulWidget {

  final Function onSelected;

  OrderTimePickerModal({this.onSelected});

  @override
  _OrderTimePickerModalState createState() => _OrderTimePickerModalState();
}

class _OrderTimePickerModalState extends State<OrderTimePickerModal> {

  @override
  void initState() {
    super.initState();
    OrderTimeModel orderTimeModel = Provider.of<OrderTimeModel>(context, listen: false);
    orderTimeModel.isOrderDateMode = false;
    orderTimeModel.isOrderDateChanged = false;
    orderTimeModel.viewUserOrderDate = orderTimeModel.userOrderDate;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 530.0,
        child: Consumer<OrderTimeModel>(
          builder: (_, model, child) {
            String textOrderDate = DateFormat('yyyy년 MM월 dd일').format(model.viewUserOrderDate);
            String subTextOrderDate = _subTextOrderDate(model.viewUserOrderDate);
            return Column(
              children: <Widget>[
                OrderTimePickerModalHeaderWidget(
                  isOrderDateMode: model.isOrderDateMode,
                  textOrderDate: '$textOrderDate $subTextOrderDate',
                  onSelectedDatePicker: () => model.changeOrderDateMode(!model.isOrderDateMode),
                ),
                Divider(height: 0.0, thickness: 4.0, color: Colors.black.withOpacity(0.03)),
                model.isOrderDateMode
                ? OrderDatePicker(
                    initialDate: model.viewUserOrderDate,
                    onSelectedDate: (date) => _onSelectedDate(date),
                )
                : OrderTimePickerModalItemWidget(
                    model: model,
                    onSelected: widget.onSelected
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  void _onSelectedDate(DateTime date) {
    OrderTimeModel model = Provider.of<OrderTimeModel>(context, listen: false);
    model.changeOrderDateMode(false);
    if(date != null) {
      model.changeViewUserOrderDate(date);
    }
  }

  String _subTextOrderDate(DateTime dt) {
    bool isToday = _isToday(dt);
    bool isTomorrow = _isTomorrow(dt);
    if(isToday) {
      return '(오늘)';
    } else if(isTomorrow) {
      return '(내일)';
    } else {
      return '';
    }
  }

  bool _isToday(DateTime dt) {
    DateTime now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  bool _isTomorrow(DateTime dt) {
    DateTime tomorrow = 1.days.fromNow;
    return dt.year == tomorrow.year && dt.month == tomorrow.month && dt.day == tomorrow.day;
  }
}
