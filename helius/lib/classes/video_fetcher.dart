import 'package:flutter/foundation.dart';
import 'package:helius/classes/content_type.dart';
import 'package:helius/classes/gfycat_provider.dart';
import 'package:helius/classes/video_model.dart';

class VideoFetcher {
  static Future<VideoModel> fetch({@required url}) async {
    print('FROM VIDEO FETCHER -- $url');

    if (ContentType.isGfycat(Uri.parse(url))) {
      final gfycat = GfycatApiProvider();
      final response = await gfycat.fetchGfycat(url: url);
      print('FROM VIDEO FETCHER -- ${response.gfycatItem.mp4URL}');

      return VideoModel(url: response.gfycatItem.mp4URL);
    } else if (ContentType.getContentTypeFromURL(url) ==
        Type.VREDDIT_REDIRECT) {
      if (!url.endsWith('/')) {
        url += "/";
      }
      url += "DASH_360";
      return VideoModel(url: url);
    } else {
      if (url.endsWith('gifv')) {
        url = url.replaceAll("gifv", 'mp4');
      }

      return VideoModel(url: url);
    }
  }
}
