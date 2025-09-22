class PestService {
  static Map<String, dynamic> identifyPest(String crop, String pest) {
    Map<String, Map<String, dynamic>> pests = {
      "Wheat": {
        "Rust": {
          "chemical": "Propiconazole 1ml/L water",
          "organic": "Neem oil spray 5%",
          "stage": "50 days after sowing",
        },
        "Aphids": {
          "chemical": "Imidacloprid 0.5ml/L water",
          "organic": "Soap solution spray",
          "stage": "Early vegetative stage",
        },
      },
      "Rice": {
        "Stem Borer": {
          "chemical": "Chlorpyrifos 2ml/L water",
          "organic": "Neem seed extract spray",
          "stage": "30–40 days after transplanting",
        },
        "Leaf Blast": {
          "chemical": "Tricyclazole 1g/L water",
          "organic": "Cow dung extract spray",
          "stage": "Tillering stage",
        },
      },
      "Maize": {
        "Fall Armyworm": {
          "chemical": "Spinosad 0.5ml/L water",
          "organic": "Neem leaf extract spray",
          "stage": "Seedling stage",
        },
        "Turcicum Leaf Blight": {
          "chemical": "Mancozeb 2g/L water",
          "organic": "Buttermilk spray",
          "stage": "Leaf stage",
        },
      },
      "Mustard": {
        "Aphids": {
          "chemical": "Dimethoate 1.5ml/L water",
          "organic": "Neem oil 5%",
          "stage": "Flowering stage",
        },
        "Powdery Mildew": {
          "chemical": "Sulphur dust 25kg/acre",
          "organic": "Garlic extract spray",
          "stage": "Late vegetative stage",
        },
      },
      "Groundnut": {
        "Leaf Spot": {
          "chemical": "Chlorothalonil 2g/L water",
          "organic": "Cow urine spray",
          "stage": "Vegetative stage",
        },
        "Rust": {
          "chemical": "Hexaconazole 1ml/L water",
          "organic": "Butter milk spray",
          "stage": "Pod development",
        },
      },
    };

    return pests[crop]?[pest] ??
        {"chemical": "No data available", "organic": "-", "stage": "-"};
  }
}
