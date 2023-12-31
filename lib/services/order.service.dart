import 'package:http/http.dart' as http;
import 'package:mobile_pizzaria/config/env.dart';

Future createOrder(order) async {
  return http.post(
    Uri.parse(apiUrl + 'orders'),
    headers: {"Content-Type": "application/json"},
    body: order,
  );
}

Future getOrderById(id) async {
  print(id);
  return http.get(
    Uri.parse(apiUrl + 'orders/' + id),
  );
}
