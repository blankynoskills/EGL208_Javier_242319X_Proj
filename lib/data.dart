
// pass food data around easily as an object.

class FoodItem {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  FoodItem({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}

// A stall contains a list of FoodItems.

class FoodStall {
  final String id;
  final String name;
  final double rating;
  final String imageUrl;
  final List<FoodItem> menu;

  FoodStall({
    required this.id,
    required this.name,
    required this.rating,
    required this.imageUrl,
    required this.menu,
  });
}


// static to return data

class DataService {
  static List<FoodStall> getStall() {
    return [
      FoodStall(
        id: '1',
        name: 'Mcdonald',
        rating: 4.8,
        imageUrl: 'images/Mcdonald.png',
        menu: [
          FoodItem(name: 'BigMac', description: 'Perfect Burger with juicy meat', price: 7.0, imageUrl: 'images/bigmac.png', category: 'Burgers'),
          FoodItem(name: 'Mcnuggets', description: 'Chicken Nuggets (20pc)', price: 7.0, imageUrl: 'images/mcnuggets.png', category: 'Sides'),
        ],
      ),
      FoodStall(
        id: '2',
        name: 'Liho',
        rating: 4.2,
        imageUrl: 'images/liho.png',
        menu: [
          FoodItem(name: 'Milk Tea', description: 'Milk tea with pearls', price: 4.0, imageUrl: 'images/milktea.jpeg', category: 'Drinks'),
          FoodItem(name: 'Coconut Shake', description: 'Coconut Shake with avacado', price: 5.0, imageUrl: 'images/coconutshake.jpg', category: 'Drinks'),
        ],
      ),
      FoodStall(
        id: '3',
        name: 'Pastamania',
        rating: 4.5,
        imageUrl: 'images/pastamania.jpeg',
        menu: [
          FoodItem(name: 'Creamy Pasta', description: 'Creamy Pasta with cheese topping', price: 5.0, imageUrl: 'images/creamypasta.jpeg', category: 'Pasta'),
          FoodItem(name: 'Carbonara', description: 'Carbonara with ham', price: 6.0, imageUrl: 'images/carbonara.jpeg', category: 'Pasta'),
        ],
      ),
      FoodStall(
        id: '4',
        name: '4 Fingers',
        rating: 4.6,
        imageUrl: 'images/4fingers.png',
        menu: [
          FoodItem(name: 'Crispy Chicken', description: 'Crispy Chicken', price: 9.0, imageUrl: 'images/crispychicken.jpeg', category: 'Main'),
          FoodItem(name: 'Chick and Seafood', description: 'Chicken combo with seafood', price: 12.0, imageUrl: 'images/chicknseafood.jpeg', category: 'Main'),
        ],
      ),
    ];
  }
}