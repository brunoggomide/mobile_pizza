import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

import 'package:mobile_pizzaria/services/order.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customer_screen.dart';
import 'pizza_screen.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  Future<Map<String, dynamic>>? orderDetails;
  late String idOrder;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    orderDetails = getOrder();

    // Set up a timer to call getOrderById every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
      getOrderById(idOrder).then((res) {
        print(res.body);
        if (res.statusCode == 200) {
          setState(() {
            orderDetails = Future.value(jsonDecode(res.body));
          });
        } else {
          // Handle error, you might want to show an error message to the user
        }
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  Future<Map<String, dynamic>> getOrder() async {
    final orderId = await Pizza.getOrder();
    if (orderId != null) {
      idOrder = orderId;
      final res = await getOrderById(idOrder);
      print(res.body);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        // Handle error, you might want to show an error message to the user
        return Map<String, dynamic>();
      }
    } else {
      // Handle the case where orderId is null
      return Map<String, dynamic>();
    }
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: orderDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar os detalhes do pedido'));
          } else {
            Map<String, dynamic> order = snapshot.data ?? {};
            return Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: order.isEmpty
                          ? Text('Nada para exibir')
                          : Column(
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
                                Text('Status: ${order['status']}'),
                                SizedBox(height: 10.0),
                                Text(
                                  'Pizzas:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: (order['pizzas'] as List<dynamic>)
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
                  visible: order['status'] == 'Pronto',
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
            );
          }
        },
      ),
    );
  }
}
