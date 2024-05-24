// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:p3_ds_ultima/main.dart';

import 'package:p3_ds_ultima/pizza_builder.dart';

void main() {
  //Test para MargheritaPizzaBuilder
  group('Builder margarita', () {
    PizzaBuilder margherita = MargheritaPizzaBuilder();


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

    test('fromJson', () {
      Map<String, dynamic> json = {
        'name': 'Margherita',
        'dough': 'Thin crust',
        'sauce': 'Tomato sauce',
        'id': 1,
        'dueño': 'Francisco',
        'ingredients': ['Mozzarella cheese', 'Fresh basil', 'Tomato sauce'],
        'price': 8.0
      };
      PizzaBuilder margheritaFromJson = MargheritaPizzaBuilder().fromJson(json);
      expect(margheritaFromJson.getName(), 'Margherita');
      expect(margheritaFromJson.getDough(), 'Thin crust');
      expect(margheritaFromJson.getSauce(), 'Tomato sauce');
      expect(margheritaFromJson.getIngredients(),
          ['Mozzarella cheese', 'Fresh basil', 'Tomato sauce']);
      expect(margheritaFromJson.pizzaPrice(), 8.0);
      expect(margheritaFromJson.getId(), 1);
      expect(margheritaFromJson.getDueno(), 'Francisco');
    });

    test('toJson', () {
      Map<String, dynamic> json = margherita.toJson();
      expect(json['name'], 'Pizza margarita');
      expect(json['dough'], 'Thin crust');
      expect(json['sauce'], 'Tomato sauce');
      expect(json['ingredients'],
          ['Mozzarella cheese', 'Fresh basil', 'Tomato sauce', 'jamon']);
      expect(json['price'], 8.0);
      expect(json['id'], 0);
      expect(json['dueño'], '');
    });
  });

  group('builder pepperoni', () {
    PizzaBuilder pepperoni = PepperoniPizzaBuilder();

    test('creacion correcta', () {
      expect(pepperoni.getName(), 'Pizza pepperoni');
    });

    test('precio correcto', () {
      expect(pepperoni.pizzaPrice(), 10.0);
    });

    test('ingredientes correctos', () {
      pepperoni.setIngredients();
      expect(pepperoni.getIngredients(), [
        'Pepperoni',
        'Mozzarella cheese',
        'Mushrooms',
        'Onions',
        'Tomato sauce'
      ]);
    });

    test('masa correcta', () {
      expect(pepperoni.getDough(), 'Thick crust');
    });

    test('salsa correcta', () {
      expect(pepperoni.getSauce(), 'Tomato sauce');
    });

    test('añadir ingrediente', () {
      pepperoni.addIngredient('jamon');
      expect(pepperoni.getIngredients().length, 6);
    });

    test('fromJson', () {
      Map<String, dynamic> json = {
        'name': 'Pizza pepperoni',
        'dough': 'Thick crust',
        'sauce': 'Tomato sauce',
        'ingredients': [
          'Pepperoni',
          'Mozzarella cheese',
          'Mushrooms',
          'Onions',
          'Tomato sauce'
        ],
        'id': 1,
        'dueño': 'Helena',
        'price': 10.0
      };
      PizzaBuilder pepperoniFromJson = PepperoniPizzaBuilder().fromJson(json);
      expect(pepperoniFromJson.getName(), 'Pizza pepperoni');
      expect(pepperoniFromJson.getDough(), 'Thick crust');
      expect(pepperoniFromJson.getSauce(), 'Tomato sauce');
      expect(pepperoniFromJson.getIngredients(), [
        'Pepperoni',
        'Mozzarella cheese',
        'Mushrooms',
        'Onions',
        'Tomato sauce'
      ]);
      expect(pepperoniFromJson.pizzaPrice(), 10.0);
      expect(pepperoniFromJson.getId(), 1);
      expect(pepperoniFromJson.getDueno(), 'Helena');
    });

    test('toJson', () {
      Map<String, dynamic> json = pepperoni.toJson();
      expect(json['name'], 'Pizza pepperoni');
      expect(json['dough'], 'Thick crust');
      expect(json['sauce'], 'Tomato sauce');
      expect(json['ingredients'], [
        'Pepperoni',
        'Mozzarella cheese',
        'Mushrooms',
        'Onions',
        'Tomato sauce',
        'jamon'
      ]);
      expect(json['price'], 10.0);
      expect(json['id'], 0);
      expect(json['dueño'], '');
    });
  });

  group('builder veggie', () {
    PizzaBuilder veggie = VeggiePizzaBuilder();

    test('creacion correcta', () {
      expect(veggie.getName(), 'Pizza vegetal');
    });

    test('precio correcto', () {
      expect(veggie.pizzaPrice(), 9.0);
    });

    test('ingredientes correctos', () {
      veggie.setIngredients();
      expect(veggie.getIngredients(), [
        'Mushrooms',
        'Bell peppers',
        'Onions',
        'Black olives',
        'Spinach',
        'Tomato sauce'
      ]);
    });

    test('masa correcta', () {
      expect(veggie.getDough(), 'Thin crust');
    });

    test('salsa correcta', () {
      expect(veggie.getSauce(), 'Tomato sauce');
    });

    test('añadir ingrediente', () {
      veggie.addIngredient('lechuga');
      expect(veggie.getIngredients().length, 7);
    });

    test('fromJson', () {
      Map<String, dynamic> json = {
        'name': 'Pizza vegetal',
        'dough': 'Thin crust',
        'sauce': 'Tomato sauce',
        'ingredients': [
          'Mushrooms',
          'Bell peppers',
          'Onions',
          'Black olives',
          'Spinach',
          'Tomato sauce'
        ],
        'price': 9.0,
        'id': 1,
        'dueño': 'Francisco'
      };
      PizzaBuilder veggieFromJson = VeggiePizzaBuilder().fromJson(json);
      expect(veggieFromJson.getName(), 'Pizza vegetal');
      expect(veggieFromJson.getDough(), 'Thin crust');
      expect(veggieFromJson.getSauce(), 'Tomato sauce');
      expect(veggieFromJson.getIngredients(), [
        'Mushrooms',
        'Bell peppers',
        'Onions',
        'Black olives',
        'Spinach',
        'Tomato sauce'
      ]);
      expect(veggieFromJson.pizzaPrice(), 9.0);
      expect(veggieFromJson.getId(), 1);
      expect(veggieFromJson.getDueno(), 'Francisco');
    });

    test('toJson', () {
      Map<String, dynamic> json = veggie.toJson();
      expect(json['name'], 'Pizza vegetal');
      expect(json['dough'], 'Thin crust');
      expect(json['sauce'], 'Tomato sauce');
      expect(json['ingredients'], [
        'Mushrooms',
        'Bell peppers',
        'Onions',
        'Black olives',
        'Spinach',
        'Tomato sauce',
        'lechuga'
      ]);
      expect(json['price'], 9.0);
      expect(json['id'], 0);
      expect(json['dueño'], '');
    });
  });
}
