import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/route_badge.dart';
import '../../../../core/widgets/status_views.dart';
import '../providers/routes_providers.dart';

/// Searchable list of bus lines, one card per line.
class RoutesPage extends ConsumerWidget {
  const RoutesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(routeSearchResultsProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PageHeader(
              title: 'Routes',
              subtitle: 'All lines in the network',
            ),
            Padding(
              padding: Insets.page,
              child: SearchBar(
                hintText: 'Search routes…',
                leading: const Icon(CupertinoIcons.search, size: 20),
                onChanged: (value) =>
                    ref.read(routeSearchQueryProvider.notifier).set(value),
              ),
            ),
            const SizedBox(height: Insets.md),
            Expanded(
              child: results.when(
                loading: () => const LoadingView(),
                error: (error, _) => ErrorView(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(routeSearchResultsProvider),
                ),
                data: (routes) => routes.isEmpty
                    ? const EmptyView(
                        message: 'No routes match your search.',
                        icon: CupertinoIcons.search,
                      )
                    : ListView.separated(
                        padding: Insets.page.copyWith(
                          top: Insets.sm,
                          bottom: Insets.xl,
                        ),
                        itemCount: routes.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: Insets.md),
                        itemBuilder: (context, index) {
                          final route = routes[index];
                          return Card(
                            child: ListTile(
                              leading: RouteBadge(
                                label: route.shortName ?? '?',
                                color: route.color,
                                size: 44,
                              ),
                              title: Text(
                                route.longName ?? 'Line ${route.shortName}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              subtitle: Text(
                                'Line ${route.shortName}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                              trailing: Icon(
                                CupertinoIcons.chevron_right,
                                size: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                              onTap: () => context.go('/routes/${route.id}'),
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
