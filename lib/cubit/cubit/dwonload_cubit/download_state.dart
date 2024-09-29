part of 'download_cubit.dart';

@immutable
sealed class DownloadState {}

final class DownloadInitial extends DownloadState {}

final class DownloadLooding extends DownloadState {}

final class DownloadSuccses extends DownloadState {
  String msg;
  DownloadSuccses({required this.msg});
}

final class DownloadProgress extends DownloadState {
  final double progress;
  DownloadProgress(this.progress);
}

final class DownloadFail extends DownloadState {}

final class StopDwon extends DownloadState {}
