import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

@Deprecated('play only')
class MyText extends StatelessWidget {
  final String word;
  const MyText(this.word, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(child: Text(word));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'WELCOME TO FLUTTER',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white, foregroundColor: Colors.black)),
        home: const RandomWords(),
      );
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

const _listPadding = EdgeInsets.all(16.0);
const _biggerFont = TextStyle(fontSize: 18);

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>[];

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) {
        final tiles = _saved.map((pair) => ListTile(
              title: Text(pair.asPascalCase, style: _biggerFont),
            ));

        final appBar = AppBar(
          title: const Text('Saved Suggetions'),
        );

        final body = ListView(
          children: (tiles.isNotEmpty
                  ? ListTile.divideTiles(tiles: tiles, context: context)
                  : <Widget>[])
              .toList(),
        );

        return Scaffold(
          appBar: appBar,
          body: body,
        );
      },
    ));
  }

  Widget _listItemBuilderImple(BuildContext context, int i) {
    if (i.isOdd) {
      return const Divider();
    }
    // divides i by 2 and returns an integer result
    // 1 ~/ 2 = 0 5~/2 = 2
    final idx = i ~/ 2;
    if (idx >= _suggestions.length) {
      _suggestions.addAll(generateWordPairs().take(10));
    }

    final alreadySaved = _saved.contains(_suggestions[idx]);

    return _ListTile(_suggestions[idx].asPascalCase, alreadySaved, () {
      if (alreadySaved) {
        setState(() {
          _saved.remove(_suggestions[idx]);
        });
        return;
      }
      setState(() {
        _saved.add(_suggestions[idx]);
      });
    });
  }

  ListView _buildListView() => ListView.builder(
        padding: _listPadding,
        itemBuilder: _listItemBuilderImple,
      );

  AppBar _buildAppbar() => AppBar(
        title: const Text('Start up Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Saved Suggestions',
            onPressed: _pushSaved,
          )
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppbar(),
        body: _buildListView(),
      );
}

class _ListTile extends StatelessWidget {
  final String tile;
  final bool liked;
  final Function update;
  const _ListTile(this.tile, this.liked, this.update, {Key? key})
      : super(key: key);

  Icon _generateIcon() => Icon(
        liked ? Icons.favorite : Icons.favorite_border,
        color: liked ? Colors.red : null,
        semanticLabel: liked ? 'Remove from Like' : 'Like',
      );

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(tile, style: _biggerFont),
        trailing: _generateIcon(),
        onTap: () => update(),
      );
}
