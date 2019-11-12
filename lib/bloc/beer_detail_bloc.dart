import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:punk_api/network/api_client.dart';
import './bloc.dart';

class BeerDetailBloc extends Bloc<BeerDetailEvent, BeerDetailState> {
  final _apiClient = APIClient();

  @override
  BeerDetailState get initialState => BeerDetailUnInitial();

  @override
  Stream<BeerDetailState> mapEventToState(
    BeerDetailEvent event,
  ) async* {
    if (event is GetBeerDetail) {
      try {
        yield BeerDetailLoading();
        final beer = await _apiClient.getBeerDetail(id: event.id);
        yield BeerDetailLoaded(beer: beer);
      } catch (e) {
        yield BeerDetailError(e.toString());
      }
    }
  }
}
