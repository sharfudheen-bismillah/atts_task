import 'package:atts/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _gstnController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAboutDetails();
  }

  // Function to load data from Firestore
  Future<void> _loadAboutDetails() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('about_details')
        .doc('company_info')
        .get();

    if (documentSnapshot.exists) {
      var data = documentSnapshot.data() as Map<String, dynamic>;
      _companyNameController.text = data['company_name'] ?? '';
      _gstnController.text = data['gstn'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _emailController.text = data['email'] ?? '';
      _addressController.text = data['address'] ?? '';
    }
  }

  // Function to save data to Firestore
  Future<void> _saveAboutDetails() async {
    await FirebaseFirestore.instance.collection('about_details').doc('company_info').set({
      'company_name': _companyNameController.text,
      'gstn': _gstnController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'address': _addressController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Company details saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(size: 30, color: Colors.white),
        title: const Text(
          'Company details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
      ),
      drawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(
              controller: _companyNameController,
              label: 'Company Name',
              icon: Icons.business,
            ),
            _buildTextField(
              controller: _gstnController,
              label: 'GSTN',
              icon: Icons.business_center,
            ),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone',
              icon: Icons.phone,
            ),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
            ),
            _buildTextField(
              controller: _addressController,
              label: 'Address',
              icon: Icons.location_on,
              isMultiline: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAboutDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Set button color to purple
              ),
              child: const Text(
                'Save Details',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          // Removed the suffixIcon part to disable the clear button
        ),
        maxLines: isMultiline ? 3 : 1,
      ),
    );
  }
}
