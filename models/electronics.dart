import 'product.dart';
import '../enums.dart';
import '../mixins.dart';

class Electronics extends Product with Loggable {
  final int warrantyMonths;
  final String manufacturer;

  Electronics(
    int id,
    String name,
    int price,
    int quantity,
    String manufacturer,
    this.warrantyMonths,
  ) : manufacturer = manufacturer,
       super(
 id,
 name,
 price,
 quantity,
 ProductCategory.electronics,
 );

  @override
  void showInfo() {
    print(
      '[$id] $name | $price сом | Остаток: $quantity | '
      'Электроника | $manufacturer | '
      'Гарантия: $warrantyMonths мес.',
    );
  }

  void registerWarranty() {
    log('Гарантия зарегистрирована для товара $name');
  }
}