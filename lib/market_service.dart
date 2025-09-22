class MarketService {
  static Future<List<Map<String, dynamic>>> fetchMarketPrices(
    String district,
    String state,
  ) async {
    // 🔹 Simulated API response for hackathon
    await Future.delayed(const Duration(seconds: 2));

    List<Map<String, dynamic>> data = [
      {
        "crop": "Wheat",
        "min": 1800,
        "max": 2000,
        "market": "Kalahandi Mandi",
        "date": "2025-09-20",
        "yesterday": 1900,
      },
      {
        "crop": "Rice",
        "min": 2200,
        "max": 2500,
        "market": "Kalahandi Mandi",
        "date": "2025-09-20",
        "yesterday": 2300,
      },
      {
        "crop": "Maize",
        "min": 1600,
        "max": 1750,
        "market": "Kalahandi Mandi",
        "date": "2025-09-20",
        "yesterday": 1700,
      },
      {
        "crop": "Mustard",
        "min": 4200,
        "max": 4500,
        "market": "Kalahandi Mandi",
        "date": "2025-09-20",
        "yesterday": 4400,
      },
      {
        "crop": "Groundnut",
        "min": 5000,
        "max": 5400,
        "market": "Kalahandi Mandi",
        "date": "2025-09-20",
        "yesterday": 5100,
      },
    ];

    return data;
  }
}
