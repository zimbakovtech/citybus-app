import 'package:citybus/features/stops/data/models/stop_models.dart';
import 'package:citybus/features/stops/domain/repositories/stops_repository.dart';

const testStops = [
  StopSummary(
    id: 1,
    name: 'Transporten Centar',
    code: 'C01',
    lat: 41.9857,
    lon: 21.4448,
  ),
  StopSummary(
    id: 2,
    name: 'Plostad Makedonija',
    code: 'C02',
    lat: 41.9947,
    lon: 21.4314,
  ),
];

/// In-memory StopsRepository for provider and widget tests.
class FakeStopsRepository implements StopsRepository {
  @override
  Future<List<StopSummary>> search(String query) async => [
    for (final stop in testStops)
      if (stop.name.toLowerCase().contains(query.toLowerCase())) stop,
  ];

  @override
  Future<List<NearbyStop>> nearby({
    required double lat,
    required double lon,
    double radiusM = 1000,
  }) async => const [
    NearbyStop(
      id: 2,
      name: 'Plostad Makedonija',
      code: 'C02',
      lat: 41.9947,
      lon: 21.4314,
      distanceM: 12.5,
    ),
  ];

  @override
  Future<StopDetail> detail(int stopId) async => const StopDetail(
    id: 2,
    name: 'Plostad Makedonija',
    code: 'C02',
    lat: 41.9947,
    lon: 21.4314,
    routes: [],
  );

  @override
  Future<List<Departure>> departures(
    int stopId, {
    DateTime? at,
    int windowMin = 60,
  }) async => const [];
}
