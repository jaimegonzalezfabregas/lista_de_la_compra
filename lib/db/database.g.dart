// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => Uuid().v7(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recipe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final String id;
  final String name;
  const Recipe({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(id: Value(id), name: Value(name));
  }

  factory Recipe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Recipe copyWith({String? id, String? name}) =>
      Recipe(id: id ?? this.id, name: name ?? this.name);
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe && other.id == this.id && other.name == this.name);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Recipe> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduleTable extends Schedule
    with TableInfo<$ScheduleTable, ScheduleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => Uuid().v7(),
  );
  static const VerificationMeta _weekMeta = const VerificationMeta('week');
  @override
  late final GeneratedColumn<int> week = GeneratedColumn<int>(
    'week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, week, day, recipeId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('week')) {
      context.handle(
        _weekMeta,
        week.isAcceptableOrUnknown(data['week']!, _weekMeta),
      );
    } else if (isInserting) {
      context.missing(_weekMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      week:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}week'],
          )!,
      day:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}day'],
          )!,
      recipeId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}recipe_id'],
          )!,
    );
  }

  @override
  $ScheduleTable createAlias(String alias) {
    return $ScheduleTable(attachedDatabase, alias);
  }
}

class ScheduleData extends DataClass implements Insertable<ScheduleData> {
  final String id;
  final int week;
  final int day;
  final String recipeId;
  const ScheduleData({
    required this.id,
    required this.week,
    required this.day,
    required this.recipeId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['week'] = Variable<int>(week);
    map['day'] = Variable<int>(day);
    map['recipe_id'] = Variable<String>(recipeId);
    return map;
  }

  ScheduleCompanion toCompanion(bool nullToAbsent) {
    return ScheduleCompanion(
      id: Value(id),
      week: Value(week),
      day: Value(day),
      recipeId: Value(recipeId),
    );
  }

  factory ScheduleData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleData(
      id: serializer.fromJson<String>(json['id']),
      week: serializer.fromJson<int>(json['week']),
      day: serializer.fromJson<int>(json['day']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'week': serializer.toJson<int>(week),
      'day': serializer.toJson<int>(day),
      'recipeId': serializer.toJson<String>(recipeId),
    };
  }

  ScheduleData copyWith({String? id, int? week, int? day, String? recipeId}) =>
      ScheduleData(
        id: id ?? this.id,
        week: week ?? this.week,
        day: day ?? this.day,
        recipeId: recipeId ?? this.recipeId,
      );
  ScheduleData copyWithCompanion(ScheduleCompanion data) {
    return ScheduleData(
      id: data.id.present ? data.id.value : this.id,
      week: data.week.present ? data.week.value : this.week,
      day: data.day.present ? data.day.value : this.day,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleData(')
          ..write('id: $id, ')
          ..write('week: $week, ')
          ..write('day: $day, ')
          ..write('recipeId: $recipeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, week, day, recipeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleData &&
          other.id == this.id &&
          other.week == this.week &&
          other.day == this.day &&
          other.recipeId == this.recipeId);
}

class ScheduleCompanion extends UpdateCompanion<ScheduleData> {
  final Value<String> id;
  final Value<int> week;
  final Value<int> day;
  final Value<String> recipeId;
  final Value<int> rowid;
  const ScheduleCompanion({
    this.id = const Value.absent(),
    this.week = const Value.absent(),
    this.day = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduleCompanion.insert({
    this.id = const Value.absent(),
    required int week,
    required int day,
    required String recipeId,
    this.rowid = const Value.absent(),
  }) : week = Value(week),
       day = Value(day),
       recipeId = Value(recipeId);
  static Insertable<ScheduleData> custom({
    Expression<String>? id,
    Expression<int>? week,
    Expression<int>? day,
    Expression<String>? recipeId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (week != null) 'week': week,
      if (day != null) 'day': day,
      if (recipeId != null) 'recipe_id': recipeId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduleCompanion copyWith({
    Value<String>? id,
    Value<int>? week,
    Value<int>? day,
    Value<String>? recipeId,
    Value<int>? rowid,
  }) {
    return ScheduleCompanion(
      id: id ?? this.id,
      week: week ?? this.week,
      day: day ?? this.day,
      recipeId: recipeId ?? this.recipeId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (week.present) {
      map['week'] = Variable<int>(week.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleCompanion(')
          ..write('id: $id, ')
          ..write('week: $week, ')
          ..write('day: $day, ')
          ..write('recipeId: $recipeId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => Uuid().v7(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _neededMeta = const VerificationMeta('needed');
  @override
  late final GeneratedColumn<bool> needed = GeneratedColumn<bool>(
    'needed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needed" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, needed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('needed')) {
      context.handle(
        _neededMeta,
        needed.isAcceptableOrUnknown(data['needed']!, _neededMeta),
      );
    } else if (isInserting) {
      context.missing(_neededMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      needed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}needed'],
          )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String name;
  final bool needed;
  const Product({required this.id, required this.name, required this.needed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['needed'] = Variable<bool>(needed);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      needed: Value(needed),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      needed: serializer.fromJson<bool>(json['needed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'needed': serializer.toJson<bool>(needed),
    };
  }

  Product copyWith({String? id, String? name, bool? needed}) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    needed: needed ?? this.needed,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      needed: data.needed.present ? data.needed.value : this.needed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('needed: $needed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, needed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.needed == this.needed);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> needed;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.needed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required bool needed,
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       needed = Value(needed);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? needed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (needed != null) 'needed': needed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<bool>? needed,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      needed: needed ?? this.needed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (needed.present) {
      map['needed'] = Variable<bool>(needed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('needed: $needed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeProductsTable extends RecipeProducts
    with TableInfo<$RecipeProductsTable, RecipeProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [recipeId, productId, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recipeId, productId};
  @override
  RecipeProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeProduct(
      recipeId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}recipe_id'],
          )!,
      productId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}product_id'],
          )!,
      amount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}amount'],
          )!,
    );
  }

  @override
  $RecipeProductsTable createAlias(String alias) {
    return $RecipeProductsTable(attachedDatabase, alias);
  }
}

class RecipeProduct extends DataClass implements Insertable<RecipeProduct> {
  final String recipeId;
  final String productId;
  final String amount;
  const RecipeProduct({
    required this.recipeId,
    required this.productId,
    required this.amount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['recipe_id'] = Variable<String>(recipeId);
    map['product_id'] = Variable<String>(productId);
    map['amount'] = Variable<String>(amount);
    return map;
  }

  RecipeProductsCompanion toCompanion(bool nullToAbsent) {
    return RecipeProductsCompanion(
      recipeId: Value(recipeId),
      productId: Value(productId),
      amount: Value(amount),
    );
  }

  factory RecipeProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeProduct(
      recipeId: serializer.fromJson<String>(json['recipeId']),
      productId: serializer.fromJson<String>(json['productId']),
      amount: serializer.fromJson<String>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recipeId': serializer.toJson<String>(recipeId),
      'productId': serializer.toJson<String>(productId),
      'amount': serializer.toJson<String>(amount),
    };
  }

  RecipeProduct copyWith({
    String? recipeId,
    String? productId,
    String? amount,
  }) => RecipeProduct(
    recipeId: recipeId ?? this.recipeId,
    productId: productId ?? this.productId,
    amount: amount ?? this.amount,
  );
  RecipeProduct copyWithCompanion(RecipeProductsCompanion data) {
    return RecipeProduct(
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      productId: data.productId.present ? data.productId.value : this.productId,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeProduct(')
          ..write('recipeId: $recipeId, ')
          ..write('productId: $productId, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(recipeId, productId, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeProduct &&
          other.recipeId == this.recipeId &&
          other.productId == this.productId &&
          other.amount == this.amount);
}

class RecipeProductsCompanion extends UpdateCompanion<RecipeProduct> {
  final Value<String> recipeId;
  final Value<String> productId;
  final Value<String> amount;
  final Value<int> rowid;
  const RecipeProductsCompanion({
    this.recipeId = const Value.absent(),
    this.productId = const Value.absent(),
    this.amount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeProductsCompanion.insert({
    required String recipeId,
    required String productId,
    required String amount,
    this.rowid = const Value.absent(),
  }) : recipeId = Value(recipeId),
       productId = Value(productId),
       amount = Value(amount);
  static Insertable<RecipeProduct> custom({
    Expression<String>? recipeId,
    Expression<String>? productId,
    Expression<String>? amount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recipeId != null) 'recipe_id': recipeId,
      if (productId != null) 'product_id': productId,
      if (amount != null) 'amount': amount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeProductsCompanion copyWith({
    Value<String>? recipeId,
    Value<String>? productId,
    Value<String>? amount,
    Value<int>? rowid,
  }) {
    return RecipeProductsCompanion(
      recipeId: recipeId ?? this.recipeId,
      productId: productId ?? this.productId,
      amount: amount ?? this.amount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeProductsCompanion(')
          ..write('recipeId: $recipeId, ')
          ..write('productId: $productId, ')
          ..write('amount: $amount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $ScheduleTable schedule = $ScheduleTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $RecipeProductsTable recipeProducts = $RecipeProductsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    recipes,
    schedule,
    products,
    recipeProducts,
  ];
}

typedef $$RecipesTableCreateCompanionBuilder =
    RecipesCompanion Function({
      Value<String> id,
      required String name,
      Value<int> rowid,
    });
typedef $$RecipesTableUpdateCompanionBuilder =
    RecipesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

final class $$RecipesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipesTable, Recipe> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ScheduleTable, List<ScheduleData>>
  _scheduleRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.schedule,
    aliasName: $_aliasNameGenerator(db.recipes.id, db.schedule.recipeId),
  );

  $$ScheduleTableProcessedTableManager get scheduleRefs {
    final manager = $$ScheduleTableTableManager(
      $_db,
      $_db.schedule,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_scheduleRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecipeProductsTable, List<RecipeProduct>>
  _recipeProductsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeProducts,
    aliasName: $_aliasNameGenerator(db.recipes.id, db.recipeProducts.recipeId),
  );

  $$RecipeProductsTableProcessedTableManager get recipeProductsRefs {
    final manager = $$RecipeProductsTableTableManager(
      $_db,
      $_db.recipeProducts,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeProductsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> scheduleRefs(
    Expression<bool> Function($$ScheduleTableFilterComposer f) f,
  ) {
    final $$ScheduleTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.schedule,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleTableFilterComposer(
            $db: $db,
            $table: $db.schedule,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recipeProductsRefs(
    Expression<bool> Function($$RecipeProductsTableFilterComposer f) f,
  ) {
    final $$RecipeProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeProducts,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeProductsTableFilterComposer(
            $db: $db,
            $table: $db.recipeProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> scheduleRefs<T extends Object>(
    Expression<T> Function($$ScheduleTableAnnotationComposer a) f,
  ) {
    final $$ScheduleTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.schedule,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleTableAnnotationComposer(
            $db: $db,
            $table: $db.schedule,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recipeProductsRefs<T extends Object>(
    Expression<T> Function($$RecipeProductsTableAnnotationComposer a) f,
  ) {
    final $$RecipeProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeProducts,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          Recipe,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (Recipe, $$RecipesTableReferences),
          Recipe,
          PrefetchHooks Function({bool scheduleRefs, bool recipeProductsRefs})
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$RecipesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            scheduleRefs = false,
            recipeProductsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (scheduleRefs) db.schedule,
                if (recipeProductsRefs) db.recipeProducts,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (scheduleRefs)
                    await $_getPrefetchedData<
                      Recipe,
                      $RecipesTable,
                      ScheduleData
                    >(
                      currentTable: table,
                      referencedTable: $$RecipesTableReferences
                          ._scheduleRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).scheduleRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.recipeId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (recipeProductsRefs)
                    await $_getPrefetchedData<
                      Recipe,
                      $RecipesTable,
                      RecipeProduct
                    >(
                      currentTable: table,
                      referencedTable: $$RecipesTableReferences
                          ._recipeProductsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeProductsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.recipeId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      Recipe,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (Recipe, $$RecipesTableReferences),
      Recipe,
      PrefetchHooks Function({bool scheduleRefs, bool recipeProductsRefs})
    >;
typedef $$ScheduleTableCreateCompanionBuilder =
    ScheduleCompanion Function({
      Value<String> id,
      required int week,
      required int day,
      required String recipeId,
      Value<int> rowid,
    });
typedef $$ScheduleTableUpdateCompanionBuilder =
    ScheduleCompanion Function({
      Value<String> id,
      Value<int> week,
      Value<int> day,
      Value<String> recipeId,
      Value<int> rowid,
    });

final class $$ScheduleTableReferences
    extends BaseReferences<_$AppDatabase, $ScheduleTable, ScheduleData> {
  $$ScheduleTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) => db.recipes
      .createAlias($_aliasNameGenerator(db.schedule.recipeId, db.recipes.id));

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<String>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScheduleTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduleTable> {
  $$ScheduleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get week => $composableBuilder(
    column: $table.week,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduleTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduleTable> {
  $$ScheduleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get week => $composableBuilder(
    column: $table.week,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduleTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduleTable> {
  $$ScheduleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get week =>
      $composableBuilder(column: $table.week, builder: (column) => column);

  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduleTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduleTable,
          ScheduleData,
          $$ScheduleTableFilterComposer,
          $$ScheduleTableOrderingComposer,
          $$ScheduleTableAnnotationComposer,
          $$ScheduleTableCreateCompanionBuilder,
          $$ScheduleTableUpdateCompanionBuilder,
          (ScheduleData, $$ScheduleTableReferences),
          ScheduleData,
          PrefetchHooks Function({bool recipeId})
        > {
  $$ScheduleTableTableManager(_$AppDatabase db, $ScheduleTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ScheduleTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ScheduleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ScheduleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> week = const Value.absent(),
                Value<int> day = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduleCompanion(
                id: id,
                week: week,
                day: day,
                recipeId: recipeId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required int week,
                required int day,
                required String recipeId,
                Value<int> rowid = const Value.absent(),
              }) => ScheduleCompanion.insert(
                id: id,
                week: week,
                day: day,
                recipeId: recipeId,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ScheduleTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (recipeId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.recipeId,
                            referencedTable: $$ScheduleTableReferences
                                ._recipeIdTable(db),
                            referencedColumn:
                                $$ScheduleTableReferences._recipeIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScheduleTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduleTable,
      ScheduleData,
      $$ScheduleTableFilterComposer,
      $$ScheduleTableOrderingComposer,
      $$ScheduleTableAnnotationComposer,
      $$ScheduleTableCreateCompanionBuilder,
      $$ScheduleTableUpdateCompanionBuilder,
      (ScheduleData, $$ScheduleTableReferences),
      ScheduleData,
      PrefetchHooks Function({bool recipeId})
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      required String name,
      required bool needed,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<bool> needed,
      Value<int> rowid,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeProductsTable, List<RecipeProduct>>
  _recipeProductsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeProducts,
    aliasName: $_aliasNameGenerator(
      db.products.id,
      db.recipeProducts.productId,
    ),
  );

  $$RecipeProductsTableProcessedTableManager get recipeProductsRefs {
    final manager = $$RecipeProductsTableTableManager(
      $_db,
      $_db.recipeProducts,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeProductsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needed => $composableBuilder(
    column: $table.needed,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recipeProductsRefs(
    Expression<bool> Function($$RecipeProductsTableFilterComposer f) f,
  ) {
    final $$RecipeProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeProducts,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeProductsTableFilterComposer(
            $db: $db,
            $table: $db.recipeProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needed => $composableBuilder(
    column: $table.needed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get needed =>
      $composableBuilder(column: $table.needed, builder: (column) => column);

  Expression<T> recipeProductsRefs<T extends Object>(
    Expression<T> Function($$RecipeProductsTableAnnotationComposer a) f,
  ) {
    final $$RecipeProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeProducts,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({bool recipeProductsRefs})
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> needed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                needed: needed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                required bool needed,
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                needed: needed,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ProductsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({recipeProductsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recipeProductsRefs) db.recipeProducts,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recipeProductsRefs)
                    await $_getPrefetchedData<
                      Product,
                      $ProductsTable,
                      RecipeProduct
                    >(
                      currentTable: table,
                      referencedTable: $$ProductsTableReferences
                          ._recipeProductsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeProductsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.productId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({bool recipeProductsRefs})
    >;
typedef $$RecipeProductsTableCreateCompanionBuilder =
    RecipeProductsCompanion Function({
      required String recipeId,
      required String productId,
      required String amount,
      Value<int> rowid,
    });
typedef $$RecipeProductsTableUpdateCompanionBuilder =
    RecipeProductsCompanion Function({
      Value<String> recipeId,
      Value<String> productId,
      Value<String> amount,
      Value<int> rowid,
    });

final class $$RecipeProductsTableReferences
    extends BaseReferences<_$AppDatabase, $RecipeProductsTable, RecipeProduct> {
  $$RecipeProductsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias(
        $_aliasNameGenerator(db.recipeProducts.recipeId, db.recipes.id),
      );

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<String>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.recipeProducts.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeProductsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeProductsTable> {
  $$RecipeProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeProductsTable> {
  $$RecipeProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeProductsTable> {
  $$RecipeProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeProductsTable,
          RecipeProduct,
          $$RecipeProductsTableFilterComposer,
          $$RecipeProductsTableOrderingComposer,
          $$RecipeProductsTableAnnotationComposer,
          $$RecipeProductsTableCreateCompanionBuilder,
          $$RecipeProductsTableUpdateCompanionBuilder,
          (RecipeProduct, $$RecipeProductsTableReferences),
          RecipeProduct,
          PrefetchHooks Function({bool recipeId, bool productId})
        > {
  $$RecipeProductsTableTableManager(
    _$AppDatabase db,
    $RecipeProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$RecipeProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$RecipeProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$RecipeProductsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> recipeId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> amount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeProductsCompanion(
                recipeId: recipeId,
                productId: productId,
                amount: amount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String recipeId,
                required String productId,
                required String amount,
                Value<int> rowid = const Value.absent(),
              }) => RecipeProductsCompanion.insert(
                recipeId: recipeId,
                productId: productId,
                amount: amount,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$RecipeProductsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({recipeId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (recipeId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.recipeId,
                            referencedTable: $$RecipeProductsTableReferences
                                ._recipeIdTable(db),
                            referencedColumn:
                                $$RecipeProductsTableReferences
                                    ._recipeIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (productId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.productId,
                            referencedTable: $$RecipeProductsTableReferences
                                ._productIdTable(db),
                            referencedColumn:
                                $$RecipeProductsTableReferences
                                    ._productIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecipeProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeProductsTable,
      RecipeProduct,
      $$RecipeProductsTableFilterComposer,
      $$RecipeProductsTableOrderingComposer,
      $$RecipeProductsTableAnnotationComposer,
      $$RecipeProductsTableCreateCompanionBuilder,
      $$RecipeProductsTableUpdateCompanionBuilder,
      (RecipeProduct, $$RecipeProductsTableReferences),
      RecipeProduct,
      PrefetchHooks Function({bool recipeId, bool productId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$ScheduleTableTableManager get schedule =>
      $$ScheduleTableTableManager(_db, _db.schedule);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$RecipeProductsTableTableManager get recipeProducts =>
      $$RecipeProductsTableTableManager(_db, _db.recipeProducts);
}
