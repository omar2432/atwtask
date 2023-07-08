import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/User';
import './screen/ProfileScreen';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final randomUserId = Random().nextInt(10) + 1; // Random user ID between 1 and 10
    return MaterialApp(
      title: 'Album Viewer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<User>(
        future: fetchUser(randomUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return ProfileScreen(user: user);
          } else {
            return Scaffold(body: Center(child: Text('No user found.')));
          }
        },
      ),
    );
  }

  Future<User> fetchUser(int userId) async {
    final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'));
    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return User.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
