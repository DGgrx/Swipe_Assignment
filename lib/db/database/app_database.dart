import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:swipe/db/dao/product_dao.dart';
import '../entity/product.dart';

part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Product])
abstract class AppDatabase extends FloorDatabase {
  ProductDao get productDao;
}