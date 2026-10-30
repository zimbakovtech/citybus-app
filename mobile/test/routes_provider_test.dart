import 'package:citybus/features/routes/data/models/route_models.dart';
import 'package:citybus/features/routes/domain/repositories/routes_repository.dart';
import 'package:citybus/features/routes/presentation/providers/routes_providers.dart';
import 'package:citybus/features/stops/data/models/stop_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _routes = [
  RouteSummary(id: 1, shortName: '2', longName: 'Gjorche Petrov - Novo Lisice'),
  RouteSummary(id: 2, shortName: '5', longName: 'Butel - Kisela Voda'),
];

class FakeRoutesRepository implements RoutesRepository {
  @override
  Future<List<RouteSummary>> search(String query) async => [
    for (final route in _routes)
      if ('${route.shortName} ${route.longName}'.toLowerCase().contains(
        query.toLowerCase(),
      ))
        route,
  ];

  @override
  Future<RouteDetail> detail(int routeId) => throw UnimplementedError();

  @override
  Future<List<StopSummary>> orderedStops(int routeId, {int directionId = 0}) =>
      throw UnimplementedError();

  @override
  Future<RouteShape> shape(int routeId, {int directionId = 0}) =>
      throw UnimplementedError();
}

void main() {
  test('routeSearchResultsProvider filters through the repository', () async {
    final container = ProviderContainer(
      overrides: [
        routesRepositoryProvider.overrideWithValue(FakeRoutesRepository()),
      ],
    );
    addTearDown(container.dispose);

    expect(
      await container.read(routeSearchResultsProvider.future),
      hasLength(2),
    );

    container.read(routeSearchQueryProvider.notifier).set('kisela');
    final filtered = await container.read(routeSearchResultsProvider.future);
    expect(filtered.single.shortName, '5');
  });
}
