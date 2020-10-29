import 'package:pomangam/domains/_bases/page_request.dart';

enum OrderViewSortType {
  SORT_BY_RECOMMEND_DESC,
  SORT_BY_ORDER_DESC,
  SORT_BY_STAR_DESC,
  SORT_BY_REVIEW_DESC,
  SORT_BY_LIKE_DESC
}

OrderViewSortType convertTextToGroupSortType(String type) {
  if(type == null) return null;
  return OrderViewSortType.values.singleWhere((value) => value.toString().toUpperCase() == type.toUpperCase());
}

String convertGroupSortTypeToText(OrderViewSortType type) {
  if(type != null) {
    switch(type) {
      case OrderViewSortType.SORT_BY_RECOMMEND_DESC:
        return '추천순';
      case OrderViewSortType.SORT_BY_ORDER_DESC:
        return '주문많은순';
      case OrderViewSortType.SORT_BY_STAR_DESC:
        return '별점높은순';
      case OrderViewSortType.SORT_BY_REVIEW_DESC:
        return '리뷰많은순';
      case OrderViewSortType.SORT_BY_LIKE_DESC:
        return '좋아요많은순';
    }
  }
  return '';
}

Sort convertStoreSortTypeToSort(OrderViewSortType type) {
  Sort sort;
  if(type != null) {
    switch(type) {
      case OrderViewSortType.SORT_BY_RECOMMEND_DESC:
        sort = Sort(property: 'sequence', direction: Direction.ASC);
        break;
      case OrderViewSortType.SORT_BY_ORDER_DESC:
        sort = Sort(property: 'cntOrder', direction: Direction.DESC);
        break;
      case OrderViewSortType.SORT_BY_STAR_DESC:
        sort = Sort(property: 'avgStar', direction: Direction.DESC);
        break;
      case OrderViewSortType.SORT_BY_REVIEW_DESC:
        sort = Sort(property: 'cntReview', direction: Direction.DESC);
        break;
      case OrderViewSortType.SORT_BY_LIKE_DESC:
        sort = Sort(property: 'cntLike', direction: Direction.DESC);
        break;
    }
  } else {
    sort = Sort();
  }
  return sort;
}