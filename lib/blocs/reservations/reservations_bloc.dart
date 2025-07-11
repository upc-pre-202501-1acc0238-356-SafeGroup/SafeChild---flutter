import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:safechild/models/ReservationDataModel.dart';
import 'package:safechild/repositories/ReservationRepository.dart';

part 'reservations_event.dart';
part 'reservations_state.dart';

class ReservationsBloc extends Bloc<ReservationsEvent, ReservationsState> {
  ReservationsBloc() : super(ReservationsInitial()) {
    on<ReservationsInitialFetchEvent>(reservationsInitialFetchEvent);
  }

  FutureOr<void> reservationsInitialFetchEvent(
      ReservationsInitialFetchEvent event,
      Emitter<ReservationsState> emit,
      ) async {
    print("ReservationsBloc: Starting fetch for tutorId: ${event.tutorId}"); // Debug

    try {
      // Emitir estado de carga opcional
      // emit(ReservationFetchingLoadingState());

      List<ReservationDataModel> reservations = await ReservationRepository.fetchReservation(
        event.token,
        event.tutorId,
      );

      print("ReservationsBloc: Fetched ${reservations.length} reservations"); // Debug

      // Imprimir cada reserva para debugging
      for (var reservation in reservations) {
        print("Reservation: ${reservation.toString()}");
      }

      emit(ReservationFetchingSuccessfullState(reservations: reservations));

    } catch (e) {
      print("ReservationsBloc: Error fetching reservations: $e"); // Debug
      emit(ReservationFetchingErrorState(error: e.toString()));
    }
  }
}