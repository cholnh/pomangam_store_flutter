import 'package:json_annotation/json_annotation.dart';
import 'package:pomangam/domains/_bases/entity_auditing.dart';

part 'fcm_owner_token_request.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class FcmOwnerTokenRequest extends EntityAuditing {

  String token;
  String id;

  FcmOwnerTokenRequest({
    int idx, DateTime registerDate, DateTime modifyDate,
    this.token, this.id
  }): super(idx: idx, registerDate: registerDate, modifyDate: modifyDate);

  Map<String, dynamic> toJson() => _$FcmOwnerTokenRequestToJson(this);
  factory FcmOwnerTokenRequest.fromJson(Map<String, dynamic> json) => _$FcmOwnerTokenRequestFromJson(json);
  static List<FcmOwnerTokenRequest> fromJsonList(List<dynamic> jsonList) {
    List<FcmOwnerTokenRequest> entities = [];
    jsonList.forEach((map) => entities.add(FcmOwnerTokenRequest.fromJson(map)));
    return entities;
  }

  @override
  String toString() {
    return 'FcmOwnerTokenRequest{token: $token, id: $id}';
  }
}