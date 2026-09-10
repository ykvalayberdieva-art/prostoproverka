import 'models/product.dart';
import 'models/food.dart';
import 'mixins.dart';


abstract class Discountable {
  int calculateDiscount(int total);
}

class Cart with Loggable {
  
  final Map<int, Product> cartItems = {};

  
  final Set<int> purchasedProductIds = {};

  void addItem(Product product, int quantity) {
    if (quantity <= 0) {
      log('Ошибка! Количество должно быть больше 0.');
      return;
    }

    if (product.quantity < quantity) {
      log('Ошибка! Недостаточно товара "${product.name}" на складе.');
      return;
    }

    
    if (cartItems.containsKey(product.id)) {
      cartItems[product.id]!.increaseQuantity(quantity);
      log('Товар "${product.name}" добавлен в корзину (+$quantity шт)');
    } else {
      
      if (!product.decreaseQuantity(quantity)) {
        log('Ошибка при добавлении товара.');
        return;
      }
      cartItems[product.id] = product;
      purchasedProductIds.add(product.id);
      log('Товар "${product.name}" добавлен в корзину');
    }
  }

  void removeItem(int productId) {
    if (!cartItems.containsKey(productId)) {
      log('Товар с ID $productId не найден в корзине.');
      return;
    }

    final item = cartItems[productId]!;
    cartItems.remove(productId);
    log('Товар "${item.name}" удалён из корзины');
  }

  int getTotalPrice() {
    int total = 0;
    for (final item in cartItems.values) {
      total += item.price * item.quantity;
    }
    return total;
  }

  int getTotalQuantity() {
    int total = 0;
    for (final item in cartItems.values) {
      total += item.quantity;
    }
    return total;
  }

  
  int applyDiscount(int total) {
    for (final item in cartItems.values) {
      
      if (item is Discountable) {
        final discountable = item as Discountable;
        final discount = discountable.calculateDiscount(total);
        return total - discount;
      }
    }
    return total;
  }

  void clearCart() {
    cartItems.clear();
    log('Корзина очищена');
  }

  void showCart() {
    if (cartItems.isEmpty) {
      print('\n========== КОРЗИНА ПУСТА ==========\n');
      return;
    }

    print('\n========== КОРЗИНА ==========');
    int total = 0;
    for (final item in cartItems.values) {
      final itemTotal = item.price * item.quantity;
      total += itemTotal;
      print('${item.name} x${item.quantity}      $itemTotal сом');
    }
    print('========== ИТОГО: $total сом ==========\n');
  }

  int getItemCount() => cartItems.length;

  Set<int> getPurchasedProductIds() => purchasedProductIds;
}
