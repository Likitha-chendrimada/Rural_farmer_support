import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarketPriceScreen extends StatefulWidget {
  const MarketPriceScreen({super.key});

  @override
  State<MarketPriceScreen> createState() => _MarketPriceScreenState();
}

class _MarketPriceScreenState extends State<MarketPriceScreen> {
  bool loading = true;
  String? errorMessage;
  List<MarketPrice> prices = [];

  @override
  void initState() {
    super.initState();
    fetchMarketPrices();
  }

  Future<void> fetchMarketPrices() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final url = Uri.parse(
        'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070'
        '?api-key=579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b'
        '&format=json&limit=50'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> list = data['records'] ?? [];
        final temp = list.map((e) {
          return MarketPrice(
            crop: e['commodity']?.toString() ?? '',
            state: e['state']?.toString() ?? '',
            district: e['district']?.toString() ?? '',
            market: e['market']?.toString() ?? '',
            variety: e['variety']?.toString() ?? '',
            price: e['modal_price']?.toString() ?? '',
          );
        }).toList();

        setState(() {
          prices = temp;
          loading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("💰 Market Price"),
        backgroundColor: Colors.purple,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : RefreshIndicator(
                  onRefresh: fetchMarketPrices,
                  child: ListView.builder(
                    itemCount: prices.length,
                    itemBuilder: (context, index) {
                      final mp = prices[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        elevation: 3,
                        child: ListTile(
                          leading: const Text(
                            "🧺",
                            style: TextStyle(fontSize: 26),
                          ),
                          title: Text(
                            "${mp.crop} (${mp.variety})",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                              "${mp.market}, ${mp.district}, ${mp.state}"),
                          trailing: Text(
                            "₹ ${mp.price}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                                fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class MarketPrice {
  final String crop;
  final String state;
  final String district;
  final String market;
  final String variety;
  final String price;

  MarketPrice({
    required this.crop,
    required this.state,
    required this.district,
    required this.market,
    required this.variety,
    required this.price,
  });
}
