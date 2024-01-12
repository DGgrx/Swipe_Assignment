import 'package:floor/floor.dart';
import 'package:swipe/db/entity/product.dart';

@dao
abstract class ProductDao
{
  @Query('SELECT * FROM Product')
  Future<List<Product>> findAllProducts();

  @Query('SELECT * FROM Product WHERE productName LIKE :match')
  Future<List<Product>> getProductByName(String match);

  @Query('SELECT COUNT(*) FROM (SELECT TOP 1 * FROM Product) AS t')
  Future<int?> isEmpty();

  @Query('SELECT COUNT(*) FROM Product')
  Future<int?> countEntries();

  @insert
  Future<void> insertProduct(Product product);

  @insert
  Future<List<int>> insertAllProducts(List<Product> products);

  @Query('DELETE FROM Product')
  Future<int?> deleteAll();
}