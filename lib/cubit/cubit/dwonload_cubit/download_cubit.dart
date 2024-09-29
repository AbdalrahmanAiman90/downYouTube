import 'dart:io' as io; // Alias the dart:io import;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  DownloadCubit() : super(DownloadInitial());
  var yotubExpload = YoutubeExplode();

  downlowadVidio(var url) async {
    //get video data
    try {
      emit(DownloadLooding());
      var video = await yotubExpload.videos.get(url);
      var manifest = await yotubExpload.videos.streamsClient.getManifest(url);
      var streams = manifest.muxed.withHighestBitrate();
      var audio = streams;
      var audioStream = yotubExpload.videos.streamsClient.get(audio);
      //creat directory
      String downloadsPath = '/storage/emulated/0/Download';
      String folderName = "DwonTech/Video";

      String filePath =
          '$downloadsPath/$folderName/${removeSpecialCharacters(video.title)}.mp4';
      // Create the folder if it does not exist
      io.Directory('$downloadsPath/$folderName').createSync(recursive: true);

      // Create and write to the file
      var file = io.File(filePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
      var output = file.openWrite(mode: io.FileMode.writeOnlyAppend);
      double downloadedBytes = 0.0;
      var size = audio.size.totalBytes;
      await for (final data in audioStream) {
        try {
          output.add(data);
          downloadedBytes += data.length;

          // Emit progress state
          double progress = downloadedBytes / size;
          emit(DownloadProgress(progress));
        } on Exception catch (e) {
          emit(DownloadFail());
          break;
        }
      }
      await output.close();

      var msg = '${video.title} Downloaded to $filePath/${video.title}';

      emit(DownloadSuccses(msg: msg));
    } on Exception catch (e) {
      emit(DownloadFail());
    } finally {}
  }

  downloadAudio(String url) async {
    try {
      // Emit loading state
      emit(DownloadLooding());
      // Get video data
      var video = await yotubExpload.videos.get(url);

      // Get the audio stream with the highest bitrate
      var manifest = await yotubExpload.videos.streamsClient.getManifest(url);
      var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
      var audioStream = yotubExpload.videos.streamsClient.get(audioStreamInfo);

      // Get the Downloads directory
      String downloadsPath = '/storage/emulated/0/Download';
      String folderName = "DwonTech/Audio";
      String filePath =
          '$downloadsPath/$folderName/${removeSpecialCharacters(video.title)}.mp3';

      // Create the folder if it does not exist
      io.Directory('$downloadsPath/$folderName').createSync(recursive: true);

      // Create and write to the file
      var file = io.File(filePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
      var output = file.openWrite(mode: io.FileMode.writeOnlyAppend);
      double downloadedBytes = 0.0;
      var size = audioStreamInfo.size.totalBytes;
      await for (final data in audioStream) {
        try {
          output.add(data);
          downloadedBytes += data.length;

          // Emit progress state
          double progress = downloadedBytes / size;
          emit(DownloadProgress(progress));
        } on Exception catch (e) {
          emit(DownloadFail());
          break;
        }
      }
      await output.close();

      var msg = '${video.title} downloaded to $filePath';
      emit(DownloadSuccses(msg: msg));
    } catch (e) {
      emit(DownloadFail());
    } finally {}
  }

  String removeSpecialCharacters(String input) {
    final RegExp regex = RegExp(r'[^a-zA-Z0-9\s\u0621-\u064A]');

    return input.replaceAll(regex, '');
  }

  @override
  void onChange(Change<DownloadState> change) {
    print(change);
    super.onChange(change);
  }
}
