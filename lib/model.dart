import 'package:equatable/equatable.dart';

class Cake {
  const Cake(
    this.pieces,
    this.topping,
    this.hasGluten,
  );

  final int pieces;
  final String topping;
  final bool hasGluten;

  @override
  String toString() {
    return "Cake: $pieces, $topping, ${hasGluten ? 'has gluten' : 'gluten-free'}";
  }
}

class Guest extends Equatable {
  const Guest(
    this.name,
    this.favoriteToppings,
    this.glutenAllergic,
  );

  final String name;
  final List<String> favoriteToppings;
  final bool glutenAllergic;

  @override
  List<Object> get props => [name, favoriteToppings, glutenAllergic];
}

class CakeTopping {
  static const vanilla = 'Vanilla';
  static const chocolate = 'Chocolate';
  static const strawberry = 'Strawberry';
  static const apple = 'Apple';
  static const cherie = 'Cherie';
}
