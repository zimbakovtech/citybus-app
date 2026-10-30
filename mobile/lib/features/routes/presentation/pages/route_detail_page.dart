import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/theme.dart';
import '../../../../core/widgets/osm_map.dart';
import '../../../../core/widgets/segmented_tab_bar.dart';
import '../../../../core/widgets/status_views.dart';
import '../../../../core/widgets/timeline_rail.dart';
import '../../../stops/data/models/stop_models.dart';
import '../providers/routes_providers.dart';

/// Route polyline on the map plus its ordered stops, per direction.
class RouteDetailPage extends ConsumerStatefulWidget {
  const RouteDetailPage({super.key, required this.routeId});

  final int routeId;

  @override
  ConsumerState<RouteDetailPage> createState() => _RouteDetailPageState();
}

class _RouteDetailPageState extends ConsumerState<RouteDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final direction = _tabController.index;
    final args = (routeId: widget.routeId, directionId: direction);
    final detail = ref.watch(routeDetailProvider(widget.routeId));
    final shape = ref.watch(routeShapeProvider(args));
    final stops = ref.watch(routeStopsProvider(args));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          detail.value == null ? 'Route' : 'Line ${detail.value!.shortName}',
        ),
      ),
      body: detail.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(routeDetailProvider(widget.routeId)),
        ),
        data: (route) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (route.longName != null)
              Padding(
                padding: Insets.page.copyWith(bottom: Insets.md),
                child: Text(
                  route.longName!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            SegmentedTabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Outbound', height: 40),
                Tab(text: 'Inbound', height: 40),
              ],
            ),
            const SizedBox(height: Insets.md),
            Expanded(
              flex: 3,
              child: Padding(
                padding: Insets.page,
                child: Card(
                  child: shape.when(
                    loading: () => const LoadingView(),
                    error: (error, _) => ErrorView(message: error.toString()),
                    data: (geo) {
                      final points = [
                        // GeoJSON coordinates are [lon, lat]
                        for (final pair in geo.coordinates)
                          LatLng(pair[1], pair[0]),
                      ];
                      return OsmMap(
                        center: points.isEmpty
                            ? skopjeCenter
                            : points[points.length ~/ 2],
                        layers: [
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: points,
                                strokeWidth: 4,
                                color: routeColor(route.color),
                              ),
                            ],
                          ),
                          MarkerLayer(
                            markers: [
                              for (final stop
                                  in stops.value ?? const <StopSummary>[])
                                Marker(
                                  point: LatLng(stop.lat, stop.lon),
                                  width: 12,
                                  height: 12,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface,
                                      border: Border.all(
                                        color: routeColor(route.color),
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: Insets.md),
            Expanded(
              flex: 2,
              child: stops.when(
                loading: () => const LoadingView(),
                error: (error, _) => ErrorView(message: error.toString()),
                data: (items) => ListView.builder(
                  padding: Insets.page.copyWith(bottom: Insets.lg),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final isFirst = index == 0;
                    final isLast = index == items.length - 1;
                    return SizedBox(
                      height: 44,
                      child: Row(
                        children: [
                          TimelineRail(
                            color: routeColor(route.color),
                            drawTop: !isFirst,
                            drawBottom: !isLast,
                            emphasized: isFirst || isLast,
                          ),
                          const SizedBox(width: Insets.md),
                          Expanded(
                            child: Text(
                              items[index].name,
                              style: (isFirst || isLast)
                                  ? Theme.of(context).textTheme.titleSmall
                                  : Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
