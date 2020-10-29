// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_owner_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FcmOwnerTokenRequest _$FcmOwnerTokenRequestFromJson(Map<String, dynamic> json) {
  return FcmOwnerTokenRequest(
    idx: json['idx'] as int,
    registerDate: json['registerDate'] == null
        ? null
        : DateTime.parse(json['registerDate'] as String),
    modifyDate: json['modifyDate'] == null
        ? null
        : DateTime.parse(json['modifyDate'] as String),
    token: json['token'] as String,
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$FcmOwnerTokenRequestToJson(
        FcmOwnerTokenRequest instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'registerDate': instance.registerDate?.toIso8601String(),
      'modifyDate': instance.modifyDate?.toIso8601String(),
      'token': instance.token,
      'id': instance.id,
    };
