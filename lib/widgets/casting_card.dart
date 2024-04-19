import 'package:flutter/cupertino.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCard extends StatelessWidget {

  final int movieId;

  const CastingCard(this.movieId, {super.key});
  
  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        
        if (!snapshot.hasData){
          return Container(
            margin: const EdgeInsets.only(bottom: 30.0),
            height: 100,
            child: const CupertinoActivityIndicator(),
          );
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 30.0),
          width: double.infinity,
          height: 190,
          //color: Colors.red,
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, int index) => _CastCard(cast: snapshot.data![index])
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {

  final Cast cast;

  const _CastCard({required this.cast});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 100,
      //color: Colors.green,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(cast.fullProfrilePath),
              height:140,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5.0,),
          Text(cast.name.toString(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          
          ),
          
        ],
      ),
    );
  }
}