part of 'get_data_cubit.dart';

@immutable
sealed class GetDataState {}

final class GetDataInitial extends GetDataState {}

final class GetDataLooding extends GetDataState {}

final class GetDataSuccses extends GetDataState {
  final String sizeVideo;
  final String sizeAudio;
  final String tittel;
  final String image;
  final Duration time;
  GetDataSuccses(
      {required this.tittel,
      required this.image,
      required this.sizeAudio,
      required this.time,
      required this.sizeVideo});
}

final class GetDataFail extends GetDataState {}
