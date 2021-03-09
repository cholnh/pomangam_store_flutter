import 'package:get/get.dart';
import 'package:pomangam/_bases/network/api/api.dart';
import 'package:pomangam/domains/version/version.dart';

class VersionRepository {

  final Api api = Get.find<Api>(tag: 'api');

  Future<Version> find() async
    => Version.fromJson((await api.get(url: '/versions/owner')).data);
}