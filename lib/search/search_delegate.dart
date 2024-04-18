
import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate{


  @override
  // implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar Peliculas';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '', 
        icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, null);
      }, 
      icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResult');
  }

  Widget _empyContainer(){
    return const Center(
      child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size:100),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if (query.isEmpty) return _empyContainer();

    final movieProvider = Provider.of<MoviesProvider>(context, listen: false);
    movieProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: movieProvider.suggestionStream,
      builder: (_, AsyncSnapshot snapshot) {

        if (!snapshot.hasData) return _empyContainer();

        final movies = snapshot.data;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, int index) => MovieItem(movies[index]),
        );
      },
    );
  }
}

class MovieItem extends StatelessWidget {
  
final Movie movie;

  const MovieItem(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {

    movie.heroId = 'search-${movie.id}';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      alignment: Alignment.center,
      height:80.0,
      child: ListTile(
        leading: Hero(
          tag: movie.heroId!,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'), 
              image: NetworkImage(movie.fullPosterImg),
              width: 50.0,
              fit: BoxFit.fitWidth,
            ),      
          ),
        ),
        title: Text(movie.originalTitle),
        onTap: (){
          Navigator.pushNamed(context, 'details', arguments: movie);
        },
      ),
    );
  }
}