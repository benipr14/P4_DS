// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:p3_ds_ultima/main.dart';
import 'package:p3_ds_ultima/pizza_fachada.dart';
import 'package:p3_ds_ultima/pizza_builder.dart';
import 'package:p3_ds_ultima/payment_method.dart';

void main() {
  group('Fachada', () {
    PizzaFacade pizzaFacade = PizzaFacade();
    PizzaBuilder margherita = MargheritaPizzaBuilder();
    PizzaBuilder pepperoni = PepperoniPizzaBuilder();
    PizzaBuilder veggie = VeggiePizzaBuilder();

    test('Creacion correcta PizzaFacade', () {
      expect(pizzaFacade.selectedPizzas, []);
      expect(pizzaFacade.selectedPayment, null);
    });

    test('Añadir pizza', () {
      pizzaFacade.addPizza(margherita);
      expect(pizzaFacade.selectedPizzas.length, 1);
      expect(pizzaFacade.selectedPizzas[0].getName(), 'Pizza margarita');

      pizzaFacade.addPizza(pepperoni);
      expect(pizzaFacade.selectedPizzas.length, 2);
      expect(pizzaFacade.selectedPizzas[1].getName(), 'Pizza pepperoni');
    });

    test('Eliminar pizza', () {
      pizzaFacade.eliminarPizza(margherita);
      expect(pizzaFacade.selectedPizzas.length, 1);
      expect(pizzaFacade.selectedPizzas[0].getName(), 'Pizza pepperoni');
    });

    test('precio', () {
      pizzaFacade.addPizza(veggie);
      expect(pizzaFacade.totalPrice(), 19.0);
    });

    test('seleccionar metodo de pago', () {
      pizzaFacade.selectPayment(CashPaymentStrategy());
      expect(pizzaFacade.totalPrice(), 19.0);
      pizzaFacade.selectPayment(CardPaymentStrategy());
      expect(pizzaFacade.totalPrice(), 19 * 0.9);
    });

    test('Limpiar pizzas', () {
      pizzaFacade.clearPizzas();
      expect(pizzaFacade.selectedPizzas, []);
    });
  });
}
