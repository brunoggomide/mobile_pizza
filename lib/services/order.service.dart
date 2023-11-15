import 'package:http/http.dart' as http;
import 'package:mobile_pizzaria/config/env.dart';

Future createOrder(order) async {
  return http.post(
    Uri.parse(apiUrl + 'order'),
    body: order,
  );
}
