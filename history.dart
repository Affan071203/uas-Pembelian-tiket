import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EditOrderPage.dart'; // Import halaman EditOrderPage

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Map<String, dynamic>>> _purchasedMoviesFuture;

  @override
  void initState() {
    super.initState();
    _purchasedMoviesFuture = _fetchPurchasedMovies();
  }

  Future<List<Map<String, dynamic>>> _fetchPurchasedMovies() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('orders').get();
    if (querySnapshot.docs.isEmpty) {
      print("No documents found");
      return [];
    }

    List<Map<String, dynamic>> purchasedMovies = querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['documentId'] = doc.id; // Add document ID to the data
      return data;
    }).toList();

    return purchasedMovies;
  }

  void _editOrder(BuildContext context, String documentId, Map<String, dynamic> orderData) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditOrderPage(documentId: documentId, orderData: orderData)),
    ).then((_) {
      setState(() {
        _purchasedMoviesFuture = _fetchPurchasedMovies(); // Refresh the list after editing
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('History Page', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Purchased Movies:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _purchasedMoviesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No purchased movies found.', style: TextStyle(color: Colors.white)));
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> movie = snapshot.data![index];

                        String title = movie['filmTitle'] ?? 'No Title';
                        String name = movie['name'] ?? 'Unknown';
                        String address = movie['address'] ?? 'Unknown';
                        String filmId = movie['filmId'] ?? 'Unknown';
                        String purchaseDate = 'Unknown date';

                        if (movie['timestamp'] != null && movie['timestamp'] is Timestamp) {
                          Timestamp timestamp = movie['timestamp'];
                          DateTime dateTime = timestamp.toDate();
                          purchaseDate = dateTime.toLocal().toString().split(' ')[0];
                        }

                        return Card(
                          color: Colors.grey[900],
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Icon(Icons.movie, color: Colors.white),
                            title: Text(title, style: TextStyle(color: Colors.white)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Purchased by: $name', style: TextStyle(color: Colors.white70)),
                                Text('Address: $address', style: TextStyle(color: Colors.white70)),
                                Text('Film ID: $filmId', style: TextStyle(color: Colors.white70)),
                                Text('Purchased on: $purchaseDate', style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () => _editOrder(context, movie['documentId'], movie),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
