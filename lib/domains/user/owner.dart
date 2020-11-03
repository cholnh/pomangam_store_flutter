import 'package:json_annotation/json_annotation.dart';
import 'package:pomangam/domains/_bases/entity_auditing.dart';
import 'package:pomangam/domains/user/enum/sex.dart';

part 'owner.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class Owner extends EntityAuditing {

  String phoneNumber;

  String id;

  String password;

  String name;

  Sex sex;

  DateTime birth;

  int idxFcmToken;

  int idxStore;

  Owner({
    int idx, DateTime registerDate, DateTime modifyDate,
    this.phoneNumber, this.id, this.password,
    this.name, this.sex, this.birth, this.idxFcmToken, this.idxStore
  }): super(idx: idx, registerDate: registerDate, modifyDate: modifyDate);

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
  Map<String, dynamic> toJson() => _$OwnerToJson(this);

  @override
  String toString() {
    return 'Owner{phoneNumber: $phoneNumber, id: $id, password: $password, name: $name, sex: $sex, birth: $birth, idxFcmToken: $idxFcmToken, idxStore: $idxStore}';
  }
}