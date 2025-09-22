class FertilizerService {
  static Map<String, dynamic> getFertilizerPlan(String soil, String crop) {
    Map<String, Map<String, dynamic>> plans = {
      "Wheat": {
        "fertilizers": [
          {
            "name": "Urea",
            "qty": "40 kg/acre",
            "day": 1,
            "stage": "Basal at sowing",
          },
          {
            "name": "DAP",
            "qty": "50 kg/acre",
            "day": 15,
            "stage": "After first irrigation",
          },
          {
            "name": "Urea",
            "qty": "80 kg/acre",
            "day": 30,
            "stage": "Top Dressing",
          },
        ],
        "advice": "Irrigate at 20 days. Split urea in 2–3 doses.",
      },
      "Rice": {
        "fertilizers": [
          {
            "name": "DAP",
            "qty": "60 kg/acre",
            "day": 1,
            "stage": "Before transplanting",
          },
          {
            "name": "Urea",
            "qty": "40 kg/acre",
            "day": 20,
            "stage": "Tillering stage",
          },
          {
            "name": "Urea",
            "qty": "60 kg/acre",
            "day": 45,
            "stage": "Panicle initiation",
          },
        ],
        "advice": "Maintain standing water for 2 weeks after transplanting.",
      },
      "Maize": {
        "fertilizers": [
          {"name": "DAP", "qty": "40 kg/acre", "day": 1, "stage": "Basal dose"},
          {
            "name": "Urea",
            "qty": "40 kg/acre",
            "day": 20,
            "stage": "Vegetative stage",
          },
          {
            "name": "Potash",
            "qty": "30 kg/acre",
            "day": 35,
            "stage": "Flowering stage",
          },
        ],
        "advice":
            "Avoid waterlogging. Apply micronutrients if leaves turn yellow.",
      },
      "Mustard": {
        "fertilizers": [
          {"name": "DAP", "qty": "25 kg/acre", "day": 1, "stage": "Basal"},
          {
            "name": "Urea",
            "qty": "25 kg/acre",
            "day": 20,
            "stage": "Top dressing",
          },
        ],
        "advice": "Irrigate lightly at flowering stage to improve yield.",
      },
      "Groundnut": {
        "fertilizers": [
          {"name": "Gypsum", "qty": "200 kg/acre", "day": 1, "stage": "Basal"},
          {
            "name": "Urea",
            "qty": "40 kg/acre",
            "day": 25,
            "stage": "Vegetative stage",
          },
          {
            "name": "Potash",
            "qty": "30 kg/acre",
            "day": 40,
            "stage": "Pod formation",
          },
        ],
        "advice":
            "Avoid excess water. Spray fungicide for leaf spot if needed.",
      },
    };

    return plans[crop] ??
        {"fertilizers": [], "advice": "No data available for this crop."};
  }
}
