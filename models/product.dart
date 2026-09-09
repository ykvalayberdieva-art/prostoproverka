import '../enums.dart';

abstract class Product {
  final int id;
  String name;
  int price;
  final ProductCategory category;
  int _quantity;
  static int totalProducts = 0;
  Product(this.id, this.name, this.price, this._quantity, this.category) {
    if (_quantity < 0) {
      _quantity = 0;
    }
    totalProducts++;
  }
  Product.special({
    required this.id,
    required this.name,
    required this.price,
    required int quantity,
    required this.category,
  }) : _quantity = quantity < 0 ? 0 : quantity {
    totalProducts++;
  }
  int get quantity => _quantity;

  void increaseQuantity(int amount) {
    if (amount <= 0) {
      print('Ошибка! Количество должно быть больше 0.');
      return;
    }
    _quantity += amount;
  }

  bool decreaseQuantity(int amount) {
    if (amount <= 0 || amount > _quantity) {
      return false;
    }
    _quantity -= amount;
    return true;
  }

  void showInfo();
}
