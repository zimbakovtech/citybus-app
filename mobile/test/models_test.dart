import 'package:citybus/features/live_tracking/data/models/live_models.dart';
import 'package:citybus/features/planner/data/models/planner_models.dart';
import 'package:citybus/features/stops/data/models/stop_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('model deserialization (snake_case API JSON)', () {
    test('StopSummary', () {
      final stop = StopSummary.fromJson(const {
        'id': 2,
        'name': 'Plostad Makedonija',
        'code': 'C02',
        'lat': 41.9947,
        'lon': 21.4314,
      });
      expect(stop.id, 2);
      expect(stop.name, 'Plostad Makedonija');
      expect(stop.lat, closeTo(41.9947, 1e-9));
    });

    test('Departure parses nested route and ISO datetime', () {
      final departure = Departure.fromJson(const {
        'trip_id': 210,
        'route': {
          'id': 1,
          'short_name': '2',
          'long_name': 'x',
          'color': 'D32F2F',
        },
        'headsign': 'Novo Lisice',
        'departure_at': '2026-05-04T08:14:00',
        'stop_sequence': 8,
      });
      expect(departure.route.shortName, '2');
      expect(departure.departureAt, DateTime(2026, 5, 4, 8, 14));
    });

    test('PlanResponse discriminates ride and transfer legs by type', () {
      final plan = PlanResponse.fromJson(const {
        'found': true,
        'from_stop': {
          'id': 6,
          'name': 'Gradski Park',
          'lat': 42.0,
          'lon': 21.4,
        },
        'to_stop': {'id': 20, 'name': 'Kisela Voda', 'lat': 41.9, 'lon': 21.4},
        'depart_at': '2026-05-04T08:00:00',
        'arrive_at': '2026-05-04T08:36:30',
        'duration_seconds': 2190,
        'transfers': 1,
        'legs': [
          {
            'type': 'ride',
            'route': {'id': 3, 'short_name': '15'},
            'trip_id': 300,
            'board_stop': {
              'id': 6,
              'name': 'Gradski Park',
              'lat': 42.0,
              'lon': 21.4,
            },
            'board_time': '2026-05-04T08:00:00',
            'alight_stop': {
              'id': 2,
              'name': 'Plostad',
              'lat': 41.99,
              'lon': 21.43,
            },
            'alight_time': '2026-05-04T08:08:00',
            'num_stops': 3,
          },
          {
            'type': 'transfer',
            'at_stop': {'id': 2, 'name': 'Plostad', 'lat': 41.99, 'lon': 21.43},
            'seconds': 900,
          },
        ],
      });
      expect(plan.found, isTrue);
      expect(plan.legs, hasLength(2));
      expect(plan.legs.first, isA<PlanRideLeg>());
      expect(plan.legs.last, isA<PlanTransferLeg>());
      expect((plan.legs.first as PlanRideLeg).route.shortName, '15');
      expect((plan.legs.last as PlanTransferLeg).seconds, 900);
    });

    test('LiveVehicle parses both snapshot and websocket update shapes', () {
      final fromSnapshot = LiveVehicle.fromJson(const {
        'vehicle_id': 'BUS-2-36',
        'trip_id': 36,
        'route_short_name': '2',
        'lat': 41.99,
        'lon': 21.43,
        'delay_seconds': 51,
        'current_stop_id': 5,
        'recorded_at': '2026-05-04T08:00:00Z',
      });
      expect(fromSnapshot.vehicleId, 'BUS-2-36');
      expect(fromSnapshot.bearing, isNull);

      final fromUpdate = LiveVehicle.fromJson(const {
        'type': 'vehicle_position',
        'vehicle_id': 'BUS-5-101',
        'trip_id': 101,
        'route_short_name': '5',
        'lat': 42.0,
        'lon': 21.44,
        'bearing': 87.0,
        'delay_seconds': 120,
        'current_stop_id': 27,
        'timestamp': '2026-05-04T08:15:00Z',
      });
      expect(fromUpdate.bearing, 87.0);
      expect(fromUpdate.delaySeconds, 120);
    });
  });
}
