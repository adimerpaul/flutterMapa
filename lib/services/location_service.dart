import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService {
  static const url = 'http://127.0.0.1:8000/api/';
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
