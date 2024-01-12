// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ProductDao? _productDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Product` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `image` TEXT, `price` REAL NOT NULL, `productName` TEXT NOT NULL, `productType` TEXT NOT NULL, `tax` REAL NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ProductDao get productDao {
    return _productDaoInstance ??= _$ProductDao(database, changeListener);
  }
}

class _$ProductDao extends ProductDao {
  _$ProductDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productInsertionAdapter = InsertionAdapter(
            database,
            'Product',
            (Product item) => <String, Object?>{
                  'id': item.id,
                  'image': item.image,
                  'price': item.price,
                  'productName': item.productName,
                  'productType': item.productType,
                  'tax': item.tax
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Product> _productInsertionAdapter;

  @override
  Future<List<Product>> findAllProducts() async {
    return _queryAdapter.queryList('SELECT * FROM Product',
        mapper: (Map<String, Object?> row) => Product(
            id: row['id'] as int?,
            image: row['image'] as String?,
            price: row['price'] as double,
            productName: row['productName'] as String,
            productType: row['productType'] as String,
            tax: row['tax'] as double));
  }

  @override
  Future<List<Product>> getProductByName(String match) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Product WHERE productName LIKE ?1',
        mapper: (Map<String, Object?> row) => Product(
            id: row['id'] as int?,
            image: row['image'] as String?,
            price: row['price'] as double,
            productName: row['productName'] as String,
            productType: row['productType'] as String,
            tax: row['tax'] as double),
        arguments: [match]);
  }

  @override
  Future<int?> isEmpty() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM (SELECT TOP 1 * FROM Product) AS t',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> countEntries() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM Product',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> deleteAll() async {
    return _queryAdapter.query('DELETE FROM Product',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertProduct(Product product) async {
    await _productInsertionAdapter.insert(product, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertAllProducts(List<Product> products) {
    return _productInsertionAdapter.insertListAndReturnIds(
        products, OnConflictStrategy.abort);
  }
}
