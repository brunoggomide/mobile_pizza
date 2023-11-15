import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_pizzaria/services/customer.service.dart';

import 'base_screen.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key}) : super(key: key);

  static Future<String?> getCustomerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('customerId');
  }

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  var nameController = TextEditingController();
  var tableController = TextEditingController();

  Future<void> saveCustomerId(String customerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('customerId', customerId);
  }

  Future<String?> getCustomerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('customerId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Informe a mesa para acessar o menu',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: TextFormField(
                controller: nameController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: 'Nome',
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 150,
              child: TextFormField(
                controller: tableController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.table_chart),
                  labelText: 'Número da mesa',
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          tableController.text.isNotEmpty) {
                        createCustomer(json.encode({
                          'name': nameController.text,
                          'table': tableController.text
                        })).then((res) {
                          print(res.body);
                          if (res.statusCode == 201) {
                            final Map<String, dynamic> data =
                                json.decode(res.body);
                            final String customerId = data['customer']['_id'];
                            saveCustomerId(customerId);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: ((c) {
                                  return const BaseScreen();
                                }),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red[300],
                                content: const Text(
                                  'Erro de requisição',
                                  style: TextStyle(color: Colors.white),
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red[300],
                            content: const Text(
                              'Preencha os campos',
                              style: TextStyle(color: Colors.white),
                            ),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Entrar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
