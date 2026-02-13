import 'data.dart'; 


class UserService {
  
  static String userName = "John Doe"; 
  static String userEmail = "john.doe@gmail.com";

  static String? storedName;
  static String? storedEmail;
  static String? storedPassword;  
}


class CartService {
  // store the item, quantity, and special request note.
  static List<Map<String, dynamic>> items = [];

  
  static void addToCart(FoodItem item, int quantity, String specialRequest) {
    items.add({
      'item': item,
      'quantity': quantity,
      'note': specialRequest,
    });
  }

  
  static void clearCart() {
    items.clear();
  }

 
  static double getTotal() {
    double total = 0;
    for (var i in items) {
      total += (i['item'] as FoodItem).price * (i['quantity'] as int);
    }
    return total;
  }
}