import 'pizza_builder.dart';
import 'payment_method.dart';
import 'package:flutter/material.dart';

class PizzaFacade {
  List<PizzaBuilder> _selectedPizzas = [];
  PaymentStrategy? _selectedPayment;

  List<PizzaBuilder> get selectedPizzas => _selectedPizzas;
  PaymentStrategy? get selectedPayment => _selectedPayment;

  void addPizza(PizzaBuilder pizzaBuilder) {
    _selectedPizzas.add(pizzaBuilder);
  }

  double totalPrice() {
    double total = 0.0;
    for (var pizza in _selectedPizzas) {
      total += pizza.pizzaPrice();
    }
    return _selectedPayment != null
        ? _selectedPayment!.calculatePrice(total)
        : total;
  }

  void selectPayment(PaymentStrategy paymentStrategy) {
    _selectedPayment = paymentStrategy;
  }

  void clearPizzas() {
    _selectedPizzas.clear();
  }

  void eliminarPizza(PizzaBuilder pizzaBuilder) {
    _selectedPizzas.remove(pizzaBuilder);
  }
}
