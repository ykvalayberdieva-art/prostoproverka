import 'models/product.dart';
class Shop { final List<Product> products;
Shop(this.products);
void showProducts() { print('\n========== ТОВАРЫ ==========');
for (final product in products) {
  if (product.quantity == 0) {
    continue;
  }

  product.showInfo();
}
}
Product? findProduct(int id) 
{ for (final product in products)
 { if (product.id == id) { return product; } }
return null;
}
void addProduct(Product product) { products.add(product); }
bool removeProduct(int id) { final product = findProduct(id);
if (product == null) {
  return false;
}

products.remove(product);
return true;
} }