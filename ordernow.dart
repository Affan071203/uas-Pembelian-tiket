import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class orderNow extends StatelessWidget {
  final String documentId;
  final String filmTitle;

  orderNow({required this.documentId, required this.filmTitle});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _placeOrder(BuildContext context) async {
    String name = _nameController.text.trim();
    String address = _addressController.text.trim();

    if (name.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'filmId': documentId,
        'filmTitle': filmTitle,
        'name': name,
        'address': address,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context); // Close the orderNow
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pesanan berhasil')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place order: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Film Title: $filmTitle',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Delivery Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
           ElevatedButton(
  onPressed: () => _placeOrder(context),
  child: Text('Place Order'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red, // Ubah warna latar belakang tombol menjadi merah
  ),
),

          ],
        ),
      ),
    );
  }
}
