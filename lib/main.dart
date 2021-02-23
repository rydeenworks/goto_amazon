import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'GoTo Amazon'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _iconSize = 42.0;
  final _biggerFont =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, height: 3);
  String _sortType = '&s=relevanceblender';
  void _handleRadioSort(String e) => setState(() {
        _sortType = e;
      });

  String _textSearch = '';
  void _handleTextSearch(String e) {
    setState(() {
      _textSearch = e;
    });
  }

  bool _isSort = true;
  void _onChangeEnableSort(bool b) {
    setState(() {
      _isSort = b;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '検索キーワード',
            ),
            onChanged: _handleTextSearch,
          ),
          Divider(),
          Container(
            color: _isSort ? Colors.amber : Colors.grey,
            child: new CheckboxListTile(
              title: Text('商品の並び順を指定する', style: _biggerFont),
              value: _isSort,
              onChanged: _onChangeEnableSort,
            ),
          ),
          Container(
            color: _isSort ? Colors.white : Colors.grey,
            child: new RadioListTile(
              secondary: Icon(Icons.recommend, size: _iconSize),
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text('Amazonおすすめ順'),
              subtitle: Text('&s=relevanceblender'),
              value: '&s=relevanceblender',
              groupValue: _sortType,
              onChanged: _handleRadioSort,
            ),
          ),
          Container(
            color: _isSort ? Colors.white : Colors.grey,
            child: new RadioListTile(
              secondary: Icon(Icons.trending_up, size: _iconSize),
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text('価格の安い順'),
              subtitle: Text('&sort=price'),
              value: '&sort=price',
              groupValue: _sortType,
              onChanged: _handleRadioSort,
            ),
          ),
          Container(
            color: _isSort ? Colors.white : Colors.grey,
            child: new RadioListTile(
              secondary: Icon(Icons.trending_down, size: _iconSize),
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text('価格の高い順'),
              subtitle: Text('&sort=-price'),
              value: '&sort=-price',
              groupValue: _sortType,
              onChanged: _handleRadioSort,
            ),
          ),
          Container(
            color: _isSort ? Colors.white : Colors.grey,
            child: new RadioListTile(
              secondary: Icon(Icons.thumb_up, size: _iconSize),
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text('レビュー評価順'),
              subtitle: Text('&sort=review-rank'),
              value: '&sort=review-rank',
              groupValue: _sortType,
              onChanged: _handleRadioSort,
            ),
          ),
          Container(
            color: _isSort ? Colors.white : Colors.grey,
            child: new RadioListTile(
              secondary: Icon(Icons.date_range, size: _iconSize),
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text('発売日が新しい順'),
              subtitle: Text('&sort=-releasedate'),
              value: '&sort=-releasedate',
              groupValue: _sortType,
              onChanged: _handleRadioSort,
            ),
          ),
          Divider(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchURL,
        icon: Icon(Icons.open_in_browser),
        label: Text('GoTo Amazon'),
      ),
    );
  }

  _launchURL() async {
    var url = 'https://www.amazon.co.jp/s?k=$_textSearch';
    if (_isSort) {
      url += '&$_sortType';
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
