import 'package:client_fast_musala/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'screens/search_screen.dart';
import 'screens/booking_screen.dart';

void main() => runApp(const ClientApp());

class ClientApp extends StatelessWidget {
  const ClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fast Musala Client',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),  // Remplacez SearchScreen
          '/search': (context) => const SearchScreen(),
          '/booking': (context) => const BookingScreen(artisan: {
            'name': 'Test Artisan',
            'service': 'Plombier',
            'image': 'assets/plumber.jpg'
          }),
        },
    );
  }
}