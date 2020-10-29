// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Owner _$OwnerFromJson(Map<String, dynamic> json) {
  return Owner(
    idx: json['idx'] as int,
    registerDate: json['registerDate'] == null
        ? null
        : DateTime.parse(json['registerDate'] as String),
    modifyDate: json['modifyDate'] == null
        ? null
        : DateTime.parse(json['modifyDate'] as String),
    phoneNumber: json['phoneNumber'] as String,
    id: json['id'] as String,
    password: json['password'] as String,
    name: json['name'] as String,
    sex: _$enumDecodeNullable(_$SexEnumMap, json['sex']),
    birth:
        json['birth'] == null ? null : DateTime.parse(json['birth'] as String),
    idxFcmToken: json['idxFcmToken'] as int,
    idxStore: json['idxStore'] as int,
  );
}

Map<String, dynamic> _$OwnerToJson(Owner instance) => <String, dynamic>{
      'idx': instance.idx,
      'registerDate': instance.registerDate?.toIso8601String(),
      'modifyDate': instance.modifyDate?.toIso8601String(),
      'phoneNumber': instance.phoneNumber,
      'id': instance.id,
      'password': instance.password,
      'name': instance.name,
      'sex': _$SexEnumMap[instance.sex],
      'birth': instance.birth?.toIso8601String(),
      'idxFcmToken': instance.idxFcmToken,
      'idxStore': instance.idxStore,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$SexEnumMap = {
  Sex.MALE: 'MALE',
  Sex.FEMALE: 'FEMALE',
};
