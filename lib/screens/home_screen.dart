import 'package:flutter/material.dart';
import '../data.dart'; 
import 'menu_cart_screens.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // load the full list of data from my DataService
  List<FoodStall> allRestaurants = DataService.getStall();
  
  
  List<FoodStall> displayedRestaurants = [];
  
  // what the user is filtering for.
  String searchQuery = "";
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    // show everything
    displayedRestaurants = allRestaurants;
  }


  void _updateList() {
    setState(() {
      //  the list based on specific conditions.
      displayedRestaurants = allRestaurants.where((stall) {
        
        // stall name will match what the user typed
        final matchesName = stall.name.toLowerCase().contains(searchQuery.toLowerCase());
        
      
        // show everything
        final matchesCategory = (selectedCategory == "All") || 
            stall.menu.any((foodItem) => foodItem.category == selectedCategory);

        
        return matchesName && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // list of categories for the filter buttons
    final categories = ["All", "Burgers", "Drinks", "Sides", "Pasta", "Main"];

    return Scaffold(
      appBar: AppBar(title: const Text("SwiftEats Discovery")),
      body: Column(
        children: [
          
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              // triggers instantly
              onChanged: (val) {
                searchQuery = val;
                _updateList();
              },
              decoration: const InputDecoration(
                labelText: "Search eateries...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Allows scrolling left-to-right
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              // map the list of strings into widgets
              children: categories.map((category) {
                
                // specific button is the one currently active
                final isSelected = selectedCategory == category;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected, 
                    selectedColor: Colors.orange[200], // color
                    
                    onSelected: (bool selected) {
                      setState(() {
                        
                         // click the specific category again (unselect), go back to "All".
                         selectedCategory = (selected && category != "All") ? category : "All";
                         _updateList(); 
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 10),
          
          
          Expanded(
            // If search finds nothing, say "No eateries found".
            
            child: displayedRestaurants.isEmpty 
              ? const Center(child: Text("No eateries found")) 
              : ListView.builder(
                  itemCount: displayedRestaurants.length,
                  itemBuilder: (context, index) {
                    final rest = displayedRestaurants[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        
                        leading: rest.imageUrl.isNotEmpty 
                            ? CircleAvatar(backgroundImage: AssetImage(rest.imageUrl), radius: 25)
                            : CircleAvatar(backgroundColor: Colors.grey[200], child: const Icon(Icons.store)),
                        title: Text(rest.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            Text(" ${rest.rating}"),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        
                        // When tapped, push the MenuScreen and pass the stall data
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MenuScreen(foodstall: rest)),
                          );
                        },
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}