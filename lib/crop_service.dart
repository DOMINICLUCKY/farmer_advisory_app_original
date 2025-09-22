class CropService {
  static Map<String, dynamic> generateAdvisory(String soil, String crop) {
    // Crop duration in days
    Map<String, int> cropDurations = {
      "Wheat": 120,
      "Rice": 150,
      "Maize": 110,
      "Mustard": 100,
      "Groundnut": 130,
    };

    // Advisory data
    Map<String, List<String>> advisory = {
      "Wheat": [
        "Prepare soil with ploughing and organic manure.",
        "Irrigate every 20 days.",
        "Apply urea at 30 and 60 days.",
        "Watch for rust disease around day 45.",
        "Harvest around 120 days.",
      ],
      "Rice": [
        "Flood soil before sowing.",
        "Maintain standing water for 60 days.",
        "Apply fertilizer after 30 and 60 days.",
        "Check for stem borer insects at 45 days.",
        "Harvest in 150 days.",
      ],
      "Maize": [
        "Loamy/sandy soil is best.",
        "Irrigate every 15 days.",
        "Fertilizer at 25 and 50 days.",
        "Check for leaf blight around 40 days.",
        "Harvest around 110 days.",
      ],
      "Mustard": [
        "Best in loamy soil.",
        "Irrigate once every 25 days.",
        "Apply fertilizer after 30 days.",
        "Spray pesticide for aphids after 45 days.",
        "Harvest in 100 days.",
      ],
      "Groundnut": [
        "Best in sandy soil.",
        "Irrigate every 10–12 days.",
        "Fertilizer at 30 and 60 days.",
        "Spray pesticide if leaf spot disease appears.",
        "Harvest in 130 days.",
      ],
    };

    int duration = cropDurations[crop] ?? 120;
    List<String> timeline = advisory[crop] ?? ["No advisory available"];

    return {
      "soil": soil,
      "crop": crop,
      "duration": duration,
      "timeline": timeline,
    };
  }
}
