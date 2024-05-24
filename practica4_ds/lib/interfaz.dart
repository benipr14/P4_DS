import 'pizza_fachada.dart';
import 'package:flutter/material.dart';
import 'pizza_builder.dart';
import 'payment_method.dart';
import 'apiClient.dart';
import 'User.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class PizzaBuilderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Builder',
      home: PizzaBuilderScreen(),
    );
  }
}

class PizzaBuilderScreen extends StatefulWidget {
  @override
  _PizzaBuilderScreenState createState() => _PizzaBuilderScreenState();
}

class _PizzaBuilderScreenState extends State<PizzaBuilderScreen> {
  final ApiClient apiService = ApiClient();
  late PizzaFacade pizzaFacade;
  late String current_user = "";
  late Future<List<PizzaBuilder>> pizzas;
  PizzaBuilder p = MargheritaPizzaBuilder();
  PizzaBuilder p2 = PepperoniPizzaBuilder();
  List<User> users = [
    User(id: 0, name: 'Benigno', selectedPizzas: []),
    User(id: 1, name: 'Francisco', selectedPizzas: []),
    User(id: 2, name: 'Helena', selectedPizzas: []),
    User(id: 3, name: 'Jorge', selectedPizzas: []),
    User(id: 4, name: 'Alejandra', selectedPizzas: []),

    // Añade más usuarios aquí
  ];

  late String selectedPizza =
      'Pizza margarita'; // Valor inicial del menú desplegable

  @override
  void initState() {
    super.initState();
    current_user = "Francisco";
    pizzaFacade = PizzaFacade();
    pizzas = apiService.getPizzas();

    _cargarPizzasIniciales();
  }

  PizzaBuilder seleccionarPizzaNombre(String nombre) {
    switch (nombre) {
      case 'Pizza margarita':
        return MargheritaPizzaBuilder();
      case 'Pizza pepperoni':
        return PepperoniPizzaBuilder();
      case 'Pizza veggie':
        return VeggiePizzaBuilder();
      default:
        throw Exception('Tipo de pizza desconocido');
    }
  }

  void addPizzaByName(String name) async {
    PizzaBuilder p = seleccionarPizzaNombre(name);
    p.dueno = current_user;
    p.id = await apiService.getNextId();

    await apiService.addPizzaByName(p);

    setState(() {
      users
          .firstWhere((user) => user.name == current_user)
          .selectedPizzas
          .add(p);
      _cargarPizzasIniciales();
    });
  }

  void deletePizza(String name, int id) async {
    var user = users.firstWhere((user) => user.name == current_user);
    var pizza = user.selectedPizzas.firstWhere((pizza) => pizza.id == id);

    await apiService.deletePizza(id);
    setState(() {
      user.selectedPizzas.remove(pizza);
    });
  }

  Future<void> _cargarPizzasIniciales() async {
    apiService.getPizzas().then((allPizzas) {
      // Para cada usuario, filtra las pizzas que le pertenecen
      for (User user in users) {
        user.selectedPizzas =
            allPizzas.where((pizza) => pizza.dueno == user.name).toList();
      }

      // Llama a setState dentro de .then()
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pizza Builder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: current_user,
              onChanged: (String? newValue) {
                setState(() {
                  current_user = newValue!;
                });
              },
              items: users.map<DropdownMenuItem<String>>((User user) {
                return DropdownMenuItem<String>(
                  value: user.name,
                  child: Text(user.name),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: selectedPizza,
              items: <String>[
                'Pizza margarita',
                'Pizza pepperoni',
                'Pizza veggie'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedPizza = newValue!;
                });
              },
            ),
            ElevatedButton(
              // Mostar el diálogo de CardPaymentDialog
              onPressed: () {
                _showPaymentDialog();
                addPizzaByName(selectedPizza);
              },
              child: Text('Añadir $selectedPizza al pedido'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: users
                    .firstWhere((user) => user.name == current_user)
                    .selectedPizzas
                    .length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(users
                            .firstWhere((user) => user.name == current_user)
                            .selectedPizzas[index]
                            .name),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              deletePizza(
                                  users
                                      .firstWhere(
                                          (user) => user.name == current_user)
                                      .selectedPizzas[index]
                                      .name,
                                  users
                                      .firstWhere(
                                          (user) => user.name == current_user)
                                      .selectedPizzas[index]
                                      .id);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Text Field para el precio total
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Precio total: \$${users.firstWhere((user) => user.name == current_user).getTotalPrice().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPizzaDetailsDialog(PizzaBuilder pizzaBuilder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${pizzaBuilder.getName()}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ingredientes:'),
              for (var ingredient in pizzaBuilder.getIngredients())
                Text('- $ingredient'),
              SizedBox(height: 10),
              Text('Masa: ${pizzaBuilder.getDough()}'),
              Text('Salsa: ${pizzaBuilder.getSauce()}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Atrás'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  pizzaFacade.addPizza(pizzaBuilder);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Has añadido la pizza ${pizzaBuilder.getName()}'),
                  ),
                );
              },
              child: Text('Pedir'),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccionar método de pago'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PaymentButton(
                label: 'Pagar con tarjeta',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CardPaymentDialog(
                        onPaymentConfirmed: () {
                          pizzaFacade.selectPayment(CardPaymentStrategy());
                          _showOrderDialog();
                        },
                      );
                    },
                  );
                },
              ),
              PaymentButton(
                label: 'Pagar en efectivo',
                onPressed: () {
                  setState(() {
                    pizzaFacade.selectPayment(CashPaymentStrategy());
                    _showOrderDialog();
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOrderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pedido realizado'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pedido:'),
                for (var pizza in pizzaFacade.selectedPizzas)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pizza: ${pizza.getName()}'),
                      Divider(),
                    ],
                  ),
                Text(
                    'Precio total: \$${pizzaFacade.totalPrice().toStringAsFixed(2)}'),
                Text(
                    'Sistema de pago: ${pizzaFacade.selectedPayment is CardPaymentStrategy ? 'Tarjeta de crédito' : 'Efectivo'}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                pizzaFacade.clearPizzas();
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}

class PizzaButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  PizzaButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class PaymentButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  PaymentButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class CardPaymentDialog extends StatefulWidget {
  final VoidCallback onPaymentConfirmed;

  const CardPaymentDialog({Key? key, required this.onPaymentConfirmed})
      : super(key: key);

  @override
  _CardPaymentDialogState createState() => _CardPaymentDialogState();
}

class _CardPaymentDialogState extends State<CardPaymentDialog> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Información de la tarjeta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: cardNumberController,
            decoration: InputDecoration(labelText: 'Número de tarjeta'),
          ),
          TextField(
            controller: expirationDateController,
            decoration:
                InputDecoration(labelText: 'Fecha de caducidad (MM/YY)'),
          ),
          TextField(
            controller: pinController,
            decoration: InputDecoration(labelText: 'PIN'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            String cardNumber = cardNumberController.text;
            String expirationDate = expirationDateController.text;
            String pin = pinController.text;

            // Validación de la longitud del número de tarjeta y el PIN
            if (cardNumber.length == 16 && pin.length == 4) {
              // Si la longitud es válida, llamamos a la función de devolución de llamada
              widget.onPaymentConfirmed();
            } else {
              // Si la longitud no es válida, mostramos un mensaje de error
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(
                        'Número de tarjeta o PIN no válido. Por favor, inténtalo de nuevo.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Limpiar los controladores de texto cuando se elimina el widget
    cardNumberController.dispose();
    expirationDateController.dispose();
    pinController.dispose();
    super.dispose();
  }
}
