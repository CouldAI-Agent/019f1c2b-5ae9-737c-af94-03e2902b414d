import 'package:flutter/material.dart';

void main() {
  runApp(const GoldInventoryApp());
}

class GoldInventoryApp extends StatelessWidget {
  const GoldInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gold Inventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFD700), // Gold color
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/inventory': (context) => const InventoryScreen(),
      },
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});
}

class GoldItem {
  final String id;
  final String name;
  final String categoryId;
  final double weight; // in grams
  final String purity; // e.g., 22K, 24K

  GoldItem({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.weight,
    required this.purity,
  });
}

// Sample Data
final List<Category> _categories = [
  Category(id: '1', name: 'Rings'),
  Category(id: '2', name: 'Necklaces'),
  Category(id: '3', name: 'Bracelets'),
  Category(id: '4', name: 'Coins'),
];

final List<GoldItem> _items = [
  GoldItem(id: '1', name: 'Plain Gold Ring', categoryId: '1', weight: 4.5, purity: '22K'),
  GoldItem(id: '2', name: 'Gold Chain', categoryId: '2', weight: 15.0, purity: '22K'),
  GoldItem(id: '3', name: 'Bangle', categoryId: '3', weight: 20.0, purity: '22K'),
  GoldItem(id: '4', name: '1oz Gold Coin', categoryId: '4', weight: 31.1, purity: '24K'),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double totalWeight = _items.fold(0, (sum, item) => sum + item.weight);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gold Inventory Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Weight',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${totalWeight.toStringAsFixed(2)} g',
                            style: const TextStyle(fontSize: 32, color: Colors.orange),
                          ),
                        ],
                      ),
                      const Icon(Icons.monitor_weight, size: 48, color: Colors.orange),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final categoryItems = _items.where((i) => i.categoryId == category.id).length;
                  return Card(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/inventory');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('$categoryItems items'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/inventory');
                  },
                  icon: const Icon(Icons.list),
                  label: const Text('View All Inventory'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Items'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          final category = _categories.firstWhere((c) => c.id == item.categoryId);
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.orange,
              child: Icon(Icons.diamond, color: Colors.white),
            ),
            title: Text(item.name),
            subtitle: Text('${category.name} • ${item.purity}'),
            trailing: Text(
              '${item.weight}g',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Item feature coming soon!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
