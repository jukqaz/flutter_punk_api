import 'package:equatable/equatable.dart';

abstract class BeerEvent extends Equatable {
  const BeerEvent();
}

class GetBeers extends BeerEvent {
  final int page;
  final int perPage;

  const GetBeers({
    this.page = 1,
    this.perPage = 20,
  });

  @override
  List<Object> get props => [page, perPage];
}

class RefreshBeers extends BeerEvent {
  @override
  List<Object> get props => [];
}
