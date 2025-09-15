part of 'reservations_bloc.dart';

abstract class ReservationsEvent {}
class ReservationsInitialFetchEvent extends ReservationsEvent {
  final String token;
  final int tutorId;

  ReservationsInitialFetchEvent({
    required this.token,
    required this.tutorId,
  });
}