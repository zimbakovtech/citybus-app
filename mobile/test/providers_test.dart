import 'package:citybus/features/stops/presentation/providers/stops_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('stopSearchResultsProvider', () {
    test('returns all stops for an empty query and filters on text', () async {
      final container = ProviderContainer(
        overrides: [
          stopsRepositoryProvider.overrideWithValue(FakeStopsRepository()),
        ],
      );
      addTearDown(container.dispose);

      expect(
        await container.read(stopSearchResultsProvider.future),
        hasLength(2),
      );

      container.read(stopSearchQueryProvider.notifier).set('plostad');
      final filtered = await container.read(stopSearchResultsProvider.future);
      expect(filtered, hasLength(1));
      expect(filtered.single.name, 'Plostad Makedonija');
    });
  });
}
