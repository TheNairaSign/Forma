enum FoodPreference {
  fish,
  snacks,
  protein,
  dairy,
  vegetables,
  fruits,
  organic,
  vegan,
  meat,
}

const assetPath = 'assets/svgs/food_preference';

Map<FoodPreference, String> foodPreferenceIcons = {
  FoodPreference.fish : '$assetPath/fish.svg',
  FoodPreference.snacks : '$assetPath/snacks.svg',
  FoodPreference.protein : '$assetPath/eggs.svg',
  FoodPreference.dairy : '$assetPath/milk.svg',
  FoodPreference.vegetables : '$assetPath/cauliflower.svg',
  FoodPreference.fruits : '$assetPath/fruits-pear.svg',
  FoodPreference.organic : '$assetPath/organic-nutrition.svg',
  FoodPreference.vegan : '$assetPath/falafel.svg',
  FoodPreference.meat : '$assetPath/steak-meat.svg',
};

extension FoodPreferenceExtension on FoodPreference {
  String get icon {
    return foodPreferenceIcons[this]!;
  }
}

extension FoodPreferenceString on FoodPreference {
  String get name {
    return toString().split('.').last;
  }
}

