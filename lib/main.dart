import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

// Random Name generator
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final String _title = 'Random Name Generator';
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RandomNamesListWidget(title: _title),
    );
  }
}

class RandomNamesListWidget extends StatefulWidget {
  RandomNamesListWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RandomNamesListWidgetState createState() => _RandomNamesListWidgetState();
}

class _RandomNamesListWidgetState extends State<RandomNamesListWidget> {
  final List<WordPair> _words = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  /*//
   * Builds an infinite scroll view.
   * Adds 10 words pairs to the data source when the end of the list is reached.
   */
  Widget _buildListOfWords() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16),
        // The itemBuilder callback is called once per suggested
        // word pairing, and places each suggestion into a ListTile
        // row. For even rows, the function adds a ListTile row for
        // the word pairing. For odd rows, the function adds a
        // Divider widget to visually separate the entries. Note that
        // the divider may be difficult to see on smaller devices.
        itemBuilder: (BuildContext _context, int rowIndex) {
          if (rowIndex.isOdd) {
            return new Divider();
          }

          // The syntax "i ~/ 2" divides i by 2 and returns an
          // integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          final int index = rowIndex ~/ 2;
          if (index >= _words.length) {
            // reached the end... generate 10 more and add to the list
            _words.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_words[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
          ],
        ),
        body: _buildListOfWords());
  }

  Widget _buildRow(WordPair word) {
    final bool alreadySaved = _saved.contains(word);
    return new ListTile(
      title: new Text(word.asPascalCase, style: _biggerFont),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(word);
          } else {
            _saved.add(word);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      //  generates the ListTile rows.
      //  The divideTiles() method of ListTile adds horizontal
      //  spacing between each ListTile.
      //  The divided variable holds the final rows,
      //  converted to a list by the convenience function, toList().
      final Iterable<ListTile> tiles = _saved.map((WordPair pair) {
        return new ListTile(
          title: new Text(pair.asPascalCase, style: _biggerFont),
        );
      });
      final List<Widget> divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      // creates the layout structure for the material route
      return new Scaffold(
        appBar: new AppBar(
          title: const Text('Favorites'),
        ),
        body: new ListView(children: divided), // creates the list with the generates the ListTile rows.
      );
    }));
  }
}
