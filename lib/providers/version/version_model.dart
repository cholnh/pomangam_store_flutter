import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/domains/version/version.dart';
import 'package:pomangam/repositories/version/version_repository.dart';

class VersionModel with ChangeNotifier {

  VersionRepository _versionRepository = Get.find(tag: 'versionRepository');

  Version version;

  Future<Version> fetch() async {
    try {
      this.version = await _versionRepository.find();
    } catch (error) {
      print('[Debug] VersionModel.fetch Error - $error');
    }
    notifyListeners();
    return version;
  }

}