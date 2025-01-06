import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../drawer_widget.dart';
import 'bill_generation.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({Key? key}) : super(key: key);

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final List<Map<String, dynamic>> _selectedItems = [];
  List<Map<String, dynamic>> _suggestions = [];
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _itemNameController.addListener(_onItemNameChanged);
  }

  @override
  void dispose() {
    _itemNameController.removeListener(_onItemNameChanged);
    _itemNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _onItemNameChanged() async {
    final query = _itemNameController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _isDropdownOpen = false;
      });
      return;
    }

    var snapshot = await FirebaseFirestore.instance.collection('inventory').get();

    setState(() {
      _suggestions = snapshot.docs
          .map((doc) => {
        'id': doc.id,
        'itemName': doc['itemName'],
        'price': doc['price'],
        'gst': doc['gst'],
        'discount': doc['discount'],
      })
          .where((item) =>
          item['itemName'].toString().toLowerCase().contains(query))
          .toList();
      _isDropdownOpen = _suggestions.isNotEmpty;
    });
  }

  void _addItem() {
    if (_itemNameController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
      final enteredItemName = _itemNameController.text.trim();
      final selectedItem = _suggestions.firstWhere(
            (item) => item['itemName'].trim().toLowerCase() == enteredItemName.toLowerCase(),
        orElse: () => <String, dynamic>{},
      );

      if (selectedItem.isNotEmpty) {
        final quantity = int.tryParse(_quantityController.text) ?? 0;
        if (quantity > 0) {
          _updateOrAddItem(selectedItem, quantity);
          _clearFields();
        } else {
          _showSnackBar("Please enter a valid quantity");
        }
      } else {
        _showSnackBar("Item does not exist");
      }
    } else {
      _showSnackBar("Please enter both item name and quantity");
    }
  }

  void _updateOrAddItem(Map<String, dynamic> item, int quantity) {
    final existingItemIndex = _selectedItems.indexWhere((selectedItem) => selectedItem['item']['id'] == item['id']);

    if (existingItemIndex >= 0) {
      setState(() {
        _selectedItems[existingItemIndex]['quantity'] += quantity;
        _updateItemAmount(existingItemIndex);
      });
    } else {
      _addNewItem(item, quantity);
    }
  }

  void _addNewItem(Map<String, dynamic> item, int quantity) {
    double price = _parseToDouble(item['price']);
    double gst = _parseToDouble(item['gst']);
    double discount = _parseToDouble(item['discount']);

    double totalPrice = price * quantity;
    double priceAfterTax = totalPrice * (1 + gst / 100);
    double finalAmount = priceAfterTax * (1 - discount / 100);

    setState(() {
      _selectedItems.add({
        'item': item,
        'quantity': quantity,
        'totalPrice': totalPrice,
        'priceAfterTax': priceAfterTax,
        'finalAmount': finalAmount,
      });
    });
  }

  void _updateItemAmount(int index) {
    var item = _selectedItems[index];
    double price = _parseToDouble(item['item']['price']);
    double gst = _parseToDouble(item['item']['gst']);
    double discount = _parseToDouble(item['item']['discount']);

    double totalPrice = price * item['quantity'];
    double priceAfterTax = totalPrice * (1 + gst / 100);
    double finalAmount = priceAfterTax * (1 - discount / 100);

    setState(() {
      _selectedItems[index]['totalPrice'] = totalPrice;
      _selectedItems[index]['priceAfterTax'] = priceAfterTax;
      _selectedItems[index]['finalAmount'] = finalAmount;
    });
  }

  double _parseToDouble(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 0.0;
    }
    return double.tryParse(value.toString()) ?? 0.0;
  }

  void _clearFields() {
    setState(() {
      _itemNameController.clear();
      _quantityController.clear();
      _suggestions = [];
      _isDropdownOpen = false;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _generateBill() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BillGeneration(
          selectedItems: _selectedItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(size: 30, color: Colors.white),
        title: const Text(
          'Sale',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
      ),
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            TextField(
                              controller: _itemNameController,
                              decoration: const InputDecoration(
                                labelText: 'Item Name',
                                border: OutlineInputBorder(),
                              ),
                              onTap: () {
                                setState(() {
                                  _isDropdownOpen = _suggestions.isNotEmpty;
                                });
                              },
                            ),
                            if (_isDropdownOpen)
                              Container(
                                height: 200,
                                child: ListView.builder(
                                  itemCount: _suggestions.length,
                                  itemBuilder: (context, index) {
                                    final item = _suggestions[index];
                                    return ListTile(
                                      title: Text(item['itemName']),
                                      onTap: () {
                                        setState(() {
                                          _itemNameController.text = item['itemName'];
                                          _isDropdownOpen = false;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _quantityController,
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _addItem,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          ItemListWidget(
            selectedItems: _selectedItems,
            onGenerateBill: _generateBill,
          ),
        ],
      ),
    );
  }
}

class ItemListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> selectedItems;
  final VoidCallback onGenerateBill;

  const ItemListWidget({
    Key? key,
    required this.selectedItems,
    required this.onGenerateBill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double finalAmount = selectedItems.fold(0.0, (sum, item) => sum + item['finalAmount']);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (selectedItems.isEmpty)
            const Text('No items added yet'),
          if (selectedItems.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  final item = selectedItems[index];
                  return ListTile(
                    title: Text(item['item']['itemName']),
                    subtitle: Text('Qty: ${item['quantity']} x ₹${item['item']['price']}'),
                    trailing: Text('₹${item['finalAmount'].toStringAsFixed(2)}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Final Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('₹${finalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onGenerateBill,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Generate Bill',style: TextStyle(color: Colors.white),),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

