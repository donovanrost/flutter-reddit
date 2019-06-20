class GfycatModel {
  List tags;
  List languageCategories;
  List domainWhitelist;
  List geoWhitelist;
  int published;
  String nsfw;
  int gatekeeper;
  String mp4URL;
  String webmURL;
  String mobileURL;
  String mobilePosterURL;
  String extraLemmas;
  String thumb100PosterURL;
  String miniURL;
  String miniPosterURL;
  String max5mbGIF;
  String title;
  String max2mbGIF;
  String max1mbGIF;
  String posterURL;
  String languageText;
  int views;
  String userName;
  String description;
  bool hasTransparency;
  bool hasAudio;
  String likes;
  String dislikes;
  String gfyNumber;
  String gfyID;
  String gfyName;
  String avgColor;
  String rating;
  int widgth;
  int height;
  double frameRate;
  int numFrames;
  int mp4Size;
  int webmSize;
  int createDate;
  String md5;
  int source;
  ContentURLs contentURLs;

  GfycatModel.fromJson(Map<String, dynamic> json) {
    tags = json['tags'];
    languageCategories = json['languageCategories'];
    domainWhitelist = json['domainWhitelist'];
    geoWhitelist = json['geoWhitelist'];
    published = json['published'];
    nsfw = json['nsfw'];
    gatekeeper = json['gatekeeper'];
    mp4URL = json['mp4Url'];
    webmURL = json['webmUrl'];
    mobileURL = json['mobileUrl'];
    mobilePosterURL = json['mobilePosterUrl'];
    extraLemmas = json['extraLemmas'];
    thumb100PosterURL = json['thumb100PosterUrl'];
    miniURL = json['miniUrl'];
    miniPosterURL = json['miniPosterUrl'];
    max5mbGIF = json['max5mbGif'];
    title = json['title'];
    max2mbGIF = json['max2mbGif'];
    max1mbGIF = json['max1mbGif'];
    posterURL = json['posterUrl'];
    languageText = json['languageText'];
    views = json['views'];
    userName = json['userName'];
    description = json['description'];
    hasTransparency = json[''];
    hasAudio = json['hasAudio'];
    likes = json['likes'];
    dislikes = json['dislikes'];
    gfyNumber = json['gfyNumber'];
    gfyID = json['gfyId'];
    gfyName = json['gfyName'];
    avgColor = json['avgColor'];
    rating = json['rating'];
    widgth = json['widgth'];
    height = json['height'];
    frameRate = json['frameRate'];
    numFrames = json['numFrames'];
    mp4Size = json['mp4Size'];
    webmSize = json['webmSize'];
    createDate = json['createDate'];
    md5 = json['md5'];
    source = json['source'];
  }
}

class ContentURL {
  String url;
  int size;
  int height;
  int width;

  ContentURL({this.url, this.size, this.height, this.width});

  factory ContentURL.fromJson(Map<String, dynamic> json) {
    return ContentURL(
        url: json['url'],
        size: json['size'],
        height: json['height'],
        width: json['width']);
  }
}

class ContentURLs {
  ContentURL max2mbGIF;
  ContentURL webp;
  ContentURL max1mbGIF;
  ContentURL px100GIF;
  ContentURL mobilePoster;
  ContentURL mp4;
  ContentURL webm;
  ContentURL max5mbGIF;
  ContentURL largeGIF;
  ContentURL mobile;

  ContentURLs(
      {this.max2mbGIF,
      this.webp,
      this.max1mbGIF,
      this.px100GIF,
      this.mobilePoster,
      this.mp4,
      this.webm,
      this.max5mbGIF,
      this.largeGIF,
      this.mobile});

  factory ContentURLs.fromJson(Map<String, dynamic> json) {
    return ContentURLs(
      max2mbGIF: ContentURL.fromJson(json['max2mbGif']),
      webp: ContentURL.fromJson(json['webp']),
      max1mbGIF: ContentURL.fromJson(json['max1mbGif']),
      px100GIF: ContentURL.fromJson(json['100pxGif']),
      mobilePoster: ContentURL.fromJson(json['mobilePoster']),
      mp4: ContentURL.fromJson(json['mp4']),
      webm: ContentURL.fromJson(json['webm']),
      max5mbGIF: ContentURL.fromJson(json['max5mbGif']),
      largeGIF: ContentURL.fromJson(json['largeGif']),
      mobile: ContentURL.fromJson(json['mobile']),
    );
  }
}
