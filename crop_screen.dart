// lib/screens/crop_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  // ✅ Your Firebase path (adjust if needed)
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref("users/users/crop_recommendations");

  List<Map<dynamic, dynamic>> cropsList = [];
  bool loading = true;

  // 🌐 language toggle state
  String selectedLanguage = "en"; // default English

  @override
  void initState() {
    super.initState();
    _fetchCrops();
  }

  Future<void> _fetchCrops() async {
    try {
      final snapshot = await dbRef.get();

      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final tempList = <Map<dynamic, dynamic>>[];

        data.forEach((key, value) {
          tempList.add({
            "name": key,
            "details": value,
          });
        });

        setState(() {
          cropsList = tempList;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("DEBUG: Error fetching crops: $e");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Information"),
        backgroundColor: Colors.green.shade700,
        actions: [
          PopupMenuButton<String>(
            icon: const Text("🌐", style: TextStyle(fontSize: 22)),
            onSelected: (value) {
              setState(() {
                selectedLanguage = value;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: "en", child: Text("English")),
              PopupMenuItem(value: "kn", child: Text("ಕನ್ನಡ")),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade100, // ✅ whole screen background
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : cropsList.isEmpty
              ? const Center(child: Text("No crops data available"))
              : ListView.builder(
                  itemCount: cropsList.length,
                  itemBuilder: (context, index) {
                    final crop = cropsList[index];
                    final details = crop["details"] as Map<dynamic, dynamic>;

                    return Card(
                      margin: const EdgeInsets.all(10),
                      color: Colors.lightGreen[50], // ✅ card background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Text("🌱", style: TextStyle(fontSize: 26)),
                        title: Text(
                          selectedLanguage == "en"
                              ? (details["crop_english"] ?? crop["name"])
                              : (details["crop_kannada"] ?? crop["name"]),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          selectedLanguage == "en"
                              ? "Season: ${details["season"] ?? "N/A"}\n"
                                  "Soil: ${details["soil_type"] ?? "N/A"}\n"
                                  "Duration: ${details["duration"] ?? "N/A"}\n"
                                  "Plantation: ${details["plantation_time"] ?? "N/A"}\n"
                                  "Location: ${details["location"] ?? "N/A"}\n"
                                  "Tips: ${details["tips_english"] ?? "N/A"}"
                              : "ಕಾಲ: ${details["season"] ?? "N/A"}\n"
                                  "ಮಣ್ಣು: ${details["soil_type"] ?? "N/A"}\n"
                                  "ಅವಧಿ: ${details["duration"] ?? "N/A"}\n"
                                  "ಬಿತ್ತನೆ: ${details["plantation_time"] ?? "N/A"}\n"
                                  "ಸ್ಥಳ: ${details["location"] ?? "N/A"}\n"
                                  "ಸಲಹೆಗಳು: ${details["tips_kannada"] ?? "N/A"}",
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
