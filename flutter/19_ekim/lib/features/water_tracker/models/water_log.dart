enum DrinkType {
  water,
  tea,
  coffee,
  sportsDrink;

  String get displayName {
    switch (this) {
      case DrinkType.water:
        return 'Su';
      case DrinkType.tea:
        return 'Çay';
      case DrinkType.coffee:
        return 'Kahve';
      case DrinkType.sportsDrink:
        return 'Elektrolit / Spor';
    }
  }
}

class WaterLog {
  const WaterLog({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    this.type = DrinkType.water,
  });

  final String id;
  final int amountMl;
  final DateTime timestamp;
  final DrinkType type;
}
