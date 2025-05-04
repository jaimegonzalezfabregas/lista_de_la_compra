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

class $ScheduleEntriesTable extends ScheduleEntries
    with TableInfo<$ScheduleEntriesTable, ScheduleEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'schedule_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleEntry> instance, {
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
  ScheduleEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleEntry(
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
  $ScheduleEntriesTable createAlias(String alias) {
    return $ScheduleEntriesTable(attachedDatabase, alias);
  }
}

class ScheduleEntry extends DataClass implements Insertable<ScheduleEntry> {
  final String id;
  final int week;
  final int day;
  final String recipeId;
  const ScheduleEntry({
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

  ScheduleEntriesCompanion toCompanion(bool nullToAbsent) {
    return ScheduleEntriesCompanion(
      id: Value(id),
      week: Value(week),
      day: Value(day),
      recipeId: Value(recipeId),
    );
  }

  factory ScheduleEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleEntry(
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

  ScheduleEntry copyWith({String? id, int? week, int? day, String? recipeId}) =>
      ScheduleEntry(
        id: id ?? this.id,
        week: week ?? this.week,
        day: day ?? this.day,
        recipeId: recipeId ?? this.recipeId,
      );
  ScheduleEntry copyWithCompanion(ScheduleEntriesCompanion data) {
    return ScheduleEntry(
      id: data.id.present ? data.id.value : this.id,
      week: data.week.present ? data.week.value : this.week,
      day: data.day.present ? data.day.value : this.day,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleEntry(')
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
      (other is ScheduleEntry &&
          other.id == this.id &&
          other.week == this.week &&
          other.day == this.day &&
          other.recipeId == this.recipeId);
}

class ScheduleEntriesCompanion extends UpdateCompanion<ScheduleEntry> {
  final Value<String> id;
  final Value<int> week;
  final Value<int> day;
  final Value<String> recipeId;
  final Value<int> rowid;
  const ScheduleEntriesCompanion({
    this.id = const Value.absent(),
    this.week = const Value.absent(),
    this.day = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduleEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int week,
    required int day,
    required String recipeId,
    this.rowid = const Value.absent(),
  }) : week = Value(week),
       day = Value(day),
       recipeId = Value(recipeId);
  static Insertable<ScheduleEntry> custom({
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

  ScheduleEntriesCompanion copyWith({
    Value<String>? id,
    Value<int>? week,
    Value<int>? day,
    Value<String>? recipeId,
    Value<int>? rowid,
  }) {
    return ScheduleEntriesCompanion(
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
    return (StringBuffer('ScheduleEntriesCompanion(')
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

class $HttpServerPairingsTable extends HttpServerPairings
    with TableInfo<$HttpServerPairingsTable, HttpServerPairing> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HttpServerPairingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nickMeta = const VerificationMeta('nick');
  @override
  late final GeneratedColumn<String> nick = GeneratedColumn<String>(
    'nick',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hostMeta = const VerificationMeta('host');
  @override
  late final GeneratedColumn<String> host = GeneratedColumn<String>(
    'host',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    clientDefault: () => 4545,
  );
  static const VerificationMeta _lastSyncMeta = const VerificationMeta(
    'lastSync',
  );
  @override
  late final GeneratedColumn<String> lastSync = GeneratedColumn<String>(
    'last_sync',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nick, host, port, lastSync, token];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'http_server_pairings';
  @override
  VerificationContext validateIntegrity(
    Insertable<HttpServerPairing> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nick')) {
      context.handle(
        _nickMeta,
        nick.isAcceptableOrUnknown(data['nick']!, _nickMeta),
      );
    } else if (isInserting) {
      context.missing(_nickMeta);
    }
    if (data.containsKey('host')) {
      context.handle(
        _hostMeta,
        host.isAcceptableOrUnknown(data['host']!, _hostMeta),
      );
    } else if (isInserting) {
      context.missing(_hostMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    }
    if (data.containsKey('last_sync')) {
      context.handle(
        _lastSyncMeta,
        lastSync.isAcceptableOrUnknown(data['last_sync']!, _lastSyncMeta),
      );
    } else if (isInserting) {
      context.missing(_lastSyncMeta);
    }
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HttpServerPairing map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HttpServerPairing(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      nick:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}nick'],
          )!,
      host:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}host'],
          )!,
      port:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}port'],
          )!,
      lastSync:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}last_sync'],
          )!,
      token:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}token'],
          )!,
    );
  }

  @override
  $HttpServerPairingsTable createAlias(String alias) {
    return $HttpServerPairingsTable(attachedDatabase, alias);
  }
}

class HttpServerPairing extends DataClass
    implements Insertable<HttpServerPairing> {
  final String id;
  final String nick;
  final String host;
  final int port;
  final String lastSync;
  final String token;
  const HttpServerPairing({
    required this.id,
    required this.nick,
    required this.host,
    required this.port,
    required this.lastSync,
    required this.token,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nick'] = Variable<String>(nick);
    map['host'] = Variable<String>(host);
    map['port'] = Variable<int>(port);
    map['last_sync'] = Variable<String>(lastSync);
    map['token'] = Variable<String>(token);
    return map;
  }

  HttpServerPairingsCompanion toCompanion(bool nullToAbsent) {
    return HttpServerPairingsCompanion(
      id: Value(id),
      nick: Value(nick),
      host: Value(host),
      port: Value(port),
      lastSync: Value(lastSync),
      token: Value(token),
    );
  }

  factory HttpServerPairing.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HttpServerPairing(
      id: serializer.fromJson<String>(json['id']),
      nick: serializer.fromJson<String>(json['nick']),
      host: serializer.fromJson<String>(json['host']),
      port: serializer.fromJson<int>(json['port']),
      lastSync: serializer.fromJson<String>(json['lastSync']),
      token: serializer.fromJson<String>(json['token']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nick': serializer.toJson<String>(nick),
      'host': serializer.toJson<String>(host),
      'port': serializer.toJson<int>(port),
      'lastSync': serializer.toJson<String>(lastSync),
      'token': serializer.toJson<String>(token),
    };
  }

  HttpServerPairing copyWith({
    String? id,
    String? nick,
    String? host,
    int? port,
    String? lastSync,
    String? token,
  }) => HttpServerPairing(
    id: id ?? this.id,
    nick: nick ?? this.nick,
    host: host ?? this.host,
    port: port ?? this.port,
    lastSync: lastSync ?? this.lastSync,
    token: token ?? this.token,
  );
  HttpServerPairing copyWithCompanion(HttpServerPairingsCompanion data) {
    return HttpServerPairing(
      id: data.id.present ? data.id.value : this.id,
      nick: data.nick.present ? data.nick.value : this.nick,
      host: data.host.present ? data.host.value : this.host,
      port: data.port.present ? data.port.value : this.port,
      lastSync: data.lastSync.present ? data.lastSync.value : this.lastSync,
      token: data.token.present ? data.token.value : this.token,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HttpServerPairing(')
          ..write('id: $id, ')
          ..write('nick: $nick, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('lastSync: $lastSync, ')
          ..write('token: $token')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nick, host, port, lastSync, token);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HttpServerPairing &&
          other.id == this.id &&
          other.nick == this.nick &&
          other.host == this.host &&
          other.port == this.port &&
          other.lastSync == this.lastSync &&
          other.token == this.token);
}

class HttpServerPairingsCompanion extends UpdateCompanion<HttpServerPairing> {
  final Value<String> id;
  final Value<String> nick;
  final Value<String> host;
  final Value<int> port;
  final Value<String> lastSync;
  final Value<String> token;
  final Value<int> rowid;
  const HttpServerPairingsCompanion({
    this.id = const Value.absent(),
    this.nick = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.token = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HttpServerPairingsCompanion.insert({
    this.id = const Value.absent(),
    required String nick,
    required String host,
    this.port = const Value.absent(),
    required String lastSync,
    required String token,
    this.rowid = const Value.absent(),
  }) : nick = Value(nick),
       host = Value(host),
       lastSync = Value(lastSync),
       token = Value(token);
  static Insertable<HttpServerPairing> custom({
    Expression<String>? id,
    Expression<String>? nick,
    Expression<String>? host,
    Expression<int>? port,
    Expression<String>? lastSync,
    Expression<String>? token,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nick != null) 'nick': nick,
      if (host != null) 'host': host,
      if (port != null) 'port': port,
      if (lastSync != null) 'last_sync': lastSync,
      if (token != null) 'token': token,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HttpServerPairingsCompanion copyWith({
    Value<String>? id,
    Value<String>? nick,
    Value<String>? host,
    Value<int>? port,
    Value<String>? lastSync,
    Value<String>? token,
    Value<int>? rowid,
  }) {
    return HttpServerPairingsCompanion(
      id: id ?? this.id,
      nick: nick ?? this.nick,
      host: host ?? this.host,
      port: port ?? this.port,
      lastSync: lastSync ?? this.lastSync,
      token: token ?? this.token,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nick.present) {
      map['nick'] = Variable<String>(nick.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (lastSync.present) {
      map['last_sync'] = Variable<String>(lastSync.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HttpServerPairingsCompanion(')
          ..write('id: $id, ')
          ..write('nick: $nick, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('lastSync: $lastSync, ')
          ..write('token: $token, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HttpClientPairingsTable extends HttpClientPairings
    with TableInfo<$HttpClientPairingsTable, HttpClientPairing> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HttpClientPairingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nickMeta = const VerificationMeta('nick');
  @override
  late final GeneratedColumn<String> nick = GeneratedColumn<String>(
    'nick',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncMeta = const VerificationMeta(
    'lastSync',
  );
  @override
  late final GeneratedColumn<String> lastSync = GeneratedColumn<String>(
    'last_sync',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acceptedMeta = const VerificationMeta(
    'accepted',
  );
  @override
  late final GeneratedColumn<bool> accepted = GeneratedColumn<bool>(
    'accepted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("accepted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nick, lastSync, accepted, token];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'http_client_pairings';
  @override
  VerificationContext validateIntegrity(
    Insertable<HttpClientPairing> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nick')) {
      context.handle(
        _nickMeta,
        nick.isAcceptableOrUnknown(data['nick']!, _nickMeta),
      );
    } else if (isInserting) {
      context.missing(_nickMeta);
    }
    if (data.containsKey('last_sync')) {
      context.handle(
        _lastSyncMeta,
        lastSync.isAcceptableOrUnknown(data['last_sync']!, _lastSyncMeta),
      );
    } else if (isInserting) {
      context.missing(_lastSyncMeta);
    }
    if (data.containsKey('accepted')) {
      context.handle(
        _acceptedMeta,
        accepted.isAcceptableOrUnknown(data['accepted']!, _acceptedMeta),
      );
    }
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HttpClientPairing map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HttpClientPairing(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      nick:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}nick'],
          )!,
      lastSync:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}last_sync'],
          )!,
      accepted:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}accepted'],
          )!,
      token:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}token'],
          )!,
    );
  }

  @override
  $HttpClientPairingsTable createAlias(String alias) {
    return $HttpClientPairingsTable(attachedDatabase, alias);
  }
}

class HttpClientPairing extends DataClass
    implements Insertable<HttpClientPairing> {
  final String id;
  final String nick;
  final String lastSync;
  final bool accepted;
  final String token;
  const HttpClientPairing({
    required this.id,
    required this.nick,
    required this.lastSync,
    required this.accepted,
    required this.token,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nick'] = Variable<String>(nick);
    map['last_sync'] = Variable<String>(lastSync);
    map['accepted'] = Variable<bool>(accepted);
    map['token'] = Variable<String>(token);
    return map;
  }

  HttpClientPairingsCompanion toCompanion(bool nullToAbsent) {
    return HttpClientPairingsCompanion(
      id: Value(id),
      nick: Value(nick),
      lastSync: Value(lastSync),
      accepted: Value(accepted),
      token: Value(token),
    );
  }

  factory HttpClientPairing.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HttpClientPairing(
      id: serializer.fromJson<String>(json['id']),
      nick: serializer.fromJson<String>(json['nick']),
      lastSync: serializer.fromJson<String>(json['lastSync']),
      accepted: serializer.fromJson<bool>(json['accepted']),
      token: serializer.fromJson<String>(json['token']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nick': serializer.toJson<String>(nick),
      'lastSync': serializer.toJson<String>(lastSync),
      'accepted': serializer.toJson<bool>(accepted),
      'token': serializer.toJson<String>(token),
    };
  }

  HttpClientPairing copyWith({
    String? id,
    String? nick,
    String? lastSync,
    bool? accepted,
    String? token,
  }) => HttpClientPairing(
    id: id ?? this.id,
    nick: nick ?? this.nick,
    lastSync: lastSync ?? this.lastSync,
    accepted: accepted ?? this.accepted,
    token: token ?? this.token,
  );
  HttpClientPairing copyWithCompanion(HttpClientPairingsCompanion data) {
    return HttpClientPairing(
      id: data.id.present ? data.id.value : this.id,
      nick: data.nick.present ? data.nick.value : this.nick,
      lastSync: data.lastSync.present ? data.lastSync.value : this.lastSync,
      accepted: data.accepted.present ? data.accepted.value : this.accepted,
      token: data.token.present ? data.token.value : this.token,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HttpClientPairing(')
          ..write('id: $id, ')
          ..write('nick: $nick, ')
          ..write('lastSync: $lastSync, ')
          ..write('accepted: $accepted, ')
          ..write('token: $token')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nick, lastSync, accepted, token);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HttpClientPairing &&
          other.id == this.id &&
          other.nick == this.nick &&
          other.lastSync == this.lastSync &&
          other.accepted == this.accepted &&
          other.token == this.token);
}

class HttpClientPairingsCompanion extends UpdateCompanion<HttpClientPairing> {
  final Value<String> id;
  final Value<String> nick;
  final Value<String> lastSync;
  final Value<bool> accepted;
  final Value<String> token;
  final Value<int> rowid;
  const HttpClientPairingsCompanion({
    this.id = const Value.absent(),
    this.nick = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.accepted = const Value.absent(),
    this.token = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HttpClientPairingsCompanion.insert({
    this.id = const Value.absent(),
    required String nick,
    required String lastSync,
    this.accepted = const Value.absent(),
    required String token,
    this.rowid = const Value.absent(),
  }) : nick = Value(nick),
       lastSync = Value(lastSync),
       token = Value(token);
  static Insertable<HttpClientPairing> custom({
    Expression<String>? id,
    Expression<String>? nick,
    Expression<String>? lastSync,
    Expression<bool>? accepted,
    Expression<String>? token,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nick != null) 'nick': nick,
      if (lastSync != null) 'last_sync': lastSync,
      if (accepted != null) 'accepted': accepted,
      if (token != null) 'token': token,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HttpClientPairingsCompanion copyWith({
    Value<String>? id,
    Value<String>? nick,
    Value<String>? lastSync,
    Value<bool>? accepted,
    Value<String>? token,
    Value<int>? rowid,
  }) {
    return HttpClientPairingsCompanion(
      id: id ?? this.id,
      nick: nick ?? this.nick,
      lastSync: lastSync ?? this.lastSync,
      accepted: accepted ?? this.accepted,
      token: token ?? this.token,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nick.present) {
      map['nick'] = Variable<String>(nick.value);
    }
    if (lastSync.present) {
      map['last_sync'] = Variable<String>(lastSync.value);
    }
    if (accepted.present) {
      map['accepted'] = Variable<bool>(accepted.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HttpClientPairingsCompanion(')
          ..write('id: $id, ')
          ..write('nick: $nick, ')
          ..write('lastSync: $lastSync, ')
          ..write('accepted: $accepted, ')
          ..write('token: $token, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $ScheduleEntriesTable scheduleEntries = $ScheduleEntriesTable(
    this,
  );
  late final $ProductsTable products = $ProductsTable(this);
  late final $RecipeProductsTable recipeProducts = $RecipeProductsTable(this);
  late final $HttpServerPairingsTable httpServerPairings =
      $HttpServerPairingsTable(this);
  late final $HttpClientPairingsTable httpClientPairings =
      $HttpClientPairingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    recipes,
    scheduleEntries,
    products,
    recipeProducts,
    httpServerPairings,
    httpClientPairings,
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

  static MultiTypedResultKey<$ScheduleEntriesTable, List<ScheduleEntry>>
  _scheduleEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.scheduleEntries,
    aliasName: $_aliasNameGenerator(db.recipes.id, db.scheduleEntries.recipeId),
  );

  $$ScheduleEntriesTableProcessedTableManager get scheduleEntriesRefs {
    final manager = $$ScheduleEntriesTableTableManager(
      $_db,
      $_db.scheduleEntries,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _scheduleEntriesRefsTable($_db),
    );
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

  Expression<bool> scheduleEntriesRefs(
    Expression<bool> Function($$ScheduleEntriesTableFilterComposer f) f,
  ) {
    final $$ScheduleEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleEntries,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleEntriesTableFilterComposer(
            $db: $db,
            $table: $db.scheduleEntries,
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

  Expression<T> scheduleEntriesRefs<T extends Object>(
    Expression<T> Function($$ScheduleEntriesTableAnnotationComposer a) f,
  ) {
    final $$ScheduleEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleEntries,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.scheduleEntries,
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
          PrefetchHooks Function({
            bool scheduleEntriesRefs,
            bool recipeProductsRefs,
          })
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
            scheduleEntriesRefs = false,
            recipeProductsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (scheduleEntriesRefs) db.scheduleEntries,
                if (recipeProductsRefs) db.recipeProducts,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (scheduleEntriesRefs)
                    await $_getPrefetchedData<
                      Recipe,
                      $RecipesTable,
                      ScheduleEntry
                    >(
                      currentTable: table,
                      referencedTable: $$RecipesTableReferences
                          ._scheduleEntriesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).scheduleEntriesRefs,
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
      PrefetchHooks Function({
        bool scheduleEntriesRefs,
        bool recipeProductsRefs,
      })
    >;
typedef $$ScheduleEntriesTableCreateCompanionBuilder =
    ScheduleEntriesCompanion Function({
      Value<String> id,
      required int week,
      required int day,
      required String recipeId,
      Value<int> rowid,
    });
typedef $$ScheduleEntriesTableUpdateCompanionBuilder =
    ScheduleEntriesCompanion Function({
      Value<String> id,
      Value<int> week,
      Value<int> day,
      Value<String> recipeId,
      Value<int> rowid,
    });

final class $$ScheduleEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ScheduleEntriesTable, ScheduleEntry> {
  $$ScheduleEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias(
        $_aliasNameGenerator(db.scheduleEntries.recipeId, db.recipes.id),
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
}

class $$ScheduleEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduleEntriesTable> {
  $$ScheduleEntriesTableFilterComposer({
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

class $$ScheduleEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduleEntriesTable> {
  $$ScheduleEntriesTableOrderingComposer({
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

class $$ScheduleEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduleEntriesTable> {
  $$ScheduleEntriesTableAnnotationComposer({
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

class $$ScheduleEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduleEntriesTable,
          ScheduleEntry,
          $$ScheduleEntriesTableFilterComposer,
          $$ScheduleEntriesTableOrderingComposer,
          $$ScheduleEntriesTableAnnotationComposer,
          $$ScheduleEntriesTableCreateCompanionBuilder,
          $$ScheduleEntriesTableUpdateCompanionBuilder,
          (ScheduleEntry, $$ScheduleEntriesTableReferences),
          ScheduleEntry,
          PrefetchHooks Function({bool recipeId})
        > {
  $$ScheduleEntriesTableTableManager(
    _$AppDatabase db,
    $ScheduleEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$ScheduleEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ScheduleEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ScheduleEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> week = const Value.absent(),
                Value<int> day = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduleEntriesCompanion(
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
              }) => ScheduleEntriesCompanion.insert(
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
                          $$ScheduleEntriesTableReferences(db, table, e),
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
                            referencedTable: $$ScheduleEntriesTableReferences
                                ._recipeIdTable(db),
                            referencedColumn:
                                $$ScheduleEntriesTableReferences
                                    ._recipeIdTable(db)
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

typedef $$ScheduleEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduleEntriesTable,
      ScheduleEntry,
      $$ScheduleEntriesTableFilterComposer,
      $$ScheduleEntriesTableOrderingComposer,
      $$ScheduleEntriesTableAnnotationComposer,
      $$ScheduleEntriesTableCreateCompanionBuilder,
      $$ScheduleEntriesTableUpdateCompanionBuilder,
      (ScheduleEntry, $$ScheduleEntriesTableReferences),
      ScheduleEntry,
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
typedef $$HttpServerPairingsTableCreateCompanionBuilder =
    HttpServerPairingsCompanion Function({
      Value<String> id,
      required String nick,
      required String host,
      Value<int> port,
      required String lastSync,
      required String token,
      Value<int> rowid,
    });
typedef $$HttpServerPairingsTableUpdateCompanionBuilder =
    HttpServerPairingsCompanion Function({
      Value<String> id,
      Value<String> nick,
      Value<String> host,
      Value<int> port,
      Value<String> lastSync,
      Value<String> token,
      Value<int> rowid,
    });

class $$HttpServerPairingsTableFilterComposer
    extends Composer<_$AppDatabase, $HttpServerPairingsTable> {
  $$HttpServerPairingsTableFilterComposer({
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

  ColumnFilters<String> get nick => $composableBuilder(
    column: $table.nick,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HttpServerPairingsTableOrderingComposer
    extends Composer<_$AppDatabase, $HttpServerPairingsTable> {
  $$HttpServerPairingsTableOrderingComposer({
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

  ColumnOrderings<String> get nick => $composableBuilder(
    column: $table.nick,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HttpServerPairingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HttpServerPairingsTable> {
  $$HttpServerPairingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nick =>
      $composableBuilder(column: $table.nick, builder: (column) => column);

  GeneratedColumn<String> get host =>
      $composableBuilder(column: $table.host, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get lastSync =>
      $composableBuilder(column: $table.lastSync, builder: (column) => column);

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);
}

class $$HttpServerPairingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HttpServerPairingsTable,
          HttpServerPairing,
          $$HttpServerPairingsTableFilterComposer,
          $$HttpServerPairingsTableOrderingComposer,
          $$HttpServerPairingsTableAnnotationComposer,
          $$HttpServerPairingsTableCreateCompanionBuilder,
          $$HttpServerPairingsTableUpdateCompanionBuilder,
          (
            HttpServerPairing,
            BaseReferences<
              _$AppDatabase,
              $HttpServerPairingsTable,
              HttpServerPairing
            >,
          ),
          HttpServerPairing,
          PrefetchHooks Function()
        > {
  $$HttpServerPairingsTableTableManager(
    _$AppDatabase db,
    $HttpServerPairingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$HttpServerPairingsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$HttpServerPairingsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$HttpServerPairingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nick = const Value.absent(),
                Value<String> host = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<String> lastSync = const Value.absent(),
                Value<String> token = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HttpServerPairingsCompanion(
                id: id,
                nick: nick,
                host: host,
                port: port,
                lastSync: lastSync,
                token: token,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String nick,
                required String host,
                Value<int> port = const Value.absent(),
                required String lastSync,
                required String token,
                Value<int> rowid = const Value.absent(),
              }) => HttpServerPairingsCompanion.insert(
                id: id,
                nick: nick,
                host: host,
                port: port,
                lastSync: lastSync,
                token: token,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HttpServerPairingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HttpServerPairingsTable,
      HttpServerPairing,
      $$HttpServerPairingsTableFilterComposer,
      $$HttpServerPairingsTableOrderingComposer,
      $$HttpServerPairingsTableAnnotationComposer,
      $$HttpServerPairingsTableCreateCompanionBuilder,
      $$HttpServerPairingsTableUpdateCompanionBuilder,
      (
        HttpServerPairing,
        BaseReferences<
          _$AppDatabase,
          $HttpServerPairingsTable,
          HttpServerPairing
        >,
      ),
      HttpServerPairing,
      PrefetchHooks Function()
    >;
typedef $$HttpClientPairingsTableCreateCompanionBuilder =
    HttpClientPairingsCompanion Function({
      Value<String> id,
      required String nick,
      required String lastSync,
      Value<bool> accepted,
      required String token,
      Value<int> rowid,
    });
typedef $$HttpClientPairingsTableUpdateCompanionBuilder =
    HttpClientPairingsCompanion Function({
      Value<String> id,
      Value<String> nick,
      Value<String> lastSync,
      Value<bool> accepted,
      Value<String> token,
      Value<int> rowid,
    });

class $$HttpClientPairingsTableFilterComposer
    extends Composer<_$AppDatabase, $HttpClientPairingsTable> {
  $$HttpClientPairingsTableFilterComposer({
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

  ColumnFilters<String> get nick => $composableBuilder(
    column: $table.nick,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get accepted => $composableBuilder(
    column: $table.accepted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HttpClientPairingsTableOrderingComposer
    extends Composer<_$AppDatabase, $HttpClientPairingsTable> {
  $$HttpClientPairingsTableOrderingComposer({
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

  ColumnOrderings<String> get nick => $composableBuilder(
    column: $table.nick,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get accepted => $composableBuilder(
    column: $table.accepted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HttpClientPairingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HttpClientPairingsTable> {
  $$HttpClientPairingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nick =>
      $composableBuilder(column: $table.nick, builder: (column) => column);

  GeneratedColumn<String> get lastSync =>
      $composableBuilder(column: $table.lastSync, builder: (column) => column);

  GeneratedColumn<bool> get accepted =>
      $composableBuilder(column: $table.accepted, builder: (column) => column);

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);
}

class $$HttpClientPairingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HttpClientPairingsTable,
          HttpClientPairing,
          $$HttpClientPairingsTableFilterComposer,
          $$HttpClientPairingsTableOrderingComposer,
          $$HttpClientPairingsTableAnnotationComposer,
          $$HttpClientPairingsTableCreateCompanionBuilder,
          $$HttpClientPairingsTableUpdateCompanionBuilder,
          (
            HttpClientPairing,
            BaseReferences<
              _$AppDatabase,
              $HttpClientPairingsTable,
              HttpClientPairing
            >,
          ),
          HttpClientPairing,
          PrefetchHooks Function()
        > {
  $$HttpClientPairingsTableTableManager(
    _$AppDatabase db,
    $HttpClientPairingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$HttpClientPairingsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$HttpClientPairingsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$HttpClientPairingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nick = const Value.absent(),
                Value<String> lastSync = const Value.absent(),
                Value<bool> accepted = const Value.absent(),
                Value<String> token = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HttpClientPairingsCompanion(
                id: id,
                nick: nick,
                lastSync: lastSync,
                accepted: accepted,
                token: token,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String nick,
                required String lastSync,
                Value<bool> accepted = const Value.absent(),
                required String token,
                Value<int> rowid = const Value.absent(),
              }) => HttpClientPairingsCompanion.insert(
                id: id,
                nick: nick,
                lastSync: lastSync,
                accepted: accepted,
                token: token,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HttpClientPairingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HttpClientPairingsTable,
      HttpClientPairing,
      $$HttpClientPairingsTableFilterComposer,
      $$HttpClientPairingsTableOrderingComposer,
      $$HttpClientPairingsTableAnnotationComposer,
      $$HttpClientPairingsTableCreateCompanionBuilder,
      $$HttpClientPairingsTableUpdateCompanionBuilder,
      (
        HttpClientPairing,
        BaseReferences<
          _$AppDatabase,
          $HttpClientPairingsTable,
          HttpClientPairing
        >,
      ),
      HttpClientPairing,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$ScheduleEntriesTableTableManager get scheduleEntries =>
      $$ScheduleEntriesTableTableManager(_db, _db.scheduleEntries);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$RecipeProductsTableTableManager get recipeProducts =>
      $$RecipeProductsTableTableManager(_db, _db.recipeProducts);
  $$HttpServerPairingsTableTableManager get httpServerPairings =>
      $$HttpServerPairingsTableTableManager(_db, _db.httpServerPairings);
  $$HttpClientPairingsTableTableManager get httpClientPairings =>
      $$HttpClientPairingsTableTableManager(_db, _db.httpClientPairings);
}
