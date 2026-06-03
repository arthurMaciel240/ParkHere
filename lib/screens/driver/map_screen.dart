import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../models/parking_lot_model.dart';
import '../../providers/app_provider.dart';
import '../../services/geocoding_service.dart';
import '../../services/routing_service.dart';
import '../../services/location_service.dart';
import 'parking_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchCtrl = TextEditingController();

  List<GeocodingResult> _searchResults = [];
  bool _searching = false;
  List<LatLng> _routePoints = [];
  bool _routing = false;
  String? _routeInfo;
  LatLng? _currentLocation;
  bool _gettingLocation = false;

  LatLng? _searchCenter;
  double _searchRadiusKm = 5.0;

  Timer? _debounceTimer;

  static const LatLng _bh = LatLng(-19.9167, -43.9345);
  static const List<double> _radiusOptions = [1, 3, 5, 10, 20, 50];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _getCurrentLocation();
    });
  }

  Future<void> _loadData() async {
    await context.read<AppProvider>().loadParkingLots();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _gettingLocation = true);
    final loc = await LocationService.getCurrentLocation();
    setState(() {
      _gettingLocation = false;
      if (loc != null) {
        _currentLocation = loc;
        _mapController.move(loc, 14);
      }
    });
  }

  void _openDetail(ParkingLotModel lot) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ParkingDetailScreen(lot: lot)));
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();

    if (value.trim().length < 3) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() => _searching = true);

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(value.trim());
    });
  }

  Future<void> _performSearch(String query) async {
    final results = await GeocodingService.search(query);

    if (mounted) {
      setState(() {
        _searching = false;
        _searchResults = results;
      });
    }
  }

  void _selectSearchResult(GeocodingResult result) {
    final center = LatLng(result.lat, result.lng);
    setState(() {
      _searchCenter = center;
      _searchResults = [];
    });
    _mapController.move(center, 15);
    _searchCtrl.text = result.name.split(',').first;
    FocusScope.of(context).unfocus();
  }

  double _distanceBetween(LatLng a, LatLng b) {
    const distance = Distance();
    return distance.as(LengthUnit.Kilometer, a, b);
  }

  List<_LotWithDistance> _getFilteredLots(List<ParkingLotModel> lots) {
    final center = _searchCenter ?? _currentLocation ?? _bh;

    final withDistance = lots.map((lot) {
      final lotPos = LatLng(lot.lat, lot.lng);
      final dist = _distanceBetween(center, lotPos);
      return _LotWithDistance(lot: lot, distanceKm: dist);
    }).toList();

    withDistance.retainWhere((item) => item.distanceKm <= _searchRadiusKm);
    withDistance.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    return withDistance;
  }

  Future<void> _traceRoute(ParkingLotModel lot) async {
    setState(() {
      _routing = true;
      _routePoints = [];
      _routeInfo = null;
    });

    LatLng from = _currentLocation ?? _bh;
    if (_currentLocation == null) {
      final loc = await LocationService.getCurrentLocation();
      if (loc != null) {
        from = loc;
        setState(() => _currentLocation = loc);
      }
    }

    final to = LatLng(lot.lat, lot.lng);
    final route = await RoutingService.getRoute(from, to);

    setState(() {
      _routing = false;
      if (route != null) {
        _routePoints = route.points;
        final km = route.distanceMeters / 1000;
        final min = route.durationSeconds / 60;
        _routeInfo = '${km.toStringAsFixed(1)} km • ${min.toStringAsFixed(0)} min';
        if (route.points.isNotEmpty) {
          _mapController.move(route.points.first, 14);
        }
      } else {
        _routeInfo = 'Nao foi possivel calcular a rota.';
      }
    });
  }

  void _clearRoute() {
    setState(() {
      _routePoints = [];
      _routeInfo = null;
    });
  }

  void _clearSearch() {
    _searchCtrl.clear();
    _debounceTimer?.cancel();
    setState(() {
      _searchResults = [];
      _searchCenter = null;
      _routePoints = [];
      _routeInfo = null;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _mapController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final allLots = app.parkingLots;
    final filteredLots = _getFilteredLots(allLots);

    return Scaffold(
      appBar: AppBar(title: const Text('Encontrar vaga')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? _bh,
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.parkhere.app',
              ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: AppTheme.primaryColor,
                      strokeWidth: 5,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (_currentLocation != null)
                    Marker(
                      point: _currentLocation!,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.my_location, color: Colors.blue, size: 28),
                      ),
                    ),
                  if (_searchCenter != null)
                    Marker(
                      point: _searchCenter!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_pin, color: Colors.red, size: 36),
                    ),
                  ...allLots.map((lot) {
                    return Marker(
                      point: LatLng(lot.lat, lot.lng),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => _openDetail(lot),
                        child: const Icon(
                          Icons.local_parking,
                          color: AppTheme.primaryColor,
                          size: 36,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          // Barra de busca dinamica
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            decoration: const InputDecoration(
                              hintText: 'Busque rua, bairro ou cidade...',
                              border: InputBorder.none,
                            ),
                            onChanged: _onSearchChanged,
                          ),
                        ),
                        if (_searching)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else if (_searchCtrl.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: _clearSearch,
                          ),
                      ],
                    ),
                  ),
                ),
                // Resultados da busca dinamica
                if (_searchResults.isNotEmpty)
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(top: 4),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _searchResults.length,
                        itemBuilder: (_, i) {
                          final r = _searchResults[i];
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.location_on, color: AppTheme.primaryColor),
                            title: Text(r.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                            onTap: () => _selectSearchResult(r),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Info da rota
          if (_routeInfo != null)
            Positioned(
              top: _searchResults.isNotEmpty ? 150 : 80,
              left: 16,
              right: 16,
              child: Card(
                color: AppTheme.primaryColor,
                elevation: 4,
                child: ListTile(
                  dense: true,
                  leading: const Icon(Icons.directions, color: Colors.white),
                  title: Text(_routeInfo!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: _clearRoute,
                  ),
                ),
              ),
            ),
          // Botao de localizacao
          Positioned(
            top: _searchResults.isNotEmpty || _routeInfo != null ? 150 : 80,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: 'loc',
              onPressed: _gettingLocation ? null : _getCurrentLocation,
              child: _gettingLocation
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.my_location),
            ),
          ),
          // Lista inferior de estacionamentos com filtro de raio
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header com contador e seletor de raio
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${filteredLots.length} estacionamento(s) proximo(s)',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Row(
                          children: [
                            const Text('Raio: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            DropdownButton<double>(
                              value: _searchRadiusKm,
                              isDense: true,
                              underline: const SizedBox(),
                              items: _radiusOptions.map((r) {
                                return DropdownMenuItem(
                                  value: r,
                                  child: Text('${r.toStringAsFixed(0)} km', style: const TextStyle(fontSize: 13)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _searchRadiusKm = value);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 180,
                    child: app.loading
                        ? const Center(child: CircularProgressIndicator())
                        : filteredLots.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text('Nenhum estacionamento encontrado neste raio.', style: TextStyle(color: Colors.grey)),
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.all(12),
                                itemCount: filteredLots.length,
                                itemBuilder: (_, i) => _ParkingCard(
                                  lotWithDist: filteredLots[i],
                                  onTap: () => _openDetail(filteredLots[i].lot),
                                  onRoute: () => _traceRoute(filteredLots[i].lot),
                                  routing: _routing,
                                ),
                              ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LotWithDistance {
  final ParkingLotModel lot;
  final double distanceKm;

  _LotWithDistance({required this.lot, required this.distanceKm});
}

class _ParkingCard extends StatelessWidget {
  final _LotWithDistance lotWithDist;
  final VoidCallback onTap;
  final VoidCallback onRoute;
  final bool routing;

  const _ParkingCard({
    required this.lotWithDist,
    required this.onTap,
    required this.onRoute,
    required this.routing,
  });

  @override
  Widget build(BuildContext context) {
    final lot = lotWithDist.lot;
    final dist = lotWithDist.distanceKm;

    return SizedBox(
      width: 280,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: lot.photos.isNotEmpty
                    ? Image.network(lot.photos.first, fit: BoxFit.cover, width: double.infinity)
                    : Container(color: Colors.grey.shade300, child: const Center(child: Icon(Icons.local_parking))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
                child: Text(lot.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 4),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${dist.toStringAsFixed(1)} km • ${lot.address}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('R\$ ${lot.pricePerHour.toStringAsFixed(2)}/h', style: const TextStyle(color: AppTheme.secondaryColor, fontWeight: FontWeight.w600)),
                    TextButton.icon(
                      onPressed: routing ? null : onRoute,
                      icon: routing
                          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.directions, size: 18),
                      label: const Text('Rota', style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
