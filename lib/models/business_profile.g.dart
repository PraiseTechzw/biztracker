// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBusinessProfileCollection on Isar {
  IsarCollection<BusinessProfile> get businessProfiles => this.collection();
}

const BusinessProfileSchema = CollectionSchema(
  name: r'BusinessProfile',
  id: 8791508697407836855,
  properties: {
    r'address': PropertySchema(
      id: 0,
      name: r'address',
      type: IsarType.string,
    ),
    r'bannerPath': PropertySchema(
      id: 1,
      name: r'bannerPath',
      type: IsarType.string,
    ),
    r'businessDescription': PropertySchema(
      id: 2,
      name: r'businessDescription',
      type: IsarType.string,
    ),
    r'businessName': PropertySchema(
      id: 3,
      name: r'businessName',
      type: IsarType.string,
    ),
    r'businessType': PropertySchema(
      id: 4,
      name: r'businessType',
      type: IsarType.string,
    ),
    r'city': PropertySchema(
      id: 5,
      name: r'city',
      type: IsarType.string,
    ),
    r'country': PropertySchema(
      id: 6,
      name: r'country',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 7,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'currency': PropertySchema(
      id: 8,
      name: r'currency',
      type: IsarType.string,
    ),
    r'displayName': PropertySchema(
      id: 9,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'email': PropertySchema(
      id: 10,
      name: r'email',
      type: IsarType.string,
    ),
    r'fullAddress': PropertySchema(
      id: 11,
      name: r'fullAddress',
      type: IsarType.string,
    ),
    r'hasShownFirstSaleAchievement': PropertySchema(
      id: 12,
      name: r'hasShownFirstSaleAchievement',
      type: IsarType.bool,
    ),
    r'hasShownProfitMilestoneAchievement': PropertySchema(
      id: 13,
      name: r'hasShownProfitMilestoneAchievement',
      type: IsarType.bool,
    ),
    r'industry': PropertySchema(
      id: 14,
      name: r'industry',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 15,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'isProfileComplete': PropertySchema(
      id: 16,
      name: r'isProfileComplete',
      type: IsarType.bool,
    ),
    r'logoPath': PropertySchema(
      id: 17,
      name: r'logoPath',
      type: IsarType.string,
    ),
    r'ownerEmail': PropertySchema(
      id: 18,
      name: r'ownerEmail',
      type: IsarType.string,
    ),
    r'ownerName': PropertySchema(
      id: 19,
      name: r'ownerName',
      type: IsarType.string,
    ),
    r'ownerPhone': PropertySchema(
      id: 20,
      name: r'ownerPhone',
      type: IsarType.string,
    ),
    r'phoneNumber': PropertySchema(
      id: 21,
      name: r'phoneNumber',
      type: IsarType.string,
    ),
    r'postalCode': PropertySchema(
      id: 22,
      name: r'postalCode',
      type: IsarType.string,
    ),
    r'registrationNumber': PropertySchema(
      id: 23,
      name: r'registrationNumber',
      type: IsarType.string,
    ),
    r'state': PropertySchema(
      id: 24,
      name: r'state',
      type: IsarType.string,
    ),
    r'taxId': PropertySchema(
      id: 25,
      name: r'taxId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 26,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'website': PropertySchema(
      id: 27,
      name: r'website',
      type: IsarType.string,
    )
  },
  estimateSize: _businessProfileEstimateSize,
  serialize: _businessProfileSerialize,
  deserialize: _businessProfileDeserialize,
  deserializeProp: _businessProfileDeserializeProp,
  idName: r'id',
  indexes: {
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _businessProfileGetId,
  getLinks: _businessProfileGetLinks,
  attach: _businessProfileAttach,
  version: '3.1.0+1',
);

int _businessProfileEstimateSize(
  BusinessProfile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.address;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.bannerPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.businessDescription;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.businessName.length * 3;
  bytesCount += 3 + object.businessType.length * 3;
  {
    final value = object.city;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.country;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.currency;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.displayName.length * 3;
  {
    final value = object.email;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.fullAddress.length * 3;
  {
    final value = object.industry;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.logoPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ownerEmail;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ownerName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ownerPhone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.phoneNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.postalCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.registrationNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.state;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.taxId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.website;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _businessProfileSerialize(
  BusinessProfile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeString(offsets[1], object.bannerPath);
  writer.writeString(offsets[2], object.businessDescription);
  writer.writeString(offsets[3], object.businessName);
  writer.writeString(offsets[4], object.businessType);
  writer.writeString(offsets[5], object.city);
  writer.writeString(offsets[6], object.country);
  writer.writeDateTime(offsets[7], object.createdAt);
  writer.writeString(offsets[8], object.currency);
  writer.writeString(offsets[9], object.displayName);
  writer.writeString(offsets[10], object.email);
  writer.writeString(offsets[11], object.fullAddress);
  writer.writeBool(offsets[12], object.hasShownFirstSaleAchievement);
  writer.writeBool(offsets[13], object.hasShownProfitMilestoneAchievement);
  writer.writeString(offsets[14], object.industry);
  writer.writeBool(offsets[15], object.isActive);
  writer.writeBool(offsets[16], object.isProfileComplete);
  writer.writeString(offsets[17], object.logoPath);
  writer.writeString(offsets[18], object.ownerEmail);
  writer.writeString(offsets[19], object.ownerName);
  writer.writeString(offsets[20], object.ownerPhone);
  writer.writeString(offsets[21], object.phoneNumber);
  writer.writeString(offsets[22], object.postalCode);
  writer.writeString(offsets[23], object.registrationNumber);
  writer.writeString(offsets[24], object.state);
  writer.writeString(offsets[25], object.taxId);
  writer.writeDateTime(offsets[26], object.updatedAt);
  writer.writeString(offsets[27], object.website);
}

BusinessProfile _businessProfileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BusinessProfile();
  object.address = reader.readStringOrNull(offsets[0]);
  object.bannerPath = reader.readStringOrNull(offsets[1]);
  object.businessDescription = reader.readStringOrNull(offsets[2]);
  object.businessName = reader.readString(offsets[3]);
  object.businessType = reader.readString(offsets[4]);
  object.city = reader.readStringOrNull(offsets[5]);
  object.country = reader.readStringOrNull(offsets[6]);
  object.createdAt = reader.readDateTime(offsets[7]);
  object.currency = reader.readStringOrNull(offsets[8]);
  object.email = reader.readStringOrNull(offsets[10]);
  object.hasShownFirstSaleAchievement = reader.readBool(offsets[12]);
  object.hasShownProfitMilestoneAchievement = reader.readBool(offsets[13]);
  object.id = id;
  object.industry = reader.readStringOrNull(offsets[14]);
  object.isActive = reader.readBool(offsets[15]);
  object.logoPath = reader.readStringOrNull(offsets[17]);
  object.ownerEmail = reader.readStringOrNull(offsets[18]);
  object.ownerName = reader.readStringOrNull(offsets[19]);
  object.ownerPhone = reader.readStringOrNull(offsets[20]);
  object.phoneNumber = reader.readStringOrNull(offsets[21]);
  object.postalCode = reader.readStringOrNull(offsets[22]);
  object.registrationNumber = reader.readStringOrNull(offsets[23]);
  object.state = reader.readStringOrNull(offsets[24]);
  object.taxId = reader.readStringOrNull(offsets[25]);
  object.updatedAt = reader.readDateTime(offsets[26]);
  object.website = reader.readStringOrNull(offsets[27]);
  return object;
}

P _businessProfileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readDateTime(offset)) as P;
    case 27:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _businessProfileGetId(BusinessProfile object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _businessProfileGetLinks(BusinessProfile object) {
  return [];
}

void _businessProfileAttach(
    IsarCollection<dynamic> col, Id id, BusinessProfile object) {
  object.id = id;
}

extension BusinessProfileQueryWhereSort
    on QueryBuilder<BusinessProfile, BusinessProfile, QWhere> {
  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension BusinessProfileQueryWhere
    on QueryBuilder<BusinessProfile, BusinessProfile, QWhereClause> {
  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhereClause>
      createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhereClause>
      createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhereClause>
      createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhereClause>
      createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhereClause>
      updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhereClause>
      updatedAtNotEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhereClause>
      updatedAtGreaterThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [updatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhereClause>
      updatedAtLessThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [],
        upper: [updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterWhereClause>
      updatedAtBetween(
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [lowerUpdatedAt],
        includeLower: includeLower,
        upper: [upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BusinessProfileQueryFilter
    on QueryBuilder<BusinessProfile, BusinessProfile, QFilterCondition> {
  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      addressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      addressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      addressEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      addressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      addressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      addressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'address',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      addressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      addressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      addressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      addressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'address',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      bannerPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bannerPath',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      bannerPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bannerPath',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      bannerPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bannerPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      bannerPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bannerPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      bannerPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bannerPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      bannerPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bannerPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      bannerPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bannerPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      bannerPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bannerPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      bannerPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bannerPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      bannerPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bannerPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      bannerPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bannerPath',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      bannerPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bannerPath',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessDescriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'businessDescription',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessDescriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'businessDescription',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessDescriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessDescriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'businessDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessDescriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'businessDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessDescriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'businessDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'businessDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'businessDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'businessDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'businessDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'businessDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'businessName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'businessName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessName',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'businessName',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'businessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'businessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'businessType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'businessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'businessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'businessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'businessType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessType',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      businessTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'businessType',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      cityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'city',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      cityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'city',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      cityEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      cityGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      cityLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      cityBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'city',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      cityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      cityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      cityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      cityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'city',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      countryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'country',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      countryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'country',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      countryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      countryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      countryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      countryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'country',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      countryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      countryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      countryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      countryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'country',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      countryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'country',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      countryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'country',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      currencyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currency',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      currencyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currency',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      currencyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      currencyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      currencyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      currencyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      currencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      currencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      currencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      currencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      currencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      currencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      displayNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      displayNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      displayNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      emailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      emailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      emailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      emailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      emailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      emailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      fullAddressEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      fullAddressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fullAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      fullAddressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fullAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      fullAddressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fullAddress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      fullAddressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fullAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      fullAddressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fullAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      fullAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fullAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      fullAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fullAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      fullAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      fullAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fullAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      hasShownFirstSaleAchievementEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasShownFirstSaleAchievement',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      hasShownProfitMilestoneAchievementEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasShownProfitMilestoneAchievement',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      industryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'industry',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      industryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'industry',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      industryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'industry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      industryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'industry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      industryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'industry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      industryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'industry',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      industryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'industry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      industryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'industry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      industryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'industry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      industryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'industry',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      industryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'industry',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      industryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'industry',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      isProfileCompleteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isProfileComplete',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      logoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'logoPath',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      logoPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'logoPath',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      logoPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      logoPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      logoPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      logoPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'logoPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      logoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      logoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      logoPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      logoPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'logoPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      logoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      logoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'logoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerEmailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ownerEmail',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerEmailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ownerEmail',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerEmailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerEmailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerEmailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerEmailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerEmail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerEmailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ownerEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerEmailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ownerEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerEmailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ownerEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerEmailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ownerEmail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerEmailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerEmailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ownerEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ownerName',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ownerName',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ownerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerName',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ownerName',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerPhoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ownerPhone',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerPhoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ownerPhone',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerPhoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerPhoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerPhoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerPhoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerPhone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerPhoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ownerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerPhoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ownerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerPhoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ownerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerPhoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ownerPhone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      ownerPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ownerPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      phoneNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phoneNumber',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      phoneNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phoneNumber',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      phoneNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      phoneNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      phoneNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      phoneNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phoneNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      phoneNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      phoneNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      phoneNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      phoneNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phoneNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      phoneNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phoneNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      phoneNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phoneNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      postalCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'postalCode',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      postalCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'postalCode',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      postalCodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'postalCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      postalCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'postalCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      postalCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'postalCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      postalCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'postalCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      postalCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'postalCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      postalCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'postalCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      postalCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'postalCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      postalCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'postalCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      postalCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'postalCode',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      postalCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'postalCode',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      registrationNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'registrationNumber',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      registrationNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'registrationNumber',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      registrationNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      registrationNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      registrationNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      registrationNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'registrationNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      registrationNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      registrationNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      registrationNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      registrationNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'registrationNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      registrationNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'registrationNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      registrationNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'registrationNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      stateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'state',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      stateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'state',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      stateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      stateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      stateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      stateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'state',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      stateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      stateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      stateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      stateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'state',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      stateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      stateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      taxIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxId',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      taxIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxId',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      taxIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      taxIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      taxIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      taxIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      taxIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      taxIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      taxIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      taxIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taxId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      taxIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxId',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      taxIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taxId',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      websiteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'website',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      websiteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'website',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      websiteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'website',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      websiteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'website',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      websiteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'website',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      websiteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'website',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      websiteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'website',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      websiteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'website',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      websiteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'website',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      websiteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'website',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      websiteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'website',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterFilterCondition>
      websiteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'website',
        value: '',
      ));
    });
  }
}

extension BusinessProfileQueryObject
    on QueryBuilder<BusinessProfile, BusinessProfile, QFilterCondition> {}

extension BusinessProfileQueryLinks
    on QueryBuilder<BusinessProfile, BusinessProfile, QFilterCondition> {}

extension BusinessProfileQuerySortBy
    on QueryBuilder<BusinessProfile, BusinessProfile, QSortBy> {
  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByBannerPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerPath', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByBannerPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerPath', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByBusinessDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessDescription', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByBusinessDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessDescription', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByBusinessName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByBusinessNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByBusinessType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessType', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByBusinessTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessType', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> sortByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> sortByCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByFullAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullAddress', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByFullAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullAddress', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByHasShownFirstSaleAchievement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasShownFirstSaleAchievement', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByHasShownFirstSaleAchievementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasShownFirstSaleAchievement', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByHasShownProfitMilestoneAchievement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasShownProfitMilestoneAchievement', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByHasShownProfitMilestoneAchievementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasShownProfitMilestoneAchievement', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByIndustry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'industry', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByIndustryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'industry', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByIsProfileComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProfileComplete', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByIsProfileCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProfileComplete', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByOwnerEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerEmail', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByOwnerEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerEmail', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByOwnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByOwnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByOwnerPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerPhone', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByOwnerPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerPhone', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByPhoneNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByPhoneNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByPostalCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postalCode', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByPostalCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postalCode', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByRegistrationNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByRegistrationNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> sortByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> sortByTaxId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxId', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByTaxIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxId', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> sortByWebsite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'website', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      sortByWebsiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'website', Sort.desc);
    });
  }
}

extension BusinessProfileQuerySortThenBy
    on QueryBuilder<BusinessProfile, BusinessProfile, QSortThenBy> {
  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByBannerPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerPath', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByBannerPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerPath', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByBusinessDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessDescription', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByBusinessDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessDescription', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByBusinessName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByBusinessNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByBusinessType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessType', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByBusinessTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessType', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> thenByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> thenByCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByFullAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullAddress', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByFullAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullAddress', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByHasShownFirstSaleAchievement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasShownFirstSaleAchievement', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByHasShownFirstSaleAchievementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasShownFirstSaleAchievement', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByHasShownProfitMilestoneAchievement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasShownProfitMilestoneAchievement', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByHasShownProfitMilestoneAchievementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasShownProfitMilestoneAchievement', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByIndustry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'industry', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByIndustryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'industry', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByIsProfileComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProfileComplete', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByIsProfileCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProfileComplete', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByOwnerEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerEmail', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByOwnerEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerEmail', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByOwnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByOwnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByOwnerPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerPhone', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByOwnerPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerPhone', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByPhoneNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByPhoneNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByPostalCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postalCode', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByPostalCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postalCode', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByRegistrationNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByRegistrationNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> thenByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> thenByTaxId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxId', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByTaxIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxId', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy> thenByWebsite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'website', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QAfterSortBy>
      thenByWebsiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'website', Sort.desc);
    });
  }
}

