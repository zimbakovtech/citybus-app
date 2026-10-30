import 'package:citybus/features/stops/presentation/pages/stops_page.dart';
import 'package:citybus/features/stops/presentation/providers/stops_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  testWidgets('StopsPage lists search results from the repository', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stopsRepositoryProvider.overrideWithValue(FakeStopsRepository()),
        ],
        child: const MaterialApp(home: StopsPage()),
      ),
    );

    // first frame shows the loader, then the async results arrive
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.text('Transporten Centar'), findsOneWidget);
    expect(find.text('Plostad Makedonija'), findsOneWidget);

    // typing filters through the (fake) server search
    await tester.enterText(find.byType(SearchBar), 'plostad');
    await tester.pumpAndSettle();

    expect(find.text('Transporten Centar'), findsNothing);
    expect(find.text('Plostad Makedonija'), findsOneWidget);
  });
}
