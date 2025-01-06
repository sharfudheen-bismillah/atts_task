import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItemWidget extends StatefulWidget {
  const AddItemWidget({super.key});

  @override
  State<AddItemWidget> createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  String? _selectedDiscount;
  String? _selectedGST;

  final List<String> discountOptions = ['Nil', '5%', '10%', '15%', '20%'];
  final List<String> gstOptions = ['Nil', '5%', '12%', '18%', '28%'];

  Future<void> _addItemToFirestore() async {
    try {
      // Generate a new document in the 'inventory' collection
      final docRef = FirebaseFirestore.instance.collection('inventory').doc();

      // Save the data to Firestore
      await docRef.set({
        'id': docRef.id, // Firebase ID
        'itemName': _itemNameController.text,
        'price': _priceController.text,  // Store price as string
        'quantity': int.parse(_quantityController.text),  // Store quantity as integer
        'discount': _selectedDiscount ?? 'Nil',
        'gst': _selectedGST ?? 'Nil',
        'createdAt': FieldValue.serverTimestamp(), // Timestamp
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Inventory Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _itemNameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDiscount,
                items: discountOptions
                    .map((discount) => DropdownMenuItem(
                  value: discount,
                  child: Text(discount),
                ))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Discount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedDiscount = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a discount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGST,
                items: gstOptions
                    .map((gst) => DropdownMenuItem(
                  value: gst,
                  child: Text(gst),
                ))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'GST',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedGST = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select GST';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _addItemToFirestore(); // Save to Firestore
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
