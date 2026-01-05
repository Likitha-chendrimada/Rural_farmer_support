// lib/screens/scheme_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class SchemeScreen extends StatefulWidget {
  const SchemeScreen({super.key});

  @override
  State<SchemeScreen> createState() => _SchemeScreenState();
}

class _SchemeScreenState extends State<SchemeScreen> {
  // ✅ Correct Firebase path
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref('users/users/government_schemes');

  List<Map<String, dynamic>> schemesList = [];
  bool loading = true;

  // 🌐 Language toggle state
  String selectedLanguage = "en"; // default English

  @override
  void initState() {
    super.initState();
    _fetchSchemes();
  }

  Future<void> _fetchSchemes() async {
    try {
      final snapshot = await dbRef.get();

      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final tempList = <Map<String, dynamic>>[];

        data.forEach((key, value) {
          final details = <String, dynamic>{};
          if (value is Map) {
            value.forEach((k, v) {
              details['$k'] = v;
            });
          }
          tempList.add({
            'key': '$key',
            'details': details,
          });
        });

        setState(() {
          schemesList = tempList;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e, st) {
      debugPrint("DEBUG: Error fetching schemes: $e\n$st");
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _openLink(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $url: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Government Schemes'),
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
      backgroundColor: Colors.grey.shade100,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : schemesList.isEmpty
              ? const Center(child: Text("No schemes data available"))
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: schemesList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final scheme = schemesList[index];
                    final details =
                        Map<String, dynamic>.from(scheme['details'] ?? {});

                    final titleEnglish = details['title_english']?.toString();
                    final titleKannada = details['title_kannada']?.toString();
                    final descriptionKannada =
                        details['description_kannada']?.toString();
                    final benifits = details['benifits']?.toString();
                    final applicationLink =
                        details['application_link']?.toString();
                    final createdAt = details['created_at']?.toString();

                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      color: Colors.lightGreen[50], // ✅ Background color added
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('📜', style: TextStyle(fontSize: 30)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    selectedLanguage == "en"
                                        ? (titleEnglish ??
                                            scheme['key'] ??
                                            'Untitled')
                                        : (titleKannada ??
                                            scheme['key'] ??
                                            'Untitled'),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Scheme details
                            if (selectedLanguage == "en") ...[
                              if (benifits != null && benifits.isNotEmpty)
                                Text('🎁 Benefits: $benifits'),
                              if (createdAt != null && createdAt.isNotEmpty)
                                Text('📅 Created At: $createdAt'),
                            ] else ...[
                              if (descriptionKannada != null &&
                                  descriptionKannada.isNotEmpty)
                                Text('📝 ವಿವರ: $descriptionKannada'),
                              if (createdAt != null && createdAt.isNotEmpty)
                                Text('📅 ರಚಿಸಿದ ದಿನಾಂಕ: $createdAt'),
                            ],

                            const SizedBox(height: 8),

                            // Link row
                            if (applicationLink != null &&
                                applicationLink.isNotEmpty)
                              GestureDetector(
                                onTap: () => _openLink(applicationLink),
                                child: Text(
                                  '🔗 ${selectedLanguage == "en" ? "Apply / More" : "ಅರ್ಜಿಸು / ಇನ್ನಷ್ಟು"}: $applicationLink',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
