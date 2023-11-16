import 'package:flutter/material.dart';
import 'package:mobile_pizzaria/screens/customer_screen.dart';
import 'dart:convert';

import 'package:mobile_pizzaria/services/order.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pizza_screen.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  List<Map<String, dynamic>> order = [];
  var idOrder;

  @override
  void initState() {
    super.initState();
    getOrder().then((res) {
      getOrderById(idOrder).then((res) {
        print(res.body);
        if (res.statusCode == 200) {
          Map<String, dynamic> orderDetails = jsonDecode(res.body);

          setState(() {
            order = [orderDetails];
          });
        }
      });
    });
  }

  getOrder() async {
    final orderId = await Pizza.getOrder();
    setState(() {
      idOrder = orderId;
    });
  }

  void clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pedido',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: order.isEmpty
                  ? Center(
                      child: Container(
                      child: Text('Nada para exibir'),
                    ))
                  : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detalhes do Pedido',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text('Status: ${order[0]['status']}'),
                          SizedBox(height: 10.0),
                          Text('Pizzas:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: order[0]['pizzas']
                                .map<Widget>((pizza) => Text(
                                      '- ${pizza['name']}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          Visibility(
            visible: order.isNotEmpty && order[0]['status'] == 'Pronto',
            child: Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  clearSharedPreferences();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: ((c) {
                        return const Customer();
                      }),
                    ),
                  );
                },
                child: const Text(
                  'Encerrar conta',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
