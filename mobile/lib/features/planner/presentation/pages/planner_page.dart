import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/route_badge.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/status_views.dart';
import '../../../../core/widgets/timeline_rail.dart';
import '../../../stops/data/models/stop_models.dart';
import '../../../stops/presentation/providers/stops_providers.dart';
import '../../data/models/planner_models.dart';
import '../providers/planner_providers.dart';

/// Journey planner: pick origin + destination (stop search or device
/// location), choose a departure time, and view the legs of the plan.
class PlannerPage extends ConsumerWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(plannerFormProvider);
    final plan = ref.watch(planControllerProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            const PageHeader(
              title: 'Planner',
              subtitle: 'Where are you going today?',
            ),
            Padding(
              padding: Insets.page,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Insets.xs),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _EndpointTile(
                              label: 'From',
                              railTop: false,
                              endpoint: form.origin,
                              onChanged: (endpoint) => ref
                                  .read(plannerFormProvider.notifier)
                                  .setOrigin(endpoint),
                            ),
                            _EndpointTile(
                              label: 'To',
                              railBottom: false,
                              endpoint: form.destination,
                              onChanged: (endpoint) => ref
                                  .read(plannerFormProvider.notifier)
                                  .setDestination(endpoint),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: Insets.sm),
                        child: IconButton.outlined(
                          icon: const Icon(
                            CupertinoIcons.arrow_up_arrow_down,
                            size: 18,
                          ),
                          tooltip: 'Swap origin and destination',
                          onPressed: () =>
                              ref.read(plannerFormProvider.notifier).swap(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: Insets.md),
            Padding(
              padding: Insets.page,
              child: Card(child: _DepartureTimeTile(form: form)),
            ),
            const SizedBox(height: Insets.lg),
            Padding(
              padding: Insets.page,
              child: FilledButton.icon(
                icon: const Icon(CupertinoIcons.arrow_right, size: 18),
                label: const Text('Plan journey'),
                onPressed: form.ready
                    ? () => ref.read(planControllerProvider.notifier).submit()
                    : null,
              ),
            ),
            Padding(
              padding: Insets.page,
              child: plan.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(Insets.xl),
                  child: LoadingView(),
                ),
                error: (error, _) => ErrorView(
                  message: error.toString(),
                  onRetry: () =>
                      ref.read(planControllerProvider.notifier).submit(),
                ),
                data: (result) => result == null
                    ? const SizedBox.shrink()
                    : _PlanResult(plan: result),
              ),
            ),
            const SizedBox(height: Insets.xl),
          ],
        ),
      ),
    );
  }
}

class _EndpointTile extends ConsumerWidget {
  const _EndpointTile({
    required this.label,
    required this.endpoint,
    required this.onChanged,
    this.railTop = true,
    this.railBottom = true,
  });

  final String label;
  final PlanEndpoint? endpoint;
  final ValueChanged<PlanEndpoint> onChanged;
  final bool railTop;
  final bool railBottom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final value = switch (endpoint) {
      StopEndpoint(:final stop) => stop.name,
      MyLocationEndpoint() => 'My location',
      null => 'Choose a stop…',
    };
    return InkWell(
      onTap: () async {
        final stop = await showModalBottomSheet<StopSummary>(
          context: context,
          isScrollControlled: true,
          builder: (context) => const _StopPickerSheet(),
        );
        if (stop != null) onChanged(StopEndpoint(stop));
      },
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            const SizedBox(width: Insets.sm),
            TimelineRail(
              color: theme.colorScheme.primary,
              drawTop: railTop,
              drawBottom: railBottom,
              emphasized: !railBottom, // destination gets the filled dot
            ),
            const SizedBox(width: Insets.sm),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: endpoint == null
                          ? theme.colorScheme.onSurfaceVariant
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.location, size: 18),
              tooltip: 'Use my location',
              onPressed: () => onChanged(const MyLocationEndpoint()),
            ),
          ],
        ),
      ),
    );
  }
}

class _DepartureTimeTile extends ConsumerWidget {
  const _DepartureTimeTile({required this.form});

  final PlannerFormState form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        CupertinoIcons.clock,
        size: 22,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        'Departure',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        form.departAt == null
            ? 'Leave now'
            : DateFormat('EEE d MMM, HH:mm').format(form.departAt!),
        style: theme.textTheme.titleSmall,
      ),
      trailing: Icon(
        CupertinoIcons.chevron_right,
        size: 16,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      onTap: () async {
        final now = DateTime.now();
        final date = await showDatePicker(
          context: context,
          initialDate: form.departAt ?? now,
          firstDate: now.subtract(const Duration(days: 1)),
          lastDate: now.add(const Duration(days: 365)),
        );
        if (date == null || !context.mounted) return;
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(form.departAt ?? now),
        );
        if (time == null) return;
        ref
            .read(plannerFormProvider.notifier)
            .setDepartAt(
              DateTime(date.year, date.month, date.day, time.hour, time.minute),
            );
      },
    );
  }
}

/// Bottom sheet with a server-side stop search, returning the chosen stop.
class _StopPickerSheet extends ConsumerStatefulWidget {
  const _StopPickerSheet();

  @override
  ConsumerState<_StopPickerSheet> createState() => _StopPickerSheetState();
}

class _StopPickerSheetState extends ConsumerState<_StopPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(stopsRepositoryProvider);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Insets.lg),
              child: SearchBar(
                hintText: 'Search stops…',
                autoFocus: true,
                leading: const Icon(CupertinoIcons.search, size: 20),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                // small list; re-queries as the user types
                future: repository.search(_query),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ErrorView(message: snapshot.error.toString());
                  }
                  if (!snapshot.hasData) return const LoadingView();
                  final stops = snapshot.data!;
                  return ListView.separated(
                    itemCount: stops.length,
                    separatorBuilder: (_, _) =>
                        const Divider(indent: 72, endIndent: Insets.lg),
                    itemBuilder: (context, index) => ListTile(
                      leading: const IconBadge(
                        icon: CupertinoIcons.map_pin_ellipse,
                      ),
                      title: Text(stops[index].name),
                      onTap: () => Navigator.pop(context, stops[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanResult extends StatelessWidget {
  const _PlanResult({required this.plan});

  final PlanResponse plan;

  @override
  Widget build(BuildContext context) {
    if (!plan.found) {
      return const EmptyView(
        message: 'No route found for that time. Try a different departure.',
        icon: CupertinoIcons.slash_circle,
      );
    }
    final theme = Theme.of(context);
    final duration = Duration(seconds: plan.durationSeconds ?? 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Journey'),
        // bold flat summary block in the brand color
        Container(
          padding: const EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(Radii.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${DateFormat.Hm().format(plan.departAt)} → '
                '${DateFormat.Hm().format(plan.arriveAt!)}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: Insets.xs),
              Text(
                '${duration.inMinutes} min · '
                '${plan.transfers} transfer${plan.transfers == 1 ? '' : 's'}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Insets.md),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Insets.lg,
              vertical: Insets.sm,
            ),
            child: Column(
              children: [
                for (final leg in plan.legs)
                  switch (leg) {
                    PlanRideLeg() => _RideLeg(leg: leg),
                    PlanTransferLeg() => _TransferLeg(leg: leg),
                  },
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RideLeg extends StatelessWidget {
  const _RideLeg({required this.leg});

  final PlanRideLeg leg;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = routeColor(leg.route.color);
    final timeStyle = theme.textTheme.labelLarge?.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    Widget row({
      required String stop,
      required String time,
      required bool isBoard,
    }) {
      return SizedBox(
        height: 48,
        child: Row(
          children: [
            TimelineRail(
              color: color,
              drawTop: !isBoard,
              drawBottom: isBoard,
              emphasized: true,
              width: 32,
            ),
            const SizedBox(width: Insets.md),
            Expanded(child: Text(stop, style: theme.textTheme.titleSmall)),
            Text(time, style: timeStyle),
          ],
        ),
      );
    }

    return Column(
      children: [
        row(
          stop: leg.boardStop.name,
          time: DateFormat.Hm().format(leg.boardTime),
          isBoard: true,
        ),
        Row(
          children: [
            SizedBox(
              width: 32,
              child: Center(
                child: Container(width: 2, height: 28, color: color),
              ),
            ),
            const SizedBox(width: Insets.md),
            RouteBadge(
              label: leg.route.shortName ?? '?',
              color: leg.route.color,
              size: 28,
            ),
            const SizedBox(width: Insets.sm),
            Text(
              '${leg.numStops} stops',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        row(
          stop: leg.alightStop.name,
          time: DateFormat.Hm().format(leg.alightTime),
          isBoard: false,
        ),
      ],
    );
  }
}

class _TransferLeg extends StatelessWidget {
  const _TransferLeg({required this.leg});

  final PlanTransferLeg leg;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Icon(
              CupertinoIcons.arrow_right_arrow_left,
              size: 15,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Text(
              'Transfer · ${(leg.seconds / 60).ceil()} min wait',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
