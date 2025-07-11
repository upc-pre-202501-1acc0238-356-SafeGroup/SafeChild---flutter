import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safechild/blocs/reservations/reservations_bloc.dart';
import 'package:safechild/blocs/auth/auth_bloc.dart';
import 'package:safechild/blocs/auth/auth_state.dart';

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
      reservationsBloc.add(ReservationsInitialFetchEvent(token, tutorId));
    } else {
      print("User not authenticated o faltan datos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => reservationsBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text("Historial de Reservas")),
        body: BlocConsumer<ReservationsBloc, ReservationsState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ReservationFetchingSuccessfullState) {
              return ListView.builder(
                itemCount: state.reservations.length,
                itemBuilder: (context, index) {
                  final reservation = state.reservations[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text("Reserva ID: ${reservation.id}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Caregiver: ${reservation.caregiverId}"),
                          Text("Fecha: ${reservation.date}"),
                          Text("Inicio: ${reservation.startTime}"),
                          Text("Fin: ${reservation.endTime}"),
                          Text("Estado: ${reservation.status ?? 'Sin estado'}"),
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
