import 'package:flutter/material.dart';
import 'market_service.dart';
import 'package:fl_chart/fl_chart.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  List<Map<String, dynamic>> prices = [];
  bool isLoading = false;
  String error = "";
  String? selectedCrop;
  Map<String, dynamic>? selectedPrice;

  @override
  void initState() {
    super.initState();
    _loadPrices();
  }

  Future<void> _loadPrices() async {
    setState(() {
      isLoading = true;
      error = "";
    });

    try {
      String district = "Kalahandi"; // 🔹 replace with profile location
      String state = "Odisha";

      final data = await MarketService.fetchMarketPrices(district, state);
      setState(() {
        prices = data;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📈 Market Prices"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadPrices),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error.isNotEmpty
            ? Center(child: Text("❌ $error"))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedCrop,
                    decoration: const InputDecoration(
                      labelText: "Select Crop",
                      border: OutlineInputBorder(),
                    ),
                    items: prices
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item["crop"] as String,
                            child: Text(item["crop"] as String),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCrop = value;
                        selectedPrice = prices.firstWhere(
                          (item) => item["crop"] == value,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  if (selectedPrice != null) _buildPriceCard(selectedPrice!),
                ],
              ),
      ),
    );
  }

  Widget _buildPriceCard(Map<String, dynamic> item) {
    int todayMax = item["max"];
    int yesterday = item["yesterday"];
    double changePercent =
        ((todayMax - yesterday) / yesterday.toDouble()) * 100;

    Color trendColor = changePercent >= 0 ? Colors.green : Colors.red;
    String trendArrow = changePercent >= 0 ? "⬆" : "⬇";

    // 🔹 Dummy 7-day price history (replace with API/Firebase later)
    List<int> last7Days = [
      item["yesterday"] - 100,
      item["yesterday"] - 50,
      item["yesterday"],
      item["max"] - 100,
      item["max"] - 50,
      item["max"],
      item["max"] + 50,
    ];

    return Expanded(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item["crop"],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              Text("Market: ${item["market"]}"),
              Text("Date: ${item["date"]}"),
              const SizedBox(height: 8),
              Text("💰 Min Price: ₹${item["min"]}"),
              Text("💰 Max Price: ₹${item["max"]}"),
              const SizedBox(height: 8),
              Text("📊 Yesterday: ₹$yesterday"),
              Text(
                "📉 Change: ${changePercent.toStringAsFixed(2)}% $trendArrow",
                style: TextStyle(
                  color: trendColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "📊 Last 7 Days Trend",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        spots: last7Days
                            .asMap()
                            .entries
                            .map(
                              (e) =>
                                  FlSpot(e.key.toDouble(), e.value.toDouble()),
                            )
                            .toList(),
                        barWidth: 4,
                        color: trendColor,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
