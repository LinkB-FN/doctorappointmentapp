import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/firestore_service.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FirestoreService _firestoreService;
  StreamSubscription? _statsSubscription;

  DashboardBloc(this._firestoreService) : super(DashboardInitial()) {
    on<LoadDashboardStats>(_onLoadDashboardStats);
    on<RefreshDashboardStats>(_onRefreshDashboardStats);
  }

  Future<void> _onLoadDashboardStats(
    LoadDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    
    try {
      // Suscribirse al stream para actualizaciones en tiempo real
      await _statsSubscription?.cancel();
      _statsSubscription = _firestoreService.getDashboardStatsStream().listen(
        (stats) {
          add(RefreshDashboardStats());
        },
      );

      // Cargar datos iniciales
      final totalAppointments = await _firestoreService.getTotalAppointments();
      final upcomingAppointments = await _firestoreService.getUpcomingAppointments();
      final totalPatients = await _firestoreService.getTotalPatients();

      emit(DashboardLoaded(
        totalAppointments: totalAppointments,
        upcomingAppointments: upcomingAppointments,
        totalPatients: totalPatients,
      ));
    } catch (e) {
      emit(DashboardError('Error al cargar estadísticas: $e'));
    }
  }

  Future<void> _onRefreshDashboardStats(
    RefreshDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final totalAppointments = await _firestoreService.getTotalAppointments();
      final upcomingAppointments = await _firestoreService.getUpcomingAppointments();
      final totalPatients = await _firestoreService.getTotalPatients();

      emit(DashboardLoaded(
        totalAppointments: totalAppointments,
        upcomingAppointments: upcomingAppointments,
        totalPatients: totalPatients,
      ));
    } catch (e) {
      emit(DashboardError('Error al actualizar estadísticas: $e'));
    }
  }

  @override
  Future<void> close() {
    _statsSubscription?.cancel();
    return super.close();
  }
}
