import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/dashboard_bloc.dart';
import 'blocs/dashboard_event.dart';
import 'blocs/dashboard_state.dart';
import 'services/firestore_service.dart';
import 'routes.dart';

class PaginaDashboard extends StatelessWidget {
  const PaginaDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(FirestoreService())..add(LoadDashboardStats()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1730),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF001F3F),
              Color(0xFF240046),
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: min(600.0, max(350.0, MediaQuery.of(context).size.width * 0.8)),
            height: MediaQuery.of(context).size.height * 0.85,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.45),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "DASHBOARD",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Panel de Médico",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          context.read<DashboardBloc>().add(LoadDashboardStats());
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      if (state is DashboardLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        );
                      } else if (state is DashboardLoaded) {
                        return Column(
                          children: [
                            // Tarjeta de Total de Citas
                            _buildStatCard(
                              context,
                              title: 'Total de Citas',
                              value: state.totalAppointments.toString(),
                              icon: Icons.calendar_today,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 16),
                            
                            // Tarjeta de Citas Próximas
                            _buildStatCard(
                              context,
                              title: 'Citas Próximas',
                              value: state.upcomingAppointments.toString(),
                              icon: Icons.schedule,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 16),
                            
                            // Tarjeta de Total de Pacientes
                            _buildStatCard(
                              context,
                              title: 'Total de Pacientes',
                              value: state.totalPatients.toString(),
                              icon: Icons.people,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 24),
                            
                            // Información adicional
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.3),
                                border: Border.all(color: Colors.white24),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.medical_services,
                                        color: Colors.blueAccent,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Resumen de Actividad',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildInfoRow(
                                    'Citas completadas',
                                    '${state.totalAppointments - state.upcomingAppointments}',
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    'Tasa de ocupación',
                                    state.totalAppointments > 0
                                        ? '${((state.upcomingAppointments / state.totalAppointments) * 100).toStringAsFixed(1)}%'
                                        : '0%',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if (state is DashboardError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state.message,
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<DashboardBloc>().add(LoadDashboardStats());
                                },
                                child: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Botón para volver
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, Routes.home);
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Volver a Inicio'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.withOpacity(0.9),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.3),
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
