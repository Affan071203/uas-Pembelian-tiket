import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditOrderPage extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> orderData;

  EditOrderPage({required this.documentId, required this.orderData});

  @override
  _EditOrderPageState createState() => _EditOrderPageState();
}

class _EditOrderPageState extends State<EditOrderPage> {
  late TextEditingController _filmTitleController;
  late TextEditingController _nameController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _filmTitleController = TextEditingController(text: widget.orderData['filmTitle']);
    _nameController = TextEditingController(text: widget.orderData['name']);
    _addressController = TextEditingController(text: widget.orderData['address']);
  }

  Future<void> _updateOrder() async {
    await FirebaseFirestore.instance.collection('orders').doc(widget.documentId).update({
      'filmTitle': _filmTitleController.text,
      'name': _nameController.text,
      'address': _addressController.text,
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Order'),
        backgroundColor: Colors.black, // Netflix uses black as the app bar color
        elevation: 0, // Remove elevation for a flat look
      ),
      backgroundColor: Colors.black, // Set background color to black
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Edit Order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildTextField(_filmTitleController, 'Film Title'),
            SizedBox(height: 20),
            _buildTextField(_nameController, 'Name'),
            SizedBox(height: 20),
            _buildTextField(_addressController, 'Address'),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _updateOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Netflix uses red for its buttons
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white), // Text color white
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)), // Label color white with opacity
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white), // Underline color white
        ),
      ),
    );
  }
}
