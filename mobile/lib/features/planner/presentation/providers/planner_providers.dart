import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/location.dart';
import '../../../stops/data/models/stop_models.dart';
import '../../data/datasources/planner_api.dart';
import '../../data/models/planner_models.dart';
import '../../data/repositories/planner_repository_impl.dart';
import '../../domain/repositories/planner_repository.dart';

final plannerRepositoryProvider = Provider<PlannerRepository>(
  (ref) => PlannerRepositoryImpl(PlannerApi(ref.watch(dioProvider))),
);

/// A journey endpoint chosen in the form: a concrete stop, or "my location"
/// (resolved to coordinates when the plan is requested).
sealed class PlanEndpoint {
  const PlanEndpoint();
}

class StopEndpoint extends PlanEndpoint {
  const StopEndpoint(this.stop);

  final StopSummary stop;
}

class MyLocationEndpoint extends PlanEndpoint {
  const MyLocationEndpoint();
}

class PlannerFormState {
  const PlannerFormState({this.origin, this.destination, this.departAt});

  final PlanEndpoint? origin;
  final PlanEndpoint? destination;
  final DateTime? departAt; // null = "leave now"

  bool get ready => origin != null && destination != null;

  PlannerFormState copyWith({
    PlanEndpoint? origin,
    PlanEndpoint? destination,
    DateTime? departAt,
  }) {
    return PlannerFormState(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      departAt: departAt ?? this.departAt,
    );
  }
}

class PlannerForm extends Notifier<PlannerFormState> {
  @override
  PlannerFormState build() => const PlannerFormState();

  void setOrigin(PlanEndpoint endpoint) =>
      state = state.copyWith(origin: endpoint);

  void setDestination(PlanEndpoint endpoint) =>
      state = state.copyWith(destination: endpoint);

  void setDepartAt(DateTime value) => state = state.copyWith(departAt: value);

  /// Swap origin and destination (either may still be unset).
  void swap() => state = PlannerFormState(
    origin: state.destination,
    destination: state.origin,
    departAt: state.departAt,
  );
}

final plannerFormProvider = NotifierProvider<PlannerForm, PlannerFormState>(
  PlannerForm.new,
);

/// Runs the plan request on demand; null means "not asked yet".
class PlanController extends AsyncNotifier<PlanResponse?> {
  @override
  Future<PlanResponse?> build() async => null;

  Future<void> submit() async {
    final form = ref.read(plannerFormProvider);
    if (!form.ready) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(plannerRepositoryProvider);
      final departAt = form.departAt ?? DateTime.now();

      int? fromStopId, toStopId;
      double? fromLat, fromLon, toLat, toLon;
      switch (form.origin!) {
        case StopEndpoint(:final stop):
          fromStopId = stop.id;
        case MyLocationEndpoint():
          final position = await currentPosition();
          fromLat = position.latitude;
          fromLon = position.longitude;
      }
      switch (form.destination!) {
        case StopEndpoint(:final stop):
          toStopId = stop.id;
        case MyLocationEndpoint():
          final position = await currentPosition();
          toLat = position.latitude;
          toLon = position.longitude;
      }

      return repository.plan(
        fromStopId: fromStopId,
        toStopId: toStopId,
        fromLat: fromLat,
        fromLon: fromLon,
        toLat: toLat,
        toLon: toLon,
        departAt: departAt,
      );
    });
  }
}

final planControllerProvider =
    AsyncNotifierProvider<PlanController, PlanResponse?>(PlanController.new);
