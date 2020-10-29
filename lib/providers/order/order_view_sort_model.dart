import 'package:flutter/cupertino.dart';
import 'package:pomangam/domains/_bases/page_request.dart';
import 'package:pomangam/views/mobile/widgets/order/view/sort/order_view_sort_type.dart';

class OrderViewSortModel with ChangeNotifier {

  /// data
  OrderViewSortType sortType = OrderViewSortType.SORT_BY_RECOMMEND_DESC;

  void changeSortType(OrderViewSortType sortType, {bool notify = true}) {
    this.sortType = sortType;
    if(notify) {
      notifyListeners();
    }
  }

  void clear({bool notify = true}) {
    this.sortType = OrderViewSortType.SORT_BY_RECOMMEND_DESC;
    if(notify) {
      notifyListeners();
    }
  }

  Sort sort() {
    return convertStoreSortTypeToSort(this.sortType);
  }
}