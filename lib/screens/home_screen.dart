import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {

  final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Peliculas en Taquilla',
            style: TextStyle(color: Colors.white70),
            ),
          ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()), 
            icon: const Icon(Icons.search_outlined, color: Colors.white70,)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
        
            // Tarjetas pricipales
            CardSwiper(movies: moviesProvider.onDisplayMovies),
        
            // Slider de peliculas Populares
            MovieSlider(
              movies: moviesProvider.onPopularMovies,
              title: 'Peliculas más Populares!!',
              onNextPage: () => moviesProvider.getPopularMovies(),
              ),
        
        
          ],
        ),
      )
    );
  }
}