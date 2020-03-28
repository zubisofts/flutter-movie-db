import 'dart:async';
import 'package:MovieDB/model/movie_review.dart';
import 'package:MovieDB/repository/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:MovieDB/model/movie_details.dart';
import 'package:MovieDB/model/person.dart';
import 'package:MovieDB/model/person_images.dart';
import 'package:MovieDB/repository/movie_repository.dart';
import './bloc.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MovieRepository movieRespository = MovieRepository();
  StreamSubscription _movieDbSubscription;

  @override
  MoviesState get initialState => InitialMoviesState();

  @override
  Stream<MoviesState> mapEventToState(
    MoviesEvent event,
  ) async* {
    if (event is LoadMoviesEvent) {
      yield* _fetchMoviesState(event.type, event.id, event.currentPageIndex);
    }

    if (event is LoadMovieDetailsEvent) {
      yield* _processMovieDetailsState(event.id);
    }

    if (event is LoadMoreMoviesEvent) {
      yield* _fetchMoreMoviesState(
          event.type, event.id, event.currentPageIndex);
    }

    if (event is PersonDetailsEvent) {
      yield* _mapPersonDetailsToState(event.id);
    }

    if (event is GetPersonImagesEvent) {
      yield* _mapPersonImagesToState(event.id);
    }

    if (event is AddFavouritesEvent) {
      yield* _mapAddFavouriteEventToState(event.details, event.uid,event.mediaType);
    }

    if (event is GetFavouriteEvent) {
      yield* _mapFavouriteEventToState(event.id, event.uid,event.mediaType);
    }

    if (event is GetFavouriteMovieEvent) {
      yield* _mapGetFavouriteMovieState(event.favourite);
    }

    if (event is LoadFavouriteMoviesEvent) {
      yield* _mapLoadFavouriteMoviesState(event.uid,event.mediaType);
    }

    if (event is LoadAllFavouritesMovieEvent) {
      yield* _mapLoadAllFavouritesMovieEvent(event.favourites);
    }

    if (event is DeleteFavouriteMovieItem) {
      yield* _mapDeleteFavouriteMovieState(event.movieId, event.uid,event.mediaType);
    }

    if (event is AddWatchListEvent) {
      yield* _mapAddWatchListItemEventToState(event.movieDetails, event.uid,event.mediaType);
    }

    if (event is GetWatchListItemEvent) {
      yield* _mapWatchListItemEventEventToState(event.id, event.uid,event.mediaType);
    }

    if (event is LoadWatchListMoviesEvent) {
      yield* _mapLoadWatchListState(event.uid,event.mediaType);
    }

    if (event is LoadAllWatchListMovieEvent) {
      yield* _mapLoadAllWatchList(event.watchLists,event.mediaType);
    }

    if (event is GetWatchListMovieEvent) {
      yield* _mapGetWatchListMovieState(event.watchListItem);
    }

    if (event is DeleteWatchListMovieItem) {
      yield* _mapDeleteWatchListMovieState(event.movieId, event.uid,event.mediaType);
    }

    if (event is GetMovieReviews) {
      yield* _mapMovieReviewToState(event.movieId);
    }

    if (event is GetGenres) {
      yield* _processGenresState(event.mediaType);
    }

    if (event is Discover) {
      yield* _processDiscoverState(event.mediaType,event.genres,event.sortQuery,event.year);
          }
        }
      
        Stream<MoviesState> _fetchMoviesState(
            MovieCat type, int id, int currentPageIndex) async* {
          yield MovieLoadingState();
      
          var movies = await movieRespository.getMovies(type, id, currentPageIndex);
          // print(type);
      
          if (movies != null) {
            yield MoviesLoadedState(movies: movies);
          } else {
            yield MovieErrorState();
          }
        }
      
        Stream<MoviesState> _fetchMoreMoviesState(
            MovieCat type, int id, int currentPageIndex) async* {
          //     yield LoadingState();
      
          var movies = await movieRespository.getMovies(type, id, currentPageIndex);
          if (movies != null) {
            yield MoreMoviesLoadedState(movies: movies);
          } else {
            yield MovieErrorState();
          }
        }
      
        Stream<MoviesState> _processMovieDetailsState(int id) async* {
          yield MovieLoadingState();
          MovieDetails movieDetails = await movieRespository.getMovieDetails(id);
          var videoDetails = await movieRespository.getVideos(id);
          var similarMovies =
              await movieRespository.getMovies(MovieCat.Similar, id, 1);
          var movieCredit = await movieRespository.getCredits(id);
      
          yield MovieDetailsReadyState(
              movieDetails: movieDetails,
              videoDetails: videoDetails,
              similarMovies: similarMovies,
              credit: movieCredit);
        }
      
        Stream<MoviesState> _mapPersonDetailsToState(int id) async* {
          yield MovieLoadingState();
          Person person = await movieRespository.getPersonDetails(id);
          yield PersonDetialsState(person: person);
        }
      
        Stream<MoviesState> _mapPersonImagesToState(int id) async* {
          yield MovieLoadingState();
          PersonImages images = await movieRespository.getPersonImages(id);
          yield PersonImagesState(images: images);
        }
      
        Stream<MoviesState> _mapFavouriteEventToState(int id, String uid,MediaType mediaType) async* {
          // if (_movieDbSubscription != null) {
          _movieDbSubscription?.cancel();
          // }
      
          _movieDbSubscription = MovieRepository.withUID(uid)
              .getFavourite(id,mediaType)
              .listen((fav) => add(GetFavouriteMovieEvent(favourite: fav)));
        }
      
        Stream<MoviesState> _mapGetFavouriteMovieState(
            MovieDetails favourite) async* {
          print("yielding...");
          yield FavouriteItemState(favourite: favourite);
        }
      
        Stream<MoviesState> _mapAddFavouriteEventToState(
            var details, String uid, MediaType mediaType) async* {
      
          MovieRepository.withUID(uid).addToFavorites(details,mediaType).then(
              (onValue) => add(GetFavouriteEvent(id: details.id, uid:uid,mediaType: mediaType)));
        }
      
        Stream<MoviesState> _mapLoadFavouriteMoviesState(String uid, MediaType mediaType) async* {
          _movieDbSubscription?.cancel();
          // }
      
          _movieDbSubscription = MovieRepository.withUID(uid).favourites(mediaType).listen(
              (favMovies) => add(LoadAllFavouritesMovieEvent(favourites: favMovies)));
        }
      
        Stream<MoviesState> _mapLoadAllFavouritesMovieEvent(
            List<MovieDetails> favourites) async* {
          if (favourites != null) yield FavouriteMoviesLoaded(favourites: favourites);
        }
      
        Stream<MoviesState> _mapDeleteFavouriteMovieState(
            int movieId, String uid, MediaType mediaType) async* {
          await MovieRepository.withUID(uid).removeFavoritesItem(movieId,mediaType);
      
          add(LoadFavouriteMoviesEvent(uid: uid));
        }
      
        // Event mappings for watchlist
        Stream<MoviesState> _mapAddWatchListItemEventToState(
            dynamic movieDetails, String uid, MediaType mediaType) async* {
          await MovieRepository.withUID(uid).addToWatchList(movieDetails,mediaType);
          add(GetWatchListItemEvent(id: movieDetails.id, uid: uid,mediaType: mediaType));
        }
      
        Stream<MoviesState> _mapWatchListItemEventEventToState(
            int id, String uid, MediaType mediaType) async* {
          // if (_movieDbSubscription != null) {
          _movieDbSubscription?.cancel();
          // }
      
          _movieDbSubscription = MovieRepository.withUID(uid)
              .getWatchListItem(id,mediaType)
              .listen((movie) => add(GetWatchListMovieEvent(watchListItem: movie)));
        }
      
        Stream<MoviesState> _mapGetWatchListMovieState(
            var movieDetails) async* {
      
          yield WatchListItem(watchListItem: movieDetails);
        }
      
        Stream<MoviesState> _mapLoadWatchListState(String uid, MediaType mediaType) async* {
          _movieDbSubscription?.cancel();
          // }
      
          _movieDbSubscription = MovieRepository.withUID(uid).watchlist(mediaType).listen(
              (watchLists) =>
                  add(LoadAllWatchListMovieEvent(watchLists: watchLists,mediaType:mediaType)));
        }
      
        Stream<MoviesState> _mapDeleteWatchListMovieState(
            int movieId, String uid, MediaType mediaType) async* {
          await MovieRepository.withUID(uid).removeWatchListItem(movieId,mediaType).then((h){
            add(GetWatchListItemEvent(uid: uid,mediaType: mediaType));
          });
      
      
        }
      
        @override
        Future<void> close() {
          _movieDbSubscription?.cancel();
          return super.close();
        }
      
        Stream<MoviesState> _mapLoadAllWatchList(
            List watchLists,MediaType mediaType) async* {
          yield WatchListMoviesLoaded(watchList: watchLists,mediaType:mediaType);
        }
      
        Stream<MoviesState> _mapMovieReviewToState(int movieId) async* {
         yield LoadingState();
          MovieReview movieReview=await movieRespository.getMovieReviews(movieId);
          yield MovieReviewsLoaded(movieReview: movieReview);
      
        }
      
       Stream<MoviesState> _processGenresState(MediaType mediaType) async*{
          var genre=await movieRespository.getGenres(mediaType);
          yield GenresState(genry: genre);
       }
      
      Stream<MoviesState>  _processDiscoverState(MediaType mediaType, List<int> genres, String sortQuery, String year) async*{
        yield LoadingState();
        var item=await movieRespository.discover(sortQuery, genres, year, mediaType,1);
        if(item==null){
          yield MovieErrorState();
        }else{
          yield DiscoverState(items: item);
        }
      }
}
