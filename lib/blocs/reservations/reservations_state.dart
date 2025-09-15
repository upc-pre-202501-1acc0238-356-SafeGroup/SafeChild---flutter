part of 'reservations_bloc.dart';

abstract class ReservationsState {}

class ReservationsInitial extends ReservationsState {}

class ReservationFetchingLoadingState extends ReservationsState {}

class ReservationFetchingSuccessfullState extends ReservationsState {
  final List<ReservationDataModel> reservations;

  ReservationFetchingSuccessfullState({required this.reservations});



}

class ReservationFetchingErrorState extends ReservationsState {
  final String? error;

  ReservationFetchingErrorState({this.error});
}