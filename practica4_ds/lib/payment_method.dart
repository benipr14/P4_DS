abstract class PaymentStrategy {
  double calculatePrice(double pizzaPrice);
}

class CardPaymentStrategy implements PaymentStrategy {
  @override
  double calculatePrice(double pizzaPrice) {
    // Supongamos un descuento del 10% para pagos con tarjeta
    return pizzaPrice * 0.9;
  }
}

class CashPaymentStrategy implements PaymentStrategy {
  @override
  double calculatePrice(double pizzaPrice) {
    return pizzaPrice;
  }
}