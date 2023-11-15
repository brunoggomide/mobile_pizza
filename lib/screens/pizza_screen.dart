import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_pizzaria/services/pizza.service.dart';
import 'customer_screen.dart';

class Pizza extends StatefulWidget {
  const Pizza({Key? key}) : super(key: key);

  @override
  State<Pizza> createState() => _PizzaState();
}

class _PizzaState extends State<Pizza> {
  List<Map<String, dynamic>> pizzas = [];
  Map<int, int> selectedPizzas = {};
  var idCustomer;

  @override
  void initState() {
    super.initState();
    Customer.getCustomerId().then((customerId) {
      setState(() {
        idCustomer = customerId;
      });
    });
    getPizzasService().then((res) {
      if (res.statusCode == 200) {
        List<dynamic> pizzaList = jsonDecode(res.body);

        setState(() {
          pizzas = List<Map<String, dynamic>>.from(pizzaList);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Cardápio',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: pizzas.length,
              itemBuilder: (context, index) {
                final pizza = pizzas[index];
                return Card(
                  child: ListTile(
                    title: Text(pizza['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pizza['description']),
                        Text('Preço: R\$ ${pizza['price']}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Quantidade: ${selectedPizzas[index] ?? 0}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  selectedPizzas[index] =
                                      (selectedPizzas[index] ?? 0) + 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () {
                _showOrderDialog();
              },
              child: const Text(
                'Fazer pedido',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDialog() {
    double totalPrice = 0;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Text('Resumo do Pedido'),
            ],
          ),
          content: Column(
            children: selectedPizzas.keys.map((index) {
              final pizza = pizzas[index];
              final quantity = selectedPizzas[index] ?? 0;
              final price = pizza['price'] * quantity;
              totalPrice += price;

              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(pizza['name']),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        if (selectedPizzas[index] != null &&
                            selectedPizzas[index]! > 0) {
                          selectedPizzas[index] = selectedPizzas[index]! - 1;
                        }
                        if (selectedPizzas[index] == 0) {
                          selectedPizzas.remove(index);
                        }
                        Navigator.of(context).pop();
                        _showOrderDialog();
                      },
                    ),
                  ],
                ),
                subtitle: Text('Quantidade: $quantity'),
              );
            }).toList(),
          ),
          actions: [
            Text('Preço Total: R\$ $totalPrice'),
            ElevatedButton(
              onPressed: () {
                // Printar os IDs das pizzas selecionadas aqui
                selectedPizzas.forEach((index, quantity) {
                  for (int i = 0; i < quantity; i++) {
                    print(pizzas[index]['_id']);
                  }
                });
                Navigator.of(context).pop();
                setState(() {
                  selectedPizzas.clear();
                });
              },
              child: Text('Finalizar Pedido'),
            ),
          ],
        );
      },
    );
  }
}
