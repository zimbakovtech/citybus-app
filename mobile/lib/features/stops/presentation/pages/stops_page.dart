import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/route_badge.dart';
import '../../../../core/widgets/segmented_tab_bar.dart';
import '../../../../core/widgets/status_views.dart';
import '../providers/stops_providers.dart';

/// Stop search (server-side) and a "nearby" tab using the device location.
class StopsPage extends ConsumerWidget {
  const StopsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PageHeader(
                title: 'Stops',
                subtitle: 'Find departures around the city',
              ),
              Padding(
                padding: Insets.page,
                child: SearchBar(
                  hintText: 'Search stops…',
                  leading: const Icon(CupertinoIcons.search, size: 20),
                  onChanged: (value) =>
                      ref.read(stopSearchQueryProvider.notifier).set(value),
                ),
              ),
              const SizedBox(height: Insets.md),
              const SegmentedTabBar(
                tabs: [
                  Tab(text: 'Search', height: 40),
                  Tab(text: 'Nearby', height: 40),
                ],
              ),
              const SizedBox(height: Insets.sm),
              const Expanded(
                child: TabBarView(children: [_SearchList(), _NearbyList()]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StopTile extends StatelessWidget {
  const _StopTile({
    required this.stopId,
    required this.name,
    required this.icon,
    this.subtitle,
  });

  final int stopId;
  final String name;
  final IconData icon;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: IconBadge(icon: icon),
      title: Text(name, style: theme.textTheme.titleSmall),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
      trailing: Icon(
        CupertinoIcons.chevron_right,
        size: 16,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      onTap: () => context.go('/stops/$stopId'),
    );
  }
}

/// Stops rendered as one card with hairline separators — the shared list
/// treatment for both tabs.
class _StopListCard extends StatelessWidget {
  const _StopListCard({required this.tiles});

  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: Insets.page.copyWith(top: Insets.sm, bottom: Insets.xl),
      children: [
        Card(
          child: Column(
            children: [
              for (final (index, tile) in tiles.indexed) ...[
                if (index > 0) const Divider(indent: 72),
                tile,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchList extends ConsumerWidget {
  const _SearchList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(stopSearchResultsProvider);
    return results.when(
      loading: () => const LoadingView(),
      error: (error, _) => ErrorView(
        message: error.toString(),
        onRetry: () => ref.invalidate(stopSearchResultsProvider),
      ),
      data: (stops) => stops.isEmpty
          ? const EmptyView(
              message: 'No stops match your search.',
              icon: CupertinoIcons.search,
            )
          : _StopListCard(
              tiles: [
                for (final stop in stops)
                  _StopTile(
                    stopId: stop.id,
                    name: stop.name,
                    icon: CupertinoIcons.map_pin_ellipse,
                    subtitle: stop.code,
                  ),
              ],
            ),
    );
  }
}

class _NearbyList extends ConsumerWidget {
  const _NearbyList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearby = ref.watch(nearbyStopsProvider);
    return nearby.when(
      loading: () => const LoadingView(),
      error: (error, _) => ErrorView(
        message: error.toString(),
        onRetry: () => ref.invalidate(nearbyStopsProvider),
      ),
      data: (stops) => stops.isEmpty
          ? const EmptyView(
              message: 'No stops within 1 km.',
              icon: CupertinoIcons.location,
            )
          : _StopListCard(
              tiles: [
                for (final stop in stops)
                  _StopTile(
                    stopId: stop.id,
                    name: stop.name,
                    icon: CupertinoIcons.location,
                    subtitle: '${stop.distanceM.round()} m away',
                  ),
              ],
            ),
    );
  }
}
