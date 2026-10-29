import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'services/users_SurvivalItems.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  late Future<UsersItems> _itemsFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _itemsFuture = _fetchItems();
  }

  Future<UsersItems> _fetchItems() async {
    final response = await http.get(Uri.parse(usersItemsApiUrl));

    if (response.statusCode != 200) {
      throw Exception('Unable to load items (${response.statusCode}).');
    }

    return usersItemsFromJson(response.body);
  }

  void _showAcquisitionInfo(String itemName) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF181A12),
        title: Text(
          'How to acquire $itemName',
          style: const TextStyle(color: Color(0xFFC6CC7D)),
        ),
        content: const Text(
          'Task drop information will be available here in a future update.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFFC6CC7D)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A12),
      appBar: AppBar(
        title: const Text('Survival Items'),
        backgroundColor: const Color.fromARGB(255, 17, 19, 13),
        foregroundColor: const Color(0xFFC6CC7D),
      ),
      body: FutureBuilder<UsersItems>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Could not load items.\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final items = snapshot.data?.data ?? [];
          if (items.isEmpty) {
            return const Center(
              child: Text(
                'No items found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final query = _searchQuery.toLowerCase();
          final filteredItems = items.where((item) {
            return item.quantity > 0 &&
                (item.name.toLowerCase().contains(query) ||
                    item.category.toLowerCase().contains(query) ||
                    item.description.toLowerCase().contains(query));
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search items',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFFC6CC7D),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF515525),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredItems.isEmpty
                    ? const Center(
                        child: Text(
                          'No available items found.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return Card(
                            color: const Color(0xFF515525),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Image.network(
                                      item.image,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.inventory_2,
                                                color: Color(0xFFC6CC7D),
                                                size: 40,
                                              ),
                                    ),
                                    title: Text(
                                      item.name,
                                      style: const TextStyle(
                                        color: Color(0xFFC6CC7D),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${item.category} | Qty: ${item.quantity}\n${item.description}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    isThreeLine: true,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: FilledButton.icon(
                                      onPressed: () =>
                                          _showAcquisitionInfo(item.name),
                                      icon: const Icon(Icons.info_outline),
                                      label: const Text('How to acquire'),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFC6CC7D,
                                        ),
                                        foregroundColor: const Color(
                                          0xFF181A12,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
