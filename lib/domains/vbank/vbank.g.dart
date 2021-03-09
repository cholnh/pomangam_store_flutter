// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vbank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VBank _$VBankFromJson(Map<String, dynamic> json) {
  return VBank(
    idx: json['idx'] as int,
    registerDate: json['registerDate'] == null
        ? null
        : DateTime.parse(json['registerDate'] as String),
    input: json['input'] as int,
    bank: json['bank'] as String,
    remain: json['remain'] as int,
    name: json['name'] as String,
    transferDate: json['transferDate'] as String,
    content: json['content'] as String,
    status: _$enumDecodeNullable(_$VBankStatusEnumMap, json['status']),
    idxOrder: json['idxOrder'] as int,
  );
}

Map<String, dynamic> _$VBankToJson(VBank instance) => <String, dynamic>{
      'idx': instance.idx,
      'registerDate': instance.registerDate?.toIso8601String(),
      'input': instance.input,
      'bank': instance.bank,
      'remain': instance.remain,
      'name': instance.name,
      'transferDate': instance.transferDate,
      'content': instance.content,
      'status': _$VBankStatusEnumMap[instance.status],
      'idxOrder': instance.idxOrder,
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

const _$VBankStatusEnumMap = {
  VBankStatus.READY: 'READY',
  VBankStatus.SUCCESS: 'SUCCESS',
  VBankStatus.FAIL_SAME_NAME: 'FAIL_SAME_NAME',
  VBankStatus.FAIL_UNKNOWN_NAME: 'FAIL_UNKNOWN_NAME',
};
