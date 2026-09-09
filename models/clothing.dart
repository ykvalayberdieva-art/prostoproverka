import 'product.dart'; import '../enums.dart';
class Clothing extends Product { final String size; final String material;
Clothing( int id, String name, int price, int quantity, this.size, this.material, ) : super( id, name, price, quantity, ProductCategory.clothes, );
@override void showInfo() { print( '[$id] $name | $price сом | Остаток: $quantity | ' 'Одежда | Размер: $size | Материал: $material', ); }
@override bool operator ==(Object other) { if (other is Product) { return id == other.id; }
return false;
}
@override int get hashCode => id.hashCode; }