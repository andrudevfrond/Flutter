import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';

class MovieSlider extends StatefulWidget {
  
final List<Movie> movies;
final String? title;
final Function onNextPage;

  const MovieSlider({
    super.key, 
    required this.movies, 
    required this.onNextPage,
    this.title, 
  });

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // implement initState
    super.initState();

    scrollController.addListener((){
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 300){
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    // implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (widget.movies.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        height: 275,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 275,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.title != null ? 
          Padding(
            padding: const EdgeInsets.symmetric( horizontal: 20.0),
            child: Text(widget.title.toString(), style: const TextStyle(fontSize: 20, fontWeight:FontWeight.bold)),
          ): Padding(
            padding: const EdgeInsets.symmetric( horizontal: 20.0),
            child: Text('Sin titulo'.toString(), style: const TextStyle(fontSize: 20, fontWeight:FontWeight.bold)),
          ),
          const SizedBox(height: 5.0,),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int index) => _MoviePoster(movie: widget.movies[index],heroId:'${ widget.title}-$index-${widget.movies[index].id}'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  
  final Movie movie;
  final String heroId;

  const _MoviePoster({required this.movie, required this.heroId});

  @override
  Widget build(BuildContext context) {

    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed( context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5.0,),
          Text(movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}