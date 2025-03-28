Map<String, List<String>> generateSleepPlan(Map<String, String> answers) {
  Map<String, List<String>> recommendations = {
    "Sleep": [],
    "Diet": [],
    "Environment": [],
    "Technology": [],
  };

  // 1. Determine Recommended Sleep Based on Age
  Map<String, List<int>> recommendedSleep = {
    "1-2": [11, 14],
    "3-5": [10, 13],
    "6-13": [9, 11]
  };

  String ageGroup = answers["age"] ?? "6-13";
  String sleepDuration = answers["sleep_duration"] ?? "9-11";

  Map<String, List<int>> sleepRanges = {
    "11-14": [11, 14],
    "9-11": [9, 11],
    "8-10": [8, 10]
  };

  List<int> userSleep = sleepRanges[sleepDuration] ?? [9, 11];
  List<int> recommended = recommendedSleep[ageGroup] ?? [9, 11];

  if (userSleep[1] < recommended[0]) {
    recommendations["Sleep"]!.add(
        "Your child may not be getting enough sleep. Try adjusting bedtime earlier to achieve ${recommended[0]}-${recommended[1]} hours per night.");
  }
  if (userSleep[0] > recommended[1]) {
    recommendations["Sleep"]!.add(
        "Your child may be oversleeping. Encourage daytime activities for a balanced sleep schedule.");
  }

  // 2. Sleep Drive Factors
  if (answers["physical_activity"] == "No" ||
      answers["physical_activity"] == "Sometimes") {
    recommendations["Sleep"]!
        .add("Encourage at least 30 minutes of outdoor activity daily.");
  }
  if (answers["consistent_wake_time"] == "No") {
    recommendations["Sleep"]!
        .add("Try setting a fixed wake-up time, even on weekends.");
  }

  // 3. Circadian Rhythm
  if (answers["consistent_sleep_times"] == "No") {
    recommendations["Sleep"]!.add(
        "Maintain consistent sleep and wake times to stabilize the body clock.");
  }
  if (answers["morning_light_exposure"] == "No") {
    recommendations["Environment"]!.add(
        "Expose your child to natural daylight within 30 minutes of waking up.");
  }
  if (answers["limit_bright_light"] == "No") {
    recommendations["Environment"]!.add(
        "Reduce screen and bright light exposure 1-2 hours before bedtime.");
  }

  // 4. Diet & Nutrition
  if (answers["large_meal_before_bed"] == "Yes") {
    recommendations["Diet"]!
        .add("Avoid heavy meals at least 2 hours before bedtime.");
  }
  if (answers["caffeine_consumption"] == "Yes") {
    recommendations["Diet"]!.add("Limit caffeine intake in the evening.");
  }
  if (answers["sleep_friendly_snacks"] == "No") {
    recommendations["Diet"]!
        .add("Offer sleep-friendly snacks like bananas, oats, or warm milk.");
  }

  // 5. Technology Use
  if (answers["screen_time_before_bed"] == "Yes") {
    recommendations["Technology"]!
        .add("Limit screen time at least an hour before bedtime.");
  }
  if (answers["devices_to_fall_asleep"] == "Yes") {
    recommendations["Technology"]!
        .add("Try replacing screen time with bedtime stories or white noise.");
  }

  // 6. Sleep Environment
  if (answers["bedroom_used_for_sleep"] == "No") {
    recommendations["Environment"]!
        .add("Ensure the bedroom is primarily used for sleeping.");
  }
  if (answers["bedroom_distractions"] == "Yes") {
    recommendations["Environment"]!
        .add("Remove distractions like toys and electronics from the bedroom.");
  }
  if (answers["darkness_preference"] == "Varies") {
    recommendations["Environment"]!
        .add("Try using a dim nightlight for a comfortable sleep setting.");
  }

  return recommendations;
}