extension BusinessProfileQueryWhereDistinct
    on QueryBuilder<BusinessProfile, BusinessProfile, QDistinct> {
  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByBannerPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bannerPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByBusinessDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'businessDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByBusinessName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'businessName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByBusinessType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'businessType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct> distinctByCity(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'city', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct> distinctByCountry(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'country', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct> distinctByCurrency(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByFullAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullAddress', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByHasShownFirstSaleAchievement() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasShownFirstSaleAchievement');
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByHasShownProfitMilestoneAchievement() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasShownProfitMilestoneAchievement');
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct> distinctByIndustry(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'industry', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByIsProfileComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isProfileComplete');
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct> distinctByLogoPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logoPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByOwnerEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerEmail', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct> distinctByOwnerName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByOwnerPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerPhone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByPhoneNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phoneNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByPostalCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'postalCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByRegistrationNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'registrationNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct> distinctByState(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'state', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct> distinctByTaxId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<BusinessProfile, BusinessProfile, QDistinct> distinctByWebsite(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'website', caseSensitive: caseSensitive);
    });
  }
}

extension BusinessProfileQueryProperty
    on QueryBuilder<BusinessProfile, BusinessProfile, QQueryProperty> {
  QueryBuilder<BusinessProfile, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations>
      bannerPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bannerPath');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations>
      businessDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessDescription');
    });
  }

  QueryBuilder<BusinessProfile, String, QQueryOperations>
      businessNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessName');
    });
  }

  QueryBuilder<BusinessProfile, String, QQueryOperations>
      businessTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessType');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations> cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'city');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations> countryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'country');
    });
  }

  QueryBuilder<BusinessProfile, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations> currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<BusinessProfile, String, QQueryOperations>
      displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<BusinessProfile, String, QQueryOperations>
      fullAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullAddress');
    });
  }

  QueryBuilder<BusinessProfile, bool, QQueryOperations>
      hasShownFirstSaleAchievementProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasShownFirstSaleAchievement');
    });
  }

  QueryBuilder<BusinessProfile, bool, QQueryOperations>
      hasShownProfitMilestoneAchievementProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasShownProfitMilestoneAchievement');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations> industryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'industry');
    });
  }

  QueryBuilder<BusinessProfile, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<BusinessProfile, bool, QQueryOperations>
      isProfileCompleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isProfileComplete');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations> logoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logoPath');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations>
      ownerEmailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerEmail');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations> ownerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerName');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations>
      ownerPhoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerPhone');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations>
      phoneNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phoneNumber');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations>
      postalCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'postalCode');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations>
      registrationNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'registrationNumber');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations> stateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'state');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations> taxIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxId');
    });
  }

  QueryBuilder<BusinessProfile, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<BusinessProfile, String?, QQueryOperations> websiteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'website');
    });
  }
}
