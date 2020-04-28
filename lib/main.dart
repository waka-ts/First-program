import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

// RandomWordの呼び出し
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Start Up Name Generater',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

// Stateの生成
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() =>  RandomWordsState();
}

// Stateの中身
class RandomWordsState extends State<RandomWords>{
  //候補を記録
  final List<WordPair> _suggestions = <WordPair>[];
  //お気に入りを保存
  final Set<WordPair> _saved = new Set<WordPair>();

  final _biggerFont = const TextStyle(fontSize: 18.0);

  //押下を保存するメンバを追加
  void _pushSaved(){
    //routeをNavigatorのStackにpushする
    Navigator. of(context).push(
      //新しいrouteのコンテンツをMaterialPageRouteのbuilderプロパティで構築する
      //Build関数は匿名関数として記述する
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          //ListTileを生成
          final Iterable<ListTile> tiles = _saved.map(
              (WordPair pair){
                return new ListTile(
                  title: new Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
          );
          //ListTile間に横方向スペースの追加(1pixelのボーダー)
          final List<Widget> divided = ListTile.divideTiles(
              context: context,
              tiles: tiles)
             //tileをリストに変換
              .toList();

          //builderのreturn,新routeのUI
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            //ListTileを含んだListViewを表示する
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  

  @override
  //ScaffoldでUI生成　中身は_buildSuggestions
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Start Up Name Generater'),
        // タイトルにアクションの追加(アクションはWidgetの配列をとる)
        actions: <Widget>[
          //iconはiconButtonのメンバ、IconはIconsはウィジェット、
          //Icon(Icons.settings)でアイコンを使える
          //listは3行列のアイコン、押下で_pushSavedが作動
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
        ]
      ),
      body: _buildSuggestions(),
    );
  }

  //ListView表示させる レイアウトはBuildLowウィジェットで
  Widget _buildSuggestions() {
    return ListView.builder(
      //リスト中の文字の配置
      padding: const EdgeInsets.all(16.0),
      //itemBuilderはbuilderプロパティ
      //引数はBuildContextとi、iは1ずつ増えていく
      itemBuilder: (context, i) {
        //iが奇数なら水平線(DividerWidget)を返す
        if (i. isOdd) return Divider();
        //indexはiを2で割って整数で返す
        final index = i ~/ 2;
        //index>=候補郡の長さ、つまり単語郡の最後にきたら、、、
        if (index >= _suggestions.length){
        //さらに10個生成して候補に追加する
        _suggestions.addAll(generateWordPairs().take(10));
        }
        //indexが与えられる度に、buildRowが呼ばれる
        return _buildRow(_suggestions[index]);
       }
     );
    }

  //リストのレイアウト
  Widget _buildRow(WordPair pair) {
      // お気に入りがあるか確認 containsで値が入ってたらTrue
      final bool alreadySaved = _saved.contains(pair);
      //ListTileを返す。ListTileはListレイアウトを作るウィジェット
      return ListTile(
        title: Text(
          //WordPairを記述する
          pair.asPascalCase,
          style: _biggerFont,
        ),
        //trailingはアイコンウィジェット
        trailing: Icon(
          //trueでハート(赤)、falseでアンハートアイコン(色抜き)
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        //tapされると呼ばれる
        onTap: (){
          //setStateで状態の更新をUIに反映させる
          //すでにお気に入りならremove,そうじゃないならadd
          setState(()   {
            if(alreadySaved){
               _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        }
      );
  }
}