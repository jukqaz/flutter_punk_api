import 'package:equatable/equatable.dart';

abstract class BeerDetailEvent extends Equatable {
  const BeerDetailEvent();
}

class GetBeerDetail extends BeerDetailEvent {
  final double id;

  const GetBeerDetail({this.id});

  @override
  List<Object> get props => [id];
}
