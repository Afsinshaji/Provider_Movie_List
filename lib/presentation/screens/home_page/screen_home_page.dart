//import 'package:dartz/dartz.dart';
import 'dart:developer';
import 'package:movie_app_provider/domain/movie_list/movie_list_model/result.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../application/movie_list/movie_list_provider.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  var isLastPage = false;
  int numberOfCalling = 1;
  List<Result> dataList = [];
  final ScrollController scrollController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MovieListProvider>(context, listen: false)
          .getMovieList(numberOfCalling);
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        log('hei');
        numberOfCalling = numberOfCalling + 1;
        Provider.of<MovieListProvider>(context, listen: false)
            .getMovieList(numberOfCalling);
        // setState(() {
        //   numberOfCalling = numberOfCalling + 1;

        // });
      }
    });
    return Scaffold(
      body: SafeArea(child: Consumer<MovieListProvider>(
        // future: MovieListImplementation.instance.movieList(numberOfCalling),
        builder: (context, movieListProvider, _) {
          final movieData = movieListProvider.resultData;
          if (movieData.isLoading) {
            return const CircularProgressIndicator();
          } else if (movieData.isError) {
            return const Center(
              child: Text('Error while getting data'),
            );
          }
          final movieList = movieData.resultingData;

          if (movieList == null) {
            return const Text('Something Went Wrong');
          }

          dataList.addAll(movieList);
          movieList.clear();
          log(movieList.length.toString());
          log(dataList.length.toString());
          // dataList = movieList;
          if (dataList.isEmpty) {
            return const Text('Movie List is Empty');
          }
          return ListView.builder(
            controller: scrollController,
            itemCount: dataList.length + 1,
            itemBuilder: (context, index) {
              if (index == dataList.length) {
                return const CircularProgressIndicator();
              }
              final data = dataList[index];
              final title = data.originalTitle ??= 'No title';
              final imageUrl = data.posterImageUrl;
              return ListTile(
                leading: Image.network(imageUrl),
                title: Text(title),
              );
            },
          );
        },
      )),
    );
  }
}
