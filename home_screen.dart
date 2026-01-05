import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Samagra Krishi", style: GoogleFonts.poppins())),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0f7fa), Color(0xFFffffff)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "“The future of India lies in the hands of our farmers 🌾”",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset("assets/images/tractor.png",
                          width: 80, height: 80, fit: BoxFit.contain),
                      const SizedBox(height: 6),
                      Text("Tractor",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.brown)),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset("assets/images/farmer.png",
                          width: 80, height: 80, fit: BoxFit.contain),
                      const SizedBox(height: 6),
                      Text("Farmer",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.brown)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/weather'),
                      child: const FancyBox(
                          color: Colors.lightBlue,
                          imagePath: 'assets/images/weather.jpg',
                          label: "Weather"),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/crops'),
                      child: const FancyBox(
                          color: Colors.lightGreen,
                          imagePath: 'assets/images/crops.jpg',
                          label: "Crops"),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/schemes'),
                      child: const FancyBox(
                          color: Colors.orange,
                          imagePath: 'assets/images/schemes.jpg',
                          label: "Schemes"),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.green.shade700,
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeDetailsScreen()),
                  );
                },
                child: Center(
                  child: Text(
                    "Click here to continue",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// -----------------
/// FANCY BOX WIDGET
/// -----------------
class FancyBox extends StatelessWidget {
  final Color color;
  final String imagePath;
  final String label;

  const FancyBox(
      {super.key,
      required this.color,
      required this.imagePath,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 6))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
