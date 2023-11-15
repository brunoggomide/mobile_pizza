import 'package:http/http.dart' as http;
import 'package:mobile_pizzaria/config/env.dart';

Future getPizzasService() async {
  return http.get(
    Uri.parse(apiUrl + 'pizzas'),
  );
}

Future getPizzasById(id) async {
  return http.get(
    Uri.parse(apiUrl + 'pizzas/' + id),
  );
}
