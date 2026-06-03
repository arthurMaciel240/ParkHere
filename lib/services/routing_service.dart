import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteResult {
  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;

  RouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });
}

class RoutingService {
  static Future<RouteResult?> getRoute(LatLng from, LatLng to) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/${from.longitude},${from.latitude};${to.longitude},${to.latitude}?overview=full&geometries=geojson',
    );

    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'ParkHereApp/1.0',
      });

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final routes = data['routes'] as List<dynamic>?;
      if (routes == null || routes.isEmpty) return null;

      final route = routes.first;
      final geometry = route['geometry'];
      final List<dynamic> coords = geometry['coordinates'];

      final points = coords.map((c) {
        final List<dynamic> coord = c;
        return LatLng(coord[1].toDouble(), coord[0].toDouble());
      }).toList();

      return RouteResult(
        points: points,
        distanceMeters: (route['distance'] ?? 0).toDouble(),
        durationSeconds: (route['duration'] ?? 0).toDouble(),
      );
    } catch (e) {
      return null;
    }
  }
}
