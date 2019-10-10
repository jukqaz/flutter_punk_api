import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:punk_api/network/api_client.dart';
import 'package:rxdart/rxdart.dart';
import './bloc.dart';

class BeerBloc extends Bloc<BeerEvent, BeerState> {
  final _apiClient = APIClient();

  @override
  BeerState get initialState => BeerNothing();

  @override
  Stream<BeerState> transformEvents(Stream<BeerEvent> events,
          Stream<BeerState> Function(BeerEvent event) next) =>
      super.transformEvents(
        (events as Observable<BeerEvent>).debounceTime(
          Duration(milliseconds: 500),
        ),
        next,
      );

  @override
  Stream<BeerState> mapEventToState(
    BeerEvent event,
  ) async* {
    if (event is GetBeers && !_hasReachedMax(currentState)) {
      try {
        if (event.page == 0 || currentState is BeerNothing) {
          final beers = await _apiClient.getBeers();
          yield BeerLoaded(beers: beers);
        } else if (currentState is BeerLoaded) {
          final cs = currentState as BeerLoaded;
          final beers = await _apiClient.getBeers(
            page: cs.beers.length ~/ 20 + 1,
          );
          yield beers.isEmpty
              ? cs.copyWith(hasReachedMax: true)
              : BeerLoaded(
                  beers: cs.beers + beers,
                  hasReachedMax: false,
                );
        }
      } catch (e) {
        yield BeerError(e.toString());
      }
    }
  }

  bool _hasReachedMax(BeerState state) =>
      state is BeerLoaded && state.hasReachedMax;
}
