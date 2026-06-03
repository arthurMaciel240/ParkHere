import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingResult {
  final String name;
  final double lat;
  final double lng;

  GeocodingResult({required this.name, required this.lat, required this.lng});
}

class GeocodingService {
  static Future<List<GeocodingResult>> search(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=5&countrycodes=br',
    );

    final response = await http.get(url, headers: {
      'User-Agent': 'ParkHereApp/1.0',
    });

    if (response.statusCode != 200) return [];

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) {
      return GeocodingResult(
        name: item['display_name'] ?? '',
        lat: double.tryParse(item['lat'] ?? '0') ?? 0,
        lng: double.tryParse(item['lon'] ?? '0') ?? 0,
      );
    }).toList();
  }
}
