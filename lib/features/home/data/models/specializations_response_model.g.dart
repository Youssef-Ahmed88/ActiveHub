// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specializations_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecializationsResponseModel _$SpecializationsResponseModelFromJson(
  Map<String, dynamic> json,
) => SpecializationsResponseModel(
  specializationDataList: (json['data'] as List<dynamic>?)
      ?.map(
        (e) => e == null
            ? null
            : SpecializationsData.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$SpecializationsResponseModelToJson(
  SpecializationsResponseModel instance,
) => <String, dynamic>{'data': instance.specializationDataList};

SpecializationsData _$SpecializationsDataFromJson(Map<String, dynamic> json) =>
    SpecializationsData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      doctorsList: (json['venues'] as List<dynamic>?)
          ?.map(
            (e) =>
                e == null ? null : Doctors.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$SpecializationsDataToJson(
  SpecializationsData instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'venues': instance.doctorsList,
};

Doctors _$DoctorsFromJson(Map<String, dynamic> json) => Doctors(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  photo: json['photo'] as String?,
  gender: json['sport_type'] as String?,
  price: (json['price_per_hour'] as num?)?.toInt(),
  degree: json['location'] as String,
);

Map<String, dynamic> _$DoctorsToJson(Doctors instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'photo': instance.photo,
  'sport_type': instance.gender,
  'price_per_hour': instance.price,
  'location': instance.degree,
};
