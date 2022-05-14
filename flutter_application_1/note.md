# Note

## Widget

In Flutter almost everything is a widget, including alignment,padding and layout.

A scaffold is widget from material library. provide default app bar, title and a body property.

```dart
Scaffold(
  appBar: AppBar(
    title:const Text('Welcome to Flutter'),
  ),
  body: const Center(
    child:Text('Hello World')
  )
)
```

and the body property holds the widget tree for the home screen, the widget subtree can be quite complex.

## build

A widget's main job is provide a build method that describes how to display the widget in term of other low-level widgets

```dart
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      appBar: appBar,
      body: const Center(
        child: Text('1231231'),
      ),
    );

    return MaterialApp(
      title: 'WELCOME TO FLUTTER',
      home: Scaffold(
        appBar:AppBar(
          title:const Text('Welcome to Flutter')
        ),
        body: const Center(
          child:Text('Hello World')
        )
      ),
    );
  }
```

## 3rd Party: pub.dev

```bash
dart pub add english_words
# or flutter
flutter pub add english_words
```

Dependences are installed in pubspec.yaml

```dart
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
```

Dart will export uppercase stuff as public

## Stateless Widget

Stateless widget are immutable, means that their properties can't change, all values are final.
it only depends on external resource.

```dart
class MyText extends StatelessWidget {
  // the constructor will use for receive the props
  const MyText(this.word, {Key? key}) : super(key: key);

  final String word;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(word));
  }
}
```

## Stateful Widget

Stateful widget maintain state that might change during the lifetime, need 2 classes

- State
- StatefulWidget

StatefulWidget object is immutable and can be thrown away and regenrated,
but state object persists over the lifetime of the widget.

`The Widget class is template, state is the data`

```dart
const _listPadding = EdgeInsets.all(16.0);
const _biggerFont = TextStyle(fontSize: 18);

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>[];

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
        // setState will call build() in this State method
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

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: _listPadding,
        itemBuilder: _listItemBuilderImple,
      );
}

class _ListTile extends StatelessWidget {
  final String tile;
  final bool liked;
  final Function update;
  const _ListTile(this.tile, this.liked, this.update, {Key? key})
      : super(key: key);

  Icon generateIcon() {
    return Icon(
      liked ? Icons.favorite : Icons.favorite_border,
      color: liked ? Colors.red : null,
      semanticLabel: liked ? 'Remove from Like' : 'Like',
    );
  }

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(tile, style: _biggerFont),
        trailing: generateIcon(),
        onTap: () {
          update();
        },
      );
}
```

## Navigate

Navigator manages a stack containing the app's routes,
pushing a route onto the navigator's stack updates the display to that route.
Popping a route from the Navigator's stack returns the display to previous route.

```dart
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
```
