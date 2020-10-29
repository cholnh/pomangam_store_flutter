import 'package:flutter/material.dart';
import 'package:pomangam/domains/_bases/page_request.dart';

abstract class NetworkService {
  Future initialize();
  Future get({
    @required String url,
    PageRequest pageRequest,
    Function fallBack
  });
  Future post({
    @required String url,
    dynamic data
  });
  Future patch({
    @required String url,
    dynamic data
  });
  @deprecated
  Future put({
    @required String url,
    dynamic data
  });
  Future delete({
    @required String url
  });
}