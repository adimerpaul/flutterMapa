import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService {
  static const url = 'https://425b-2800-cd0-afc8-eb00-7161-a187-8747-e261.ngrok-free.app/api/';
  Future getLocations() async {
    var response = await http.get(Uri.parse(url+'locations'));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    } else {
      return 'Error';
    }
  }
}
