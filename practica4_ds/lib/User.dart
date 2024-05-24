import 'pizza_builder.dart';

class User {
  final int id;
  final String name;
  List<PizzaBuilder> selectedPizzas;

  User({required this.id, required this.name, required this.selectedPizzas});

  void addPizza(PizzaBuilder pizza) {
    selectedPizzas.add(pizza);
  }

  double getTotalPrice() {
    double total = 0;
    for (var pizza in selectedPizzas) {
      total += pizza.pizzaPrice();
    }
    return total;
  }
}
