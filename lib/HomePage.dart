import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:news_app/NewsCard.dart';

final String API_KEY = "43dc7e323fc94b659ce4c7b70f7137d2";
final String end_point = "https://newsapi.org/v2/";
String apiURL(){
  String url = end_point+"top-headlines?sources=the-hindu&apiKey="+API_KEY;
  return url;
}
class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() {
    return new _HomePageState();
  }
}
class _HomePageState extends State<HomePage> {
  final List<NewsCard> _news = <NewsCard>[];
  var resBody;
  bool loading = true;
  Brightness bright = Brightness.light;
  _toggle(bright){
    setState(() {
      this.bright = bright;
    });
  }
  getUserInfo() async {
    var res = await http
        .get(
        Uri.encodeFull(apiURL()),
        headers: {"Accept": "application/json"}
    );
    resBody = json.decode(res.body);
    if(resBody['status'] == 'ok'){
      _news.clear();
      print(resBody['articles']);
      for(var data in resBody['articles']){
        print(data);
        _news.add(new NewsCard(
          title:data['title'],
          author: data['author'],
          description: data['description'],
          name: data['source']['name'],
          url: data['url'],
          urlToImage: data['urlToImage'],
        ));
      }
      setState(() {
        loading = false;
        print("Loaded Data");
      });
    }else{
      print("Something Went Wrong"+resBody);
    }
  }
  Widget _buildBody() {
    if(loading){
      return new Center(
        child: new CircularProgressIndicator(),
      );
    }else{
      return new Column(
          children: <Widget>[
            new Flexible(
                child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _news[index],
                  itemCount: _news.length,
                )
            ),
          ],
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("News API App"),
      ),
      body: new Center(
        child:_buildBody(),
      ),
      drawer: new Drawer(
        child: new ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            const DrawerHeader(
                child: const Center(child: const Text('News API',style: TextStyle(fontSize: 22.0),))),
            const ListTile(
              title: const Text('Home'),
              selected: true,
            ),
            const ListTile(
              title: const Text('Available Newspaper'),
            ),
            const Divider(),
            new ListTile(
              title: const Text('Light'),
              trailing: new Radio(
                value: "Light",
                groupValue: "Brighness",
                onChanged: null,
              ),
              onTap: () {
                print("light");
                _toggle(Brightness.light);
                print(bright);
              },
            ),
            new ListTile(
              title: const Text('Dark'),
              trailing: new Radio(
                value: "Dark",
                groupValue: "Brighness",
                onChanged: null,
              ),
              onTap: () {
                print("dark");
                _toggle(Brightness.dark);
                print(bright);
              },
            ),
            const Divider(),
            new ListTile(
              title: new Text("Settings"),
            ),
            new ListTile(
              title: new Text("Share"),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

}