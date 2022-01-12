import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:goto_amazon/services/admob.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'World Ama Shopping',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'GoTo World Amazon'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // https://github.com/ashhitch/ISO-country-flags-icons
  final _iconSize = 42.0;
  final _biggerFont = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  String _sortType = '&s=relevanceblender';
  void _handleRadioSort(String? e) => setState(() {
        _sortType = e ?? '&s=relevanceblender';
      });

  String _textSearch = '';
  void _handleTextSearch(String e) {
    setState(() {
      _textSearch = e;
    });
  }

  String _worldUrl = 'www.amazon.co.jp';

  var country = {
    "www.amazon.com.tr": "tr",
    "www.amazon.co.jp": "jp",
    "www.amazon.cn": "cn",
    "www.amazon.es": "es",
    "www.amazon.com.mx": "mx",
    "www.amazon.com.au": "au",
    "www.amazon.fr": "fr",
    "www.amazon.co.uk": "gb",
    "www.amazon.in": "in",
    "www.amazon.sg": "sg",
    "www.amazon.com": "us",
    "www.amazon.sa": "sa",
    "www.amazon.it": "it",
    "www.amazon.com.br": "br",
    "www.amazon.ca": "ca",
    "www.amazon.nl": "nl",
    "www.amazon.de": "de",
    "www.amazon.se": "se",
    "www.amazon.ae": "ae",
  };

  // バナー広告をインスタンス化
  BannerAd myBanner = BannerAd(
    adUnitId: AdMobService().getBannerAdUnitId(),
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  @override
  Widget build(BuildContext context) {
    // バナー広告の読み込み
    myBanner.load();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        children: <Widget>[
          Container(
            color: Colors.white,
            height: 64.0,
            width: double.infinity,
            child: AdWidget(ad: myBanner),
          ),
          Container(
            color: Colors.orange,
            padding: EdgeInsets.all(6),
            child: Text(
              "Amazon URL",
              style: _biggerFont,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            margin: EdgeInsets.all(6),
            child: ListTile(
              leading: Image.asset(
                  'images/' + (country[_worldUrl] ?? "jp") + '.png'),
              title: Text('$_worldUrl'),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorldRoute()),
                );

                if (result == "") {
                  return;
                }
                setState(() {
                  _worldUrl = result;
                });
              },
            ),
          ),
          Container(
            color: Colors.orange,
            padding: EdgeInsets.all(6),
            child: Text(
              "Search Word",
              style: _biggerFont,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            margin: EdgeInsets.all(6),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search Word',
              ),
              onChanged: _handleTextSearch,
            ),
          ),
          Container(
            color: Colors.orange,
            padding: EdgeInsets.all(6),
            child: Text(
              "Sort Order",
              style: _biggerFont,
            ),
          ),
          Container(
            child: new RadioListTile(
              secondary: Icon(Icons.recommend, size: _iconSize),
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text('Amazon Recommended'),
              value: '&s=relevanceblender',
              groupValue: _sortType,
              onChanged: _handleRadioSort,
            ),
          ),
          Container(
            child: new RadioListTile(
              secondary: Icon(Icons.trending_up, size: _iconSize),
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text('Low Price'),
              value: '&sort=price',
              groupValue: _sortType,
              onChanged: _handleRadioSort,
            ),
          ),
          Container(
            child: new RadioListTile(
              secondary: Icon(Icons.trending_down, size: _iconSize),
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text('High Price'),
              value: '&sort=-price',
              groupValue: _sortType,
              onChanged: _handleRadioSort,
            ),
          ),
          Container(
            child: new RadioListTile(
              secondary: Icon(Icons.thumb_up, size: _iconSize),
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text('Review Rank'),
              value: '&sort=review-rank',
              groupValue: _sortType,
              onChanged: _handleRadioSort,
            ),
          ),
          Container(
            child: new RadioListTile(
              secondary: Icon(Icons.date_range, size: _iconSize),
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text('Release Date'),
              value: '&sort=-releasedate',
              groupValue: _sortType,
              onChanged: _handleRadioSort,
            ),
          ),
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
    var word = Uri.encodeComponent(_textSearch);
    var url = 'https://$_worldUrl/s?k=' +
        word +
        '&tag=dynamitecruis-22' +
        '&$_sortType';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class WorldRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, "");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Country'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, "");
            },
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            ListTile(
              leading: Image.asset('images/tr.png'),
              title: Text('www.amazon.com.tr'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.com.tr');
              },
            ),
            ListTile(
              leading: Image.asset('images/jp.png'),
              title: Text('www.amazon.co.jp'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.co.jp');
              },
            ),
            ListTile(
              leading: Image.asset('images/cn.png'),
              title: Text('www.amazon.cn'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.cn');
              },
            ),
            ListTile(
              leading: Image.asset('images/es.png'),
              title: Text('www.amazon.es'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.es');
              },
            ),
            ListTile(
              leading: Image.asset('images/mx.png'),
              title: Text('www.amazon.com.mx'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.com.mx');
              },
            ),
            ListTile(
              leading: Image.asset('images/au.png'),
              title: Text('www.amazon.com.au'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.com.au');
              },
            ),
            ListTile(
              leading: Image.asset('images/fr.png'),
              title: Text('www.amazon.fr'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.fr');
              },
            ),
            ListTile(
              leading: Image.asset('images/gb.png'),
              title: Text('www.amazon.co.uk'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.co.uk');
              },
            ),
            ListTile(
              leading: Image.asset('images/in.png'),
              title: Text('www.amazon.in'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.in');
              },
            ),
            ListTile(
              leading: Image.asset('images/sg.png'),
              title: Text('www.amazon.sg'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.sg');
              },
            ),
            ListTile(
              leading: Image.asset('images/us.png'),
              title: Text('www.amazon.com'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.com');
              },
            ),
            ListTile(
              leading: Image.asset('images/sa.png'),
              title: Text('www.amazon.sa'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.sa');
              },
            ),
            ListTile(
              leading: Image.asset('images/it.png'),
              title: Text('www.amazon.it'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.it');
              },
            ),
            ListTile(
              leading: Image.asset('images/br.png'),
              title: Text('www.amazon.com.br'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.com.br');
              },
            ),
            ListTile(
              leading: Image.asset('images/ca.png'),
              title: Text('www.amazon.ca'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.ca');
              },
            ),
            ListTile(
              leading: Image.asset('images/nl.png'),
              title: Text('www.amazon.nl'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.nl');
              },
            ),
            ListTile(
              leading: Image.asset('images/de.png'),
              title: Text('www.amazon.de'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.de');
              },
            ),
            ListTile(
              leading: Image.asset('images/se.png'),
              title: Text('www.amazon.se'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.se');
              },
            ),
            ListTile(
              leading: Image.asset('images/ae.png'),
              title: Text('www.amazon.ae'),
              onTap: () {
                Navigator.pop(context, 'www.amazon.ae');
              },
            ),
          ],
        ),
      ),
    );
  }
}
