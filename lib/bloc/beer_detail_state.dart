import 'package:equatable/equatable.dart';
import 'package:punk_api/model/beer.dart';

abstract class BeerDetailState extends Equatable {
  const BeerDetailState();
}

class BeerDetailUnInitial extends BeerDetailState {
  @override
  List<Object> get props => [];
}

class BeerDetailLoading extends BeerDetailState {
  @override
  List<Object> get props => [];
}

class BeerDetailLoaded extends BeerDetailState {
  final Beer beer;

  const BeerDetailLoaded({this.beer});

  @override
  List<Object> get props => [beer];
}

class BeerDetailError extends BeerDetailState {
  final String msg;

  const BeerDetailError(this.msg);

  @override
  List<Object> get props => [msg];

  @override
  String toString() => '$BeerDetailError msg: $msg';
}
