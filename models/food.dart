import 'product.dart';
import '../enums.dart';

abstract class Discountable {
  int calculateDiscount(int total);
}

class Food extends Product implements Discountable {
  final String expirationDate;

  Food(
    int id,
    String name,
    int price,
    int quantity,
    this.expirationDate,
  ) : super(
          id,
          name,
          price,
          quantity,
          ProductCategory.food,
        );

  @override
  void showInfo() {
    print(
      '[$id] $name | $price сом | Остаток: $quantity | '
      'Еда | Срок годности: $expirationDate',
    );
  }

  @override
  int calculateDiscount(int total) {
    return total >= 5000 ? (total * 5 ~/ 100) : 0;
  }
}