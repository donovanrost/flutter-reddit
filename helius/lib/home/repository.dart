import 'dart:async';
import 'package:helius/classes/image_fetcher.dart';
import 'package:helius/classes/image_model.dart';
import 'package:helius/classes/video_fetcher.dart';
import 'package:helius/classes/video_model.dart';

class Repository {
  // Future<ItemModel> fetchAllMovies() => moviesApiProvider.fetchMovieList();

  // Future<TrailerModel> fetchTrailers(int movieId) => moviesApiProvider.fetchTrailer(movieId);
  Future<ImageModel> fetchImage(String url) => ImageFetcher.fetch(url: url);
  Future<VideoModel> fetchVideo(String url) => VideoFetcher.fetch(url: url);

  // So now I need a function that will take a URL, and from the URL find out how to get the image url from it.
  // Perhaps I have such a function already.

}
