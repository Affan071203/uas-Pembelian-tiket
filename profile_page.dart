import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'main.dart'; // Import halaman login Anda

class ProfilePage extends StatelessWidget {
  final String email;

  ProfilePage({required this.email});

  void _logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut(); // Log out dari Firebase
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Ganti dengan halaman login Anda
    );
  }

  Future<String?> _fetchProfilePicture() async {
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(email).get();
    if (userDoc.exists) {
      return userDoc.data()?['profilePicture'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<String?>(
              future: _fetchProfilePicture(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  );
                } else {
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(snapshot.data!),
                    child: ClipOval(
                      child: Image.network(
                        snapshot.data!,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Icon(Icons.person, size: 50);
                        },
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Text('Email: $email'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logOut(context),
              child: Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Ubah warna tombol jika diinginkan
              ),
            ),
          ],
        ),
      ),
    );
  }
}
