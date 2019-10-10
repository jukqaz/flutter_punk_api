import 'package:equatable/equatable.dart';
import 'package:punk_api/model/beer.dart';

abstract class BeerState extends Equatable {
  const BeerState();
}

class BeerNothing extends BeerState {
  @override
  List<Object> get props => [];
}

class BeerLoading extends BeerState {
  @override
  List<Object> get props => [];
}

class BeerLoaded extends BeerState {
  final List<Beer> beers;
  final bool hasReachedMax;

  const BeerLoaded({this.beers, this.hasReachedMax = false});

  @override
  List<Object> get props => [beers, hasReachedMax];

  BeerLoaded copyWith({List<Beer> beers, bool hasReachedMax}) => BeerLoaded(
        beers: beers ?? this.beers,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );
}

class BeerError extends BeerState {
  final String msg;

  const BeerError(this.msg);

  @override
  List<Object> get props => [msg];
}

class RefreshBeersDone extends BeerState {
  @override
  List<Object> get props => [];
}
