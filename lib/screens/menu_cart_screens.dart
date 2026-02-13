import 'package:flutter/material.dart';
import '../data.dart'; 
import '../services.dart'; 

class MenuScreen extends StatelessWidget {
  final FoodStall foodstall; // Data passed from the Home screen
  const MenuScreen({super.key, required this.foodstall});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(foodstall.name)),
      
      // Floating button specific to this screen to view cart
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
        },
        label: const Text("View Cart"),
        icon: const Icon(Icons.shopping_cart),
        backgroundColor: Colors.orange, // color to match Home
      ),
      
      // Using GridView to show food items side-by-side
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two items per row
          childAspectRatio: 0.75, 
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: foodstall.menu.length,
        itemBuilder: (context, index) {
          final food = foodstall.menu[index];
          return Card(
            clipBehavior: Clip.antiAlias, // Ensures image stays in the box
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expanded makes the image take up available remaining space
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    // Checks if image path exists, otherwise shows icon
                    child: food.imageUrl.isNotEmpty
                        ? Image.asset(food.imageUrl, fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200], child: const Icon(Icons.broken_image)))
                        : Container(color: Colors.grey[200], child: const Icon(Icons.fastfood, size: 50, color: Colors.grey)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                      Text("\$${food.price.toStringAsFixed(2)}"), 
                      const SizedBox(height: 5),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Opens the popup to add specific notes
                            _showAddToBottomSheet(context, food);
                          },
                          child: const Text("Add"),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // show the bottom popup sheet
  void _showAddToBottomSheet(BuildContext context, FoodItem food) {
    int quantity = 1;
    TextEditingController noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows sheet to resize when keyboard opens
      builder: (context) {
        return Padding(
          
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 20, right: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(food.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: "Special Requests (e.g. No Spicy)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add item to cart
                  CartService.addToCart(food, quantity, noteController.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to cart")));
                },
                child: const Text("Add to Order"),
              )
            ],
          ),
        );
      },
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    // Access the items list
    final cartItems = CartService.items;
    
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      // Check if cart is empty to show correct UI
      body: cartItems.isEmpty 
        ? const Center(child: Text("Cart is empty"))
        : Column(
            children: [
              Expanded(
                // list all added items
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final itemData = cartItems[index];
                    final food = itemData['item'] as FoodItem;
                    return ListTile(
                      title: Text(food.name),
                      subtitle: Text("Note: ${itemData['note']}"), // Shows special request
                      
                      trailing: Text("\$${food.price.toStringAsFixed(2)}"),


                    );
                  },
                ),
              ),
              // for Total and Checkout
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        
                        Text("\$${CartService.getTotal().toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text("GST: ${(CartService.getTotal() % 0.9).toStringAsFixed(2)}")
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.green),
                      onPressed: () {
                        // Empty the cart
                        CartService.clearCart();
                        // Go to Receipt
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ReceiptScreen()));
                      },
                      child: const Text("CHECKOUT", style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              )
            ],
          ),
    );
  }
}

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Receipt")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text("Order Placed!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Order #88392"), 
            const SizedBox(height: 30),
            const Text("Ready In:"),
            const SizedBox(height: 10),
            const LinearProgressIndicator(value: 0.3, minHeight: 10), 
            const SizedBox(height: 5),
            const Text("15 Minutes"),
            const SizedBox(height: 40),
            const Divider(),
            const Text("Rate your experience"),
            
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_border, size: 40),
                Icon(Icons.star_border, size: 40),
                Icon(Icons.star_border, size: 40),
                Icon(Icons.star_border, size: 40),
                Icon(Icons.star_border, size: 40),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to Home"),
            )
          ],
        ),
      ),
    );
  }
}