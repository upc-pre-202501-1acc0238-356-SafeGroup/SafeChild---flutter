import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safechild/blocs/reservations/reservations_bloc.dart';
import 'package:safechild/blocs/auth/auth_bloc.dart';
import 'package:safechild/blocs/auth/auth_state.dart';
import 'package:safechild/views/payments/Paymentbutton.dart';


class Reservationhistory extends StatefulWidget {
  const Reservationhistory({super.key});

  @override
  State<Reservationhistory> createState() => _ReservationhistoryState();
}

class _ReservationhistoryState extends State<Reservationhistory> {
  final ReservationsBloc reservationsBloc = ReservationsBloc();

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;
    String? token;
    int? tutorId;

    if (authState is AuthAuthenticated) {
      token = authState.user.token;
      tutorId = authState.tutorId;
    }

    if (token != null && tutorId != null) {
      reservationsBloc.add(ReservationsInitialFetchEvent(token: token, tutorId: tutorId));
    } else {
      print("User not authenticated o faltan datos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => reservationsBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Historial de Reservas"),
          backgroundColor: Colors.blue.shade700,
        ),
        body: BlocConsumer<ReservationsBloc, ReservationsState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ReservationFetchingSuccessfullState) {
              return ListView.builder(
                itemCount: state.reservations.length,
                itemBuilder: (context, index) {
                  final reservation = state.reservations[index];
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    color: Colors.blue.shade50,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.assignment_turned_in, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              Text(
                                "Reserva #${reservation.id}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20, thickness: 1),
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.blue.shade400),
                              const SizedBox(width: 8),
                              Text("Cuidador: ${reservation.caregiverId}"),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.green.shade400),
                              const SizedBox(width: 8),
                              Text("Fecha: ${reservation.date}"),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.access_time, color: Colors.orange.shade400),
                              const SizedBox(width: 8),
                              Text("Inicio: ${reservation.startTime}"),

                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.share_arrival_time, color: Colors.orange.shade400),
                              const SizedBox(width: 8),
                              Text("Fin: ${reservation.endTime}"),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.purple.shade400),
                              const SizedBox(width: 8),
                              Text("Estado: ${reservation.status ?? 'Sin estado'}"),
                            ],
                          ),
                          if (reservation.status == "PENDING")
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Paymentbutton( reservationId: reservation.id ?? 0 ,   // ID de la reserva en backend
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is ReservationFetchingErrorState) {
              return const Center(child: Text("Error al obtener reservas."));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
