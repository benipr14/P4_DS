import 'package:http/http.dart' as http;
import 'pizza_builder.dart';
import 'dart:convert';
import 'dart:math' as math;

class ApiClient {
  String baseUrl = 'http://127.0.0.1:3000';

  Future<int> getNextId() async {
    List<PizzaBuilder> allPizzas = await getPizzas();
    int id = 80;
    for (int i = 0; i < allPizzas.length; i++) {
      if (allPizzas[i].id > id) {
        id = allPizzas[i].id;
      }
    }

    return id + 1;
  }

  Future<List<PizzaBuilder>> getPizzas() async {
    final response = await http.get(Uri.parse('$baseUrl/pizzas'));

    if (response.statusCode == 200) {
      List pizzasJson = jsonDecode(response.body);
      return pizzasJson.map((pizza) {
        switch (pizza['name']) {
          case 'Pizza margarita':
            return MargheritaPizzaBuilder().fromJson(pizza);
          case 'Pizza pepperoni':
            return PepperoniPizzaBuilder().fromJson(pizza);
          case 'Pizza vegetal':
            return VeggiePizzaBuilder().fromJson(pizza);
          default:
            throw Exception('Unknown pizza type');
        }
      }).toList();
    } else {
      throw Exception('Failed to load pizzas');
    }
  }

  Future<void> addPizzaByName(PizzaBuilder p) async {
    // Asume que tienes un método `addPizzaToDatabase` que toma un `PizzaBuilder` y lo añade a la base de datos
    await addPizzaToDatabase(p);
  }

  Future<void> addPizzaToDatabase(PizzaBuilder pizzaBuilder) async {
    // Construye la pizza usando el PizzaBuilder
    PizzaBuilder pizza = pizzaBuilder;

    // Convierte la pizza en un mapa para poder enviarla como JSON
    Map<String, dynamic> pizzaJson = {
      'name': pizza.name,
      'dough': pizza.dough,
      'sauce': pizza.sauce,
      'price': pizza.price,
      'ingredients': pizza.ingredients,
      'dueño': pizza.dueno,
      'id': pizza.id,
    };

    // Realiza una solicitud POST a la API para añadir la pizza
    final response = await http.post(
      Uri.parse('$baseUrl/pizzas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pizzaJson),
    );

    // Comprueba si la solicitud fue exitosa
    if (response.statusCode != 201) {
      throw Exception('Failed to add pizza');
    }
  }

  Future<void> deletePizza(int id) async {
    // Realiza una solicitud DELETE a la API para eliminar la pizza
    final response = await http.delete(
      Uri.parse('$baseUrl/pizzas/$id'),
    );

    // Comprueba si la solicitud fue exitosa
    if (response.statusCode != 200) {
      throw Exception('Failed to delete pizza');
    }
  }
}
