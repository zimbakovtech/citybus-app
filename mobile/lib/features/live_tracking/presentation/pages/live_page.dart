import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/theme.dart';
import '../../../../core/widgets/osm_map.dart';
import '../../../../core/widgets/status_views.dart';
import '../../data/models/live_models.dart';
import '../providers/live_providers.dart';

/// Full-bleed live map of simulated vehicles; markers move as WebSocket
/// updates arrive. A floating header replaces the app bar.
class LivePage extends ConsumerWidget {
  const LivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(liveVehiclesProvider);
    return Scaffold(
      body: vehicles.when(
        loading: () => const LoadingView(),
        error: (error, _) => SafeArea(
          child: ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(liveVehiclesProvider),
          ),
        ),
        data: (fleet) => Stack(
          children: [
            OsmMap(
              layers: [
                MarkerLayer(
                  markers: [
                    for (final vehicle in fleet.values)
                      Marker(
                        point: LatLng(vehicle.lat, vehicle.lon),
                        width: 52,
                        height: 52,
                        child: _VehicleMarker(vehicle: vehicle),
                      ),
                  ],
                ),
              ],
            ),
            SafeArea(
              child: Padding(
                padding: Insets.page.copyWith(top: Insets.sm),
                child: Row(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Insets.lg,
                          vertical: Insets.md,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const _LiveDot(),
                            const SizedBox(width: Insets.sm),
                            Text(
                              'Live buses',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(width: Insets.md),
                            Text(
                              '${fleet.length}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small pulsing dot signalling a live connection.
class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.4, end: 1.0).animate(_controller),
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: Color(0xFF16A34A),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _VehicleMarker extends StatelessWidget {
  const _VehicleMarker({required this.vehicle});

  final LiveVehicle vehicle;

  Color get _delayColor => switch (vehicle.delaySeconds) {
    <= 60 => const Color(0xFF16A34A),
    <= 240 => const Color(0xFFEA580C),
    _ => const Color(0xFFDC2626),
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(Radii.sm),
            border: Border.all(color: scheme.surface, width: 2),
          ),
          child: Icon(CupertinoIcons.bus, size: 14, color: scheme.onPrimary),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Insets.xs,
            vertical: 1,
          ),
          decoration: BoxDecoration(
            color: _delayColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${vehicle.routeShortName ?? '?'} +${(vehicle.delaySeconds / 60).round()}m',
            style: const TextStyle(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
