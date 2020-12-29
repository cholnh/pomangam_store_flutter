import 'package:json_annotation/json_annotation.dart';
import 'package:pomangam/domains/vbank/vbank_status.dart';

part 'vbank.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class VBank {

  int idx;
  DateTime registerDate;
  int input;
  String bank;
  int remain;
  String name;
  String transferDate;
  String content;
  VBankStatus status;
  int idxOrder;

  VBank({
    this.idx, this.registerDate, this.input, this.bank, this.remain,
    this.name, this.transferDate, this.content, this.status, this.idxOrder
  });

  factory VBank.fromJson(Map<String, dynamic> json) => _$VBankFromJson(json);
  Map<String, dynamic> toJson() => _$VBankToJson(this);
  static List<VBank> fromJsonList(List<dynamic> jsonList) {
    List<VBank> entities = [];
    jsonList.forEach((map) => entities.add(VBank.fromJson(map)));
    return entities;
  }
}