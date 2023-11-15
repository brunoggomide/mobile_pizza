import 'package:http/http.dart' as http;
import 'package:mobile_pizzaria/config/env.dart';

Future createCustomer(customer) async {
  print(customer);
  return http.post(
    Uri.parse(apiUrl + 'customers'),
    headers: {"Content-Type": "application/json"},
    body: customer,
  );
}
