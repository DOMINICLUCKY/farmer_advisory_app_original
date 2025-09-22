class AiService {
  static Future<Map<String, dynamic>> getResponse(String userText) async {
    userText = userText.toLowerCase();

    if (userText.contains("weather") || userText.contains("mausam")) {
      return {
        "reply": "Aapke kshetra ka mausam khol raha hoon.",
        "route": "weather",
      };
    } else if (userText.contains("fertilizer") || userText.contains("khaad")) {
      return {"reply": "Khaad sujhav khol raha hoon.", "route": "fertilizer"};
    } else if (userText.contains("crop") ||
        userText.contains("fasal") ||
        userText.contains("soil")) {
      return {
        "reply": "Fasal aur mitti salaah khol raha hoon.",
        "route": "crop",
      };
    } else if (userText.contains("pest") ||
        userText.contains("disease") ||
        userText.contains("keeda")) {
      return {
        "reply": "Keet-patangan aur rog salaah khol raha hoon.",
        "route": "pest",
      };
    } else if (userText.contains("market") ||
        userText.contains("price") ||
        userText.contains("mandi")) {
      return {"reply": "Bazaar bhav khol raha hoon.", "route": "market"};
    }

    return {
      "reply": "Mujhe samajh nahi aaya. Kripya phir kahe.",
      "route": null,
    };
  }
}
