import 'dart:convert';
import 'dart:io';

import 'shop.dart';
import 'cart.dart';
import 'models/product.dart';
import 'models/clothing.dart';
import 'models/electronics.dart';
import 'models/food.dart';

int totalOrders = 0;

typedef ActionFunction = void Function();

void main() {
  print('--------------------------------------');
  print(' ДОБРО ПОЖАЛОВАТЬ!                  ');
  print(' МАГАЗИН "SMART SHOP"               ');
  print('--------------------------------------');

  print('\nВведите ваше имя: ');
  final userName = stdin.readLineSync(encoding: utf8) ?? 'Гость';

  final upperName = userName.toUpperCase();
  final nameLength = userName.length;
  final firstLetter = userName.isNotEmpty ? userName[0] : '';

  print('\n------------------------------------');
  print('Здравствуйте, $upperName!');
  print('Длина имени: $nameLength символ(ов)');
  if (firstLetter.isNotEmpty) {
    print('Первая буква: $firstLetter');
  }
  print('------------------------------------\n');

  //
  final products = <Product>[
    Clothing(1, 'Футболка', 250, 20, 'M', 'Хлопок'),
    Clothing(2, 'Юбка', 1500, 15, 'L', 'Корейская'),

    Electronics(3, 'Наушники', 3000, 10, 'Sony', 24),
    Electronics(4, 'Зарядное устройство', 800, 30, 'Anker', 12),

    Food(5, 'Ланч', 100, 50, '12.09.2026'),
    Food(6, 'Молоко', 200, 40, '15.09.2026'),
  ];
  final shop = Shop(products);

  
  final cart = Cart();

  bool isRunning = true;
  while (isRunning) {
    print('\n ------------------------------------');
    print('           ГЛАВНОЕ МЕНЮ              ');
    print('------------------------------------');
    print(' 1. Показать товары                 ');
    print(' 2. Найти товар                     ');
    print(' 3. Добавить товар в корзину        ');
    print(' 4. Удалить товар из корзины        ');
    print(' 5. Показать корзину                ');
    print(' 6. Оформить заказ                  ');
    print(' 7. Показать статистику             ');
    print(' 0. Выход                           ');
    print(' ------------------------------------');
    print('\nВыберите пункт меню: ');

    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        shop.showProducts();
        break;

      case '2':
        _findProduct(shop);
        break;

      case '3':
        _addProductToCart(shop, cart);
        break;

      case '4':
        _removeProductFromCart(cart);
        break;

      case '5':
        cart.showCart();
        break;

      case '6':
        _checkout(cart, userName);
        break;

      case '7':
        _showStatistics(shop, cart);
        break;

      case '0':
        isRunning = false;
        print('\n Спасибо за покупки, $userName! До свидания!\n');
        break;

      default:
        print(' Ошибка! Введите номер пункта (0-7).\n');
    }
  }
}

void _findProduct(Shop shop) {
  print('\nВведите ID товара для поиска: ');
  final idInput = stdin.readLineSync();
  final id = int.tryParse(idInput ?? '');

  if (id == null) {
    print(' Неверный ID.\n');
    return;
  }

  final product = shop.findProduct(id);
  if (product == null) {
    print(' Товар с ID $id не найден.\n');
    return;
  }

  print('\n Найден товар:');
  product.showInfo();
  print('');
}

void _addProductToCart(Shop shop, Cart cart) {
  print('\nВведите ID товара: ');
  final idInput = stdin.readLineSync();
  final id = int.tryParse(idInput ?? '');

  if (id == null) {
    print(' Неверный ID.\n');
    return;
  }

  final product = shop.findProduct(id);
  if (product == null) {
    print(' Товар с ID $id не найден.\n');
    return;
  }

  if (product.quantity <= 0) {
    print(' Товар "${product.name}" закончился на складе.\n');
    return;
  }

  print('Введите количество: ');
  final quantityInput = stdin.readLineSync();
  final quantity = int.tryParse(quantityInput ?? '');

  if (quantity == null || quantity <= 0) {
    print(' Неверное количество.\n');
    return;
  }

  if (quantity > product.quantity) {
    print(' На складе только ${product.quantity} шт.\n');
    return;
  }

  cart.addItem(product, quantity);
  print(' Товар добавлен в корзину!\n');
}

void _removeProductFromCart(Cart cart) {
  print('\nВведите ID товара для удаления: ');
  final idInput = stdin.readLineSync();
  final id = int.tryParse(idInput ?? '');

  if (id == null) {
    print(' Неверный ID.\n');
    return;
  }

  cart.removeItem(id);
  print(' Товар удалён из корзины!\n');
}

void _checkout(Cart cart, String userName) {
  final total = cart.getTotalPrice();
  final quantity = cart.getTotalQuantity();

  if (quantity == 0) {
    print('\n Корзина пуста. Добавьте товары перед оплатой.\n');
    return;
  }

  int finalPrice = cart.applyDiscount(total);
  int discount = total - finalPrice;

  print('\n--------------------------------------');
  print('         ОФОРМЛЕНИЕ ЗАКАЗА          ');
  print('------------------------------------');
  print(' Заказчик: $userName');

  for (final item in cart.cartItems.values) {
    print('--- • ${item.name} x${item.quantity}');
  }

  print('                                    ');
  print('--- Стоимость: $total сом');

  if (discount > 0) {
    print('--- Скидка: -$discount сом');
  }

  print(' ИТОГО: $finalPrice сом');
  print('                                    ');
  print(' Подтверждаете покупку? (да/нет)   ');
  print('--------------------------------------------');
  print('\nВаш выбор: ');

  final confirm = stdin.readLineSync(encoding: utf8)?.toLowerCase();

  List<String> validYesResponses = ['да', 'yes', 'y', 'd'];
  List<String> validNoResponses = ['нет', 'no', 'n'];

  if (validYesResponses.contains(confirm)) {
    totalOrders++;
    print('\n Заказ #$totalOrders оформлен успешно!');
    print(' Спасибо, $userName! Товары будут отправлены в ближайшее время.\n');
    cart.clearCart();
  } else if (validNoResponses.contains(confirm)) {
    print('\n Заказ отменён.\n');
  } else {
    print('\n Некорректный ввод. Попробуйте снова.\n');
  }

  // if (confirm == 'да' || confirm == 'yes' || confirm == 'y' || confirm == 'd') {
  //   totalOrders++;
  //   print('\n Заказ #$totalOrders оформлен успешно!');
  //   print(' Спасибо, $userName! Товары будут отправлены в ближайшее время.\n');
  //   cart.clearCart();
  // } else {
  //   print('\n Заказ отменён.\n');
  // }
}

void _showStatistics(Shop shop, Cart cart) {
  print('\n--------------------------------------');
  print('          СТАТИСТИКА                ');
  print('----------------------------------------');

  // Требование #10: static переменная
  print('---- Всего товаров в магазине: ${Product.totalProducts}');
  print('---- Товаров в корзине: ${cart.getItemCount()}');
  print('---- Оформлено заказов: $totalOrders');
  print(
    '------- Уникальных купленных товаров: ${cart.getPurchasedProductIds().length}',
  );

  print('---------------------------------------------\n');
}

void _showWelcome() {
  print('--------------------------------------');
  print(' ДОБРО ПОЖАЛОВАТЬ В SMART SHOP!     ');
  print('----------------------------------------\n');
}

void _executeAction(ActionFunction action) {
  action();
}
