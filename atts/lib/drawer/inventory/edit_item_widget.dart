import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditItemWidget extends StatefulWidget {
  final String itemId;
  final Map<String, dynamic> initialData;

  const EditItemWidget({super.key, required this.itemId, required this.initialData});

  @override
  State<EditItemWidget> createState() => _EditItemWidgetState();
}

class _EditItemWidgetState extends State<EditItemWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _itemNameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  String? _selectedDiscount;
  String? _selectedGST;

  final List<String> discountOptions = ['Nil', '5%', '10%', '15%', '20%'];
  final List<String> gstOptions = ['Nil', '5%', '12%', '18%', '28%'];

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.initialData['itemName']);
    _priceController = TextEditingController(text: widget.initialData['price'].toString());
    _quantityController = TextEditingController(text: widget.initialData['quantity'].toString());
    _selectedDiscount = widget.initialData['discount'];
    _selectedGST = widget.initialData['gst'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Inventory Item'),
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
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // Handle saving the item
              await FirebaseFirestore.instance.collection('inventory').doc(widget.itemId).update({
                'itemName': _itemNameController.text,
                'price': _priceController.text,  // Store as string
                'quantity': int.parse(_quantityController.text),  // Store as integer
                'discount': _selectedDiscount,
                'gst': _selectedGST,
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item updated successfully')),
              );
            }
          },
          child: const Text('Update'),
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
