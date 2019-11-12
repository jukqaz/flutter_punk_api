import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punk_api/bloc/bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider<BeerBloc>(
          builder: (context) => BeerBloc()..dispatch(GetBeers()),
          child: MyHomePage(),
        ),
      );
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _scrollController;
  BeerBloc _beerBloc;

  @override
  void initState() {
    super.initState();
    _beerBloc = BlocProvider.of<BeerBloc>(context);
    _scrollController = ScrollController()
      ..addListener(() {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        if (maxScroll - currentScroll <= 150.0) {
          _beerBloc.dispatch(GetBeers());
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 150.0,
              flexibleSpace: FlexibleSpaceBar(
                background: FlutterLogo(),
              ),
              pinned: true,
              title: Text('Beer List'),
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                final completer = Completer<String>();

                final streamSubscription = _beerBloc.state.listen((state) {
                  if (state is BeerLoaded || state is BeerError) {
                    completer.complete('Done');
                  }
                });
                _beerBloc.dispatch(GetBeers(page: 0));

                await (completer.future
                  ..whenComplete(() => streamSubscription.cancel()));
              },
            ),
            SliverSafeArea(
              top: false,
              sliver: BlocBuilder<BeerBloc, BeerState>(
                builder: (context, state) {
                  if (state is BeerError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text('${state.msg}'),
                      ),
                    );
                  } else if (state is BeerLoaded) {
                    if (state.beers.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Text('No Beers'),
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (state.beers.length <= index) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final beer = state.beers[index];
                          return ListTile(
                            leading: Image.network(beer.imageUrl),
                            title: Text('${beer.id.toInt()} - ${beer.name}'),
                            subtitle: Text('${beer.firstBrewed}'),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider<BeerDetailBloc>(
                                  builder: (context) => BeerDetailBloc()
                                    ..dispatch(
                                      GetBeerDetail(id: beer.id),
                                    ),
                                  child: BeerDetailScreen(),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: state.hasReachedMax
                            ? state.beers.length
                            : state.beers.length + 1,
                      ),
                    );
                  } else {
                    return SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
}

class BeerDetailScreen extends StatefulWidget {
  @override
  _BeerDetailScreenState createState() => _BeerDetailScreenState();
}

class _BeerDetailScreenState extends State<BeerDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameTextEditingController;

  @override
  void initState() {
    super.initState();

    _nameTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<BeerDetailBloc, BeerDetailState>(
        builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: Text('Beer Detail'),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nameTextEditingController
                      ..text = state is BeerDetailLoaded ? state.beer.name : '',
                    enabled: state is BeerDetailLoaded,
                  ),
                ],
              ),
            ),
          ),
      );
}
