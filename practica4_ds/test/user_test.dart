import 'package:flutter_test/flutter_test.dart';

import 'package:p3_ds_ultima/pizza_builder.dart';
import 'package:p3_ds_ultima/User.dart';

void main() {
  //Test para MargheritaPizzaBuilder
  group('Builder margarita', () {
    PizzaBuilder margherita = MargheritaPizzaBuilder();
    //User({required this.id, required this.name, required this.selectedPizzas});
    User user = User(id: 1, name: 'User', selectedPizzas: []);

    test('creacion correcta', () {
      expect(margherita.getName(), 'Pizza margarita');
    });

    test('precio correcto', () {
      expect(margherita.pizzaPrice(), 8.0);
    });

    test('ingredientes correctos', () {
      margherita.setIngredients();
      expect(margherita.getIngredients(),
          ['Mozzarella cheese', 'Fresh basil', 'Tomato sauce']);
    });

    test('masa correcta', () {
      expect(margherita.getDough(), 'Thin crust');
    });

    test('salsa correcta', () {
      expect(margherita.getSauce(), 'Tomato sauce');
    });

    test('añadir ingrediente', () {
      margherita.addIngredient('jamon');
      expect(margherita.getIngredients().length, 4);
      expect(margherita.getIngredients(),
          ['Mozzarella cheese', 'Fresh basil', 'Tomato sauce', 'jamon']);
    });

    test('addPizza', () {
      user.addPizza(margherita);
      expect(user.selectedPizzas.length, 1);
    });

    test('getTotalPrice', () {
      expect(user.getTotalPrice(), 8.0);
    });

  });
}