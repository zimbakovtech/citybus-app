import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme.dart';
import '../../../../core/widgets/route_badge.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/status_views.dart';
import '../../data/models/stop_models.dart';
import '../providers/stops_providers.dart';

/// Stop attributes, the routes serving it, and upcoming departures.
class StopDetailPage extends ConsumerWidget {
  const StopDetailPage({super.key, required this.stopId});

  final int stopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(stopDetailProvider(stopId));
    return Scaffold(
      appBar: AppBar(title: Text(detail.value?.name ?? 'Stop')),
      body: detail.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(stopDetailProvider(stopId)),
        ),
        data: (stop) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(departuresProvider(stopId)),
          child: ListView(
            padding: Insets.page,
            children: [
              if (stop.code != null)
                Text(
                  'Stop code ${stop.code}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              const SectionHeader(title: 'Lines'),
              Wrap(
                spacing: Insets.sm,
                runSpacing: Insets.sm,
                children: [
                  for (final route in stop.routes)
                    RouteBadge(
                      label: route.shortName ?? '?',
                      color: route.color,
                      size: 38,
                    ),
                ],
              ),
              const SectionHeader(title: 'Departures — next hour'),
              _DeparturesCard(stopId: stopId),
              const SizedBox(height: Insets.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeparturesCard extends ConsumerWidget {
  const _DeparturesCard({required this.stopId});

  final int stopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departures = ref.watch(departuresProvider(stopId));
    return departures.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(Insets.xl),
        child: LoadingView(),
      ),
      error: (error, _) => ErrorView(
        message: error.toString(),
        onRetry: () => ref.invalidate(departuresProvider(stopId)),
      ),
      data: (items) => items.isEmpty
          ? const EmptyView(
              message: 'No departures in the next hour.',
              icon: CupertinoIcons.clock,
            )
          : Card(
              child: Column(
                children: [
                  for (final (index, departure) in items.indexed) ...[
                    if (index > 0) const Divider(indent: 72),
                    _DepartureTile(departure: departure),
                  ],
                ],
              ),
            ),
    );
  }
}

class _DepartureTile extends StatelessWidget {
  const _DepartureTile({required this.departure});

  final Departure departure;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minutesAway = departure.departureAt
        .difference(DateTime.now())
        .inMinutes;
    final imminent = minutesAway >= 0 && minutesAway <= 10;
    return ListTile(
      leading: RouteBadge(
        label: departure.route.shortName ?? '?',
        color: departure.route.color,
      ),
      title: Text(
        departure.headsign ?? departure.route.longName ?? '',
        style: theme.textTheme.titleSmall,
      ),
      subtitle: minutesAway >= 0 && minutesAway <= 90
          ? Text(
              minutesAway == 0 ? 'Due now' : 'In $minutesAway min',
              style: theme.textTheme.labelMedium?.copyWith(
                color: imminent
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: Text(
        DateFormat.Hm().format(departure.departureAt),
        style: theme.textTheme.titleMedium?.copyWith(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
