// lib/screens/home_details_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDetailsScreen extends StatelessWidget {
  const HomeDetailsScreen({super.key});

  // Helper to build each menu card
  Widget _buildMenuCard(
      BuildContext context, String label, String emoji, Color color, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 42)),
                const SizedBox(height: 12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Samagra Krishi - Explore"),
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0f7fa), Color(0xFFffffff)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildMenuCard(
                context,
                "Weather Updates",
                "🌦️",
                Colors.lightBlue,
                "/weather",
              ),
              _buildMenuCard(
                context,
                "Crop Information",
                "🌱",
                Colors.green,
                "/crops",
              ),
              _buildMenuCard(
                context,
                "Government Schemes",
                "🏛️",
                Colors.orange,
                "/schemes",
              ),
              _buildMenuCard(
                context,
                "Market Price",
                "💰",
                Colors.purple,
                "/marketprice", // 👈 make sure you added this route in main.dart
              ),
            ],
          ),
        ),
      ),
    );
  }
}
