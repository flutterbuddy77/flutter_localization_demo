/*import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Localization Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Localization'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localization_app/constant/Constant.dart';
import 'package:flutter_localization_app/localization/localizations.dart';
import 'package:flutter_localization_app/model/RadioModel.dart';
import 'package:flutter_localization_app/screen/SplashScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) async {
    print('setLocale()');
    _MyAppState state = context.ancestorStateOfType(TypeMatcher<_MyAppState>());

    state.setState(() {
      state.locale = newLocale;
    });
  }

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  Locale locale;
  bool localeLoaded = false;

  @override
  void initState() {
    super.initState();
    print('initState()');

    this._fetchLocale().then((locale) {
      setState(() {
        this.localeLoaded = true;
        this.locale = locale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.localeLoaded == false) {
      return CircularProgressIndicator();
    } else {
      return MaterialApp(
          title: 'Localization Demo',
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(primarySwatch: Colors.blue),
          home: new SplashScreen(),
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''), // English
            const Locale('hi', ''), // Hindi
          ],
          locale: locale,
          routes: <String, WidgetBuilder>{
            HOME_SCREEN: (BuildContext context) => new HomeScreen(),
          });
    }
  }

  _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.getString('languageCode') == null) {
      return null;
    }

    print('_fetchLocale():' +
        (prefs.getString('languageCode') +
            ':' +
            prefs.getString('countryCode')));

    return Locale(
        prefs.getString('languageCode'), prefs.getString('countryCode'));
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<RadioModel> _langList = new List<RadioModel>();

  int _index=0;

  @override
  void initState() {
    super.initState();

    _initLanguage();

  }

  bool isDevicePlatformAndroid() {
    return Theme.of(context).platform == TargetPlatform.android;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF6F8FA),
        appBar: AppBar(
          elevation: isDevicePlatformAndroid() ? 0.2 : 0.0,
          backgroundColor: const Color(0xFFF6F8FA),
          title: new Center(
            child: new Text(
              AppLocalizations.of(context).appNameShort,
              style: TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        body: new Container(
            child: new Column(
          children: <Widget>[
            _buildMainWidget(),
            _buildLanguageWidget(),
          ],
        )));
  }

  Widget _buildMainWidget() {
    return new Flexible(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            _buildHeaderWidget(),
            _buildTitleWidget(),
            _buildDescWidget(),
          ],
        ),
      ),
      flex: 9,
    );
  }

  Widget _buildHeaderWidget() {
    return new Center(
      child: Container(
        margin: EdgeInsets.only(top: 0.0, left: 12.0, right: 12.0),
        height: 160.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.all(
            new Radius.circular(8.0),
          ),
          image: new DecorationImage(
            fit: BoxFit.contain,
            image: new AssetImage(
              'assets/images/ic_banner.png',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleWidget() {
    return new Container(
      margin: EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0),
      child: Text(
        AppLocalizations.of(context).title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDescWidget() {
    return new Center(
      child: Container(
        margin: EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
        child: Text(
          AppLocalizations.of(context).desc,
          style: TextStyle(
              color: Colors.black87,
              inherit: true,
              fontSize: 13.0,
              wordSpacing: 8.0),
        ),
      ),
    );
  }

  Widget _buildLanguageWidget() {
    return new Flexible(
      child: Container(
        padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
        margin: EdgeInsets.only(left: 4.0, right: 4.0),
        color: Colors.grey[100],
        child: ListView.builder(
          itemCount: _langList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return new InkWell(
              splashColor: Colors.blueAccent,
              onTap: () {
                setState(() {
                  _langList.forEach((element) => element.isSelected = false);
                  _langList[index].isSelected = true;
                  _index = index;
                  _handleRadioValueChanged();
                });
              },
              child: new RadioItem(_langList[index]),
            );
          },
        ),
      ),
    );
  }

  List<RadioModel> _getLangList() {
    if(_index==0) {
      _langList.add(new RadioModel(true, 'English'));
      _langList.add(new RadioModel(false, 'हिंदी'));
    } else if(_index==1) {
      _langList.add(new RadioModel(false, 'English'));
      _langList.add(new RadioModel(true, 'हिंदी'));
    }

    return _langList;
  }

  Future<String> _getLanguageCode() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('languageCode') == null) {
      return null;
    }
    print('_fetchLocale():' + prefs.getString('languageCode'));
    return prefs.getString('languageCode');
  }

  void _initLanguage() async {
    Future<String> status = _getLanguageCode();
    status.then((result) {
      if (result != null && result.compareTo('en') == 0) {
        setState(() {
          _index = 0;
        });
      }
      if (result != null && result.compareTo('hi') == 0) {
        setState(() {
          _index = 1;
        });
      } else {
        setState(() {
          _index = 0;
        });
      }
      print("INDEX: $_index");

      _setupLangList();
    });
  }

  void _setupLangList() {
    setState(() {
      _langList.add(new RadioModel(_index==0?true:false, 'English'));
      _langList.add(new RadioModel(_index==0?false:true, 'हिंदी'));
    });
  }

  void _updateLocale(String lang, String country) async {
    print(lang + ':' + country);

    var prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', lang);
    prefs.setString('countryCode', country);

    MyApp.setLocale(context, Locale(lang, country));
  }

  void _handleRadioValueChanged() {
    print("SELCET_VALUE: " + _index.toString());
    setState(() {
      switch (_index) {
        case 0:
          print("English");
          _updateLocale('en', '');
          break;
        case 1:
          print("Hindi");
          _updateLocale('hi', '');
          break;
      }
    });
  }


}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
      margin: EdgeInsets.only(left: 4.0, right: 4.0),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 4.0, right: 4.0),
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Container(
                  width: 60.0,
                  height: 4.0,
                  decoration: new BoxDecoration(
                    color: _item.isSelected
                        ? Colors.redAccent
                        : Colors.transparent,
                    border: new Border.all(
                        width: 1.0,
                        color: _item.isSelected
                            ? Colors.redAccent
                            : Colors.transparent),
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(2.0)),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.only(top: 8.0),
                  child: new Text(
                    _item.title,
                    style: TextStyle(
                      color:
                          _item.isSelected ? Colors.redAccent : Colors.black54,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
