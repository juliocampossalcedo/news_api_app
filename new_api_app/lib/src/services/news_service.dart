import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_api_app/src/models/category_model.dart';
import 'package:new_api_app/src/models/news_models.dart';
import 'package:http/http.dart' as http;


final _URL_NEWS = 'https://newsapi.org/v2';
final _APIKEY   = 'cf4f46dd53834090aa54769227416c37';

class NewsService with ChangeNotifier {

  List<Article> headlines = [];
  String _selectedCategory = 'business';

  bool _isLoading = true;

  List<Category> categories = [
    Category( FontAwesomeIcons.building, 'business'  ),
    Category( FontAwesomeIcons.tv, 'entertainment'  ),
    Category( FontAwesomeIcons.addressCard, 'general'  ),
    Category( FontAwesomeIcons.headSideVirus, 'health'  ),
    Category( FontAwesomeIcons.vials, 'science'  ),
    Category( FontAwesomeIcons.volleyballBall, 'sports'  ),
    Category( FontAwesomeIcons.memory, 'technology'  ),
  ];

  Map<String, List<Article>> categoryArticles = {};


      
  NewsService() {
    this.getTopHeadlines();

    categories.forEach( (item) {
      this.categoryArticles[item.name] = <Article>[];
    });

    this.getArticlesByCategory( this._selectedCategory );
  }

  bool get isLoading => this._isLoading;


  String get selectedCategory => this._selectedCategory;
  set selectedCategory( String valor ) {
    this._selectedCategory = valor;

    this._isLoading = true;
    this.getArticlesByCategory( valor );
    notifyListeners();
  }
  
  List<Article>? get getArticulosCategoriaSeleccionada => this.categoryArticles[ this.selectedCategory ];



  getTopHeadlines() async {
    
      final url ='$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=ca';
      final resp = await http.get(Uri.parse(url));

      final newsResponse = newsResponseFromJson( resp.body );

      this.headlines.addAll( newsResponse.articles );
      notifyListeners();
  }

  getArticlesByCategory( String category ) async {

      if ( this.categoryArticles[category]!.length > 0 ) {
        this._isLoading = false;
        notifyListeners();
        return this.categoryArticles[category];
      }

      final url ='$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=ca&category=$category';
      print('url ' + url);
      final resp = await http.get(Uri.parse(url));
      print('resp ' + resp.body);

      final newsResponse = newsResponseFromJson( resp.body );

      this.categoryArticles[category]?.addAll( newsResponse.articles );

      this._isLoading = false;
      notifyListeners();

  }


}




