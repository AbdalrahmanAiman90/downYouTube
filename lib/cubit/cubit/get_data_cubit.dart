import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart' as http;

part 'get_data_state.dart';

class GetDataCubit extends Cubit<GetDataState> {
  GetDataCubit() : super(GetDataInitial());

  fetchDate(url) async {
    emit(GetDataLooding());
    try {
      YoutubeExplode yotubInfo = YoutubeExplode();

      var video = await yotubInfo.videos.get(url);
      var manifest = await yotubInfo.videos.streamsClient.getManifest(video.id);
      // Get video stream with highest bitrate
      var videoStream = manifest.muxed.withHighestBitrate();
      var videoResponse =
          await http.head(Uri.parse(videoStream.url.toString()));
      int videoContentLength =
          int.tryParse(videoResponse.headers['content-length'] ?? '0') ?? 0;

      // Get audio stream with highest bitrate
      var audioStream = manifest.audioOnly.withHighestBitrate();
      var audioResponse =
          await http.head(Uri.parse(audioStream.url.toString()));
      int audioContentLength =
          int.tryParse(audioResponse.headers['content-length'] ?? '0') ?? 0;
      yotubInfo.close();

      //date

      emit(GetDataSuccses(
          time: video.duration!,
          sizeAudio:
              "${(audioContentLength / (1024 * 1024)).toStringAsFixed(2)} MB",
          sizeVideo:
              "${(videoContentLength / (1024 * 1024)).toStringAsFixed(2)} MB",
          tittel: video.title,
          image: 'https://img.youtube.com/vi/${video.id}/0.jpg'));
    } on Exception catch (e) {
      log(e.toString());
      emit(GetDataFail());
    }
  }

  @override
  void onChange(Change<GetDataState> change) {
    print(change);

    super.onChange(change);
  }
}
