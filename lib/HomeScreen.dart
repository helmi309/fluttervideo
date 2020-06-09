import 'package:demoflutter/Disimpan.dart';
import 'package:demoflutter/plugin/times.dart';
import 'package:flutter/material.dart';
import 'package:demoflutter/data/api.dart';
import 'package:demoflutter/model/playing.dart';
import 'package:flutter/rendering.dart';
import 'package:like_button/like_button.dart';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:demoflutter/plugin/videowidget.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:isolate';
import 'dart:ui';

const debug = true;
ProgressDialog pr;
Random random = new Random();
final List<String> imgList = [
  'images/kategori1.jpg',
  'images/kategori2.jpg',
  'images/kategori3.jpg',
  'images/kategori4.jpg',
  'images/kategori5.jpg',
  'images/kategori6.jpg',
  'images/kategori7.jpg',
  'images/kategori8.jpg',
  'images/kategori9.jpg',
];
final List<String> kategori = [
  'Alay',
  'Bocah',
  'Cerdas',
  'Jail',
  'Nob',
  'Sekolah',
  'So Cool',
  'Tiktok',
  'Wanita',
];
String dropdownValue = 'Terbaru';

class HomeScreen extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomeScreen> {
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Story Video Lucu');
  final TextEditingController _filter = new TextEditingController();
  List filteredNames = new List();
  List names = new List();
  var filter = "";
  var sort = "";
  Future _future;
  int _selectedIndex = 0;

  @override
  void initState() {
    if (dropdownValue == "Terbaru") {
      sort = "Desc";
    } else {
      sort = "Asc";
    }
    _future = MovieRepository().getNowPlaying(1, filter, sort);
    super.initState();
  }

  void incrementCounter() {
    setState(() {
      print("test");
      dropdownValue = "Terbaru";
      sort = "Desc";
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

 void _onItemTapped(int index) {
   print(index);
    if(index == 0){
       Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HomeScreen()),
    );
    }
    else if(index == 1) {
       Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DisimpanScreen()),
    );
    }
   }
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    pr = new ProgressDialog(context);
    pr.style(
        message: 'Menyiapkan Video...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey,
      appBar: _buildBar(context),
      body: Column(

        children: <Widget>[
          Container(
              color: Colors.white,
              child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  initialPage: 2,
                  autoPlay: true,
                  height: 60.0,
                ),
                items: imgList.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        child: new InkWell(
                            onTap: () {
                              onSearchTextChanged(kategori[imgList.indexOf(i)]);
                            },
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  child: Stack(
                                    children: <Widget>[
                                      Image.asset(
                                        i,
                                        fit: BoxFit.cover,
                                        width: 1000.0,
                                        height: 50.0,
                                      ),
                                      Positioned(
                                        bottom: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(200, 0, 0, 0),
                                                Color.fromARGB(0, 0, 0, 0)
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          child: Text(
                                            kategori[imgList.indexOf(i)],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            )),
                      );
                    },
                  );
                }).toList(),
              )),
          Expanded(
              child: FutureBuilder(
            future: _future,
            builder: (BuildContext c, AsyncSnapshot s) {
              if (s.connectionState != ConnectionState.done) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (s.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else
                return MovieList(
                  playing: s.data,
                  cari: filter,
                  sort: sort,
                  dropdownValue: dropdownValue,
                  parent: this,
                  platform: platform,
                );
            },
          ))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ondemand_video),
            title: Text('Disimpan'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text('Kategori'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[1000],
        onTap: (_onItemTapped),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
      actions: <Widget>[
        DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.filter_list),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(
            color: Colors.white,
          ),
          dropdownColor: Colors.blue,
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
              if (dropdownValue == "Terbaru") {
                sort = "Desc";
              } else {
                sort = "Asc";
              }
              _future = MovieRepository().getNowPlaying(1, filter, sort);
            });
          },
          items: <String>['Terbaru', 'Terlama']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ],
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Cari...'),
          onChanged: onSearchTextChanged,
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Story Video Lucu');
        filteredNames = names;
      }
    });
  }

  onSearchTextChanged(String text) {
    setState(() {
      if (dropdownValue == "Terbaru") {
        sort = "Desc";
      } else {
        sort = "Asc";
      }
      filter = text;
      _future = MovieRepository().getNowPlaying(1, filter, sort);
    });
  }
}

class MovieList extends StatefulWidget {
  final Playing playing;
  final String cari;
  final String sort;
  final String dropdownValue;
  final TargetPlatform platform;

  _HomePage parent;

  MovieList({
    this.playing,
    this.cari,
    this.sort,
    this.dropdownValue,
    this.parent,
    this.platform,
    Key key,
  }) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  AdmobInterstitial interstitialAdshare;

  ScrollController scrollController = new ScrollController();
  List<Result> movie;
  bool disabledbutton = true;
  String iklanfull = "";
  String iklanfullshare = "";
  int currentPage = 1;
  int iklan = 2;
  String _localPath;
  bool _permissionReady;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    _permissionReady = false;
//    _downloadListener();
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    movie = widget.playing.data;
    Admob.initialize('ca-app-pub-2293684218177669~1692192443');
    interstitialAd = AdmobInterstitial(
      adUnitId: "ca-app-pub-2293684218177669/1532959085",
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) {
          interstitialAd.load();
          downloadfile(iklanfull);
          iklanfull = "";
        }
      },
    );
    interstitialAd.load();
    interstitialAdshare = AdmobInterstitial(
      adUnitId: "ca-app-pub-2293684218177669/1532959085",
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) {
          interstitialAdshare.load();
          sharefile(iklanfullshare);
          iklanfullshare = "";
        }
        if (event == AdmobAdEvent.opened) {
        }
      },
    );
    interstitialAdshare.load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    interstitialAd.dispose();
    interstitialAdshare.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("Tarik ke bawah untuk load data");
          } else if (mode == LoadStatus.loading) {
            body = CircularProgressIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("release to load more");
          } else {
            body = Text("No more Data");
          }
          return Container(
              height: 55.0,
              child: Column(children: <Widget>[
                Column(children: <Widget>[Center(child: body)])
              ]));
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
          itemCount: movie.length,
          controller: scrollController,
          itemBuilder: (BuildContext c, int i) {
            return Column(children: <Widget>[
              Column(children: <Widget>[
                Container(
                  color: Colors.grey,
                  child: i == iklan
                      ? 
                       new Center(
                       child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: AdmobBanner(
                                adUnitId: "ca-app-pub-2293684218177669/9877518817",
                                adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                              ))))
                      : Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                ),
              ]),
              Container(
                margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0))),
                padding: EdgeInsets.all(0.0),
                child: ListTile(
                  leading: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      child: ClipOval(
                        child: Image(
                          height: 30.0,
                          width: 30.0,
                          image: AssetImage("images/icon.google.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    "Admin",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print(disabledbutton);
                  if (disabledbutton) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _buildAboutDialog(
                          context, movie[i].name, movie[i].file),
                    );
                  }
                  disabledbutton = false;
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
                  height: 320.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          image: NetworkImage(
                              'http://153.92.4.241/assets/status/image/' +
                                  movie[i].image),
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.topCenter)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 2.0),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Text(movie[i].kategori,
                                style: TextStyle(color: Colors.white)),
                          ),
                          RaisedButton.icon(
                            color: Colors.white,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              if (disabledbutton) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildAboutDialog(context, movie[i].name,
                                          movie[i].file),
                                );
                              }
                              disabledbutton = false;
                            },
                            label: Text('Lihat Video'),
                            icon: Icon(Icons.keyboard_arrow_right),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0)),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.share),
                                      iconSize: 30.0,
                                      onPressed: () async {
                                        Random r = new Random();
                                        bool value = r.nextBool();
                                        if (value == true) {
                                          iklanfullshare = movie[i].file;
                                          if (await interstitialAdshare
                                              .isLoaded) {
                                            interstitialAdshare.show();
                                          }
                                        } else {
                                          sharefile(movie[i].file);
                                        }
                                      }),
                                ],
                              ),
                              SizedBox(width: 20.0),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.file_download),
                                    iconSize: 30.0,
                                    onPressed: () async {
                                      Random r = new Random();
                                      bool value = r.nextBool();
                                      if (value == true) {
                                        iklanfull = movie[i].file;
                                        if (await interstitialAd.isLoaded) {
                                          interstitialAd.show();
                                        }
                                      } else {
                                        downloadfile(movie[i].file);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          LikeButton(likeCount: movie[i].suka)
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 15, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              movie[i].name,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              Times.timeAgoSinceDate(movie[i].created_at),
                              style:
                                  TextStyle(fontSize: 12.0, color: Colors.grey),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ])),
            ]);
          }),
    );
  }

  Widget _buildAboutDialog(BuildContext context, name, file) {
    disabledbutton = true;

    return new AlertDialog(
      insetPadding: EdgeInsets.symmetric(vertical: 50),
      title: Text(name),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              key: new PageStorageKey(
                "keydata" + file,
              ),
              child: VideoWidget(
                url: "http://153.92.4.241/assets/status/video/" + file,
                play: true,
              )),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Keluar'),
        ),
      ],
    );
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
//    widget.incrementCounter;

    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted)
      MovieRepository().getNowPlaying(1, "", "Desc").then((val) {
        widget.parent.setState(() {
          dropdownValue = "Terbaru";
          widget.parent._filter.text = "";
        });
        setState(() {
          iklan = 2;
          currentPage = 1;
          movie.clear();
          movie.addAll(val.data);
        });
      });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted)
      MovieRepository()
          .getNowPlaying(currentPage + 1, widget.cari, widget.sort)
          .then((val) {
        currentPage = val.page;
        setState(() {
          iklan = iklan + 4;
          movie.addAll(val.data);
        });
      });
    _refreshController.loadComplete();
  }

  Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void downloadfile(file) async {
    _permissionReady = await _checkPermission();
    if (_permissionReady) {_localPath =
          (await _findLocalPath()) + Platform.pathSeparator + 'Download Video';

      final savedDir = Directory(_localPath);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }
      final taskId = await FlutterDownloader.enqueue(
        url: 'http://153.92.4.241/assets/status/video/' + file,
        savedDir: _localPath,
        showNotification: true,
        // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
      pr.show();
    } else {
      final snackBar =
          SnackBar(content: Text('Aktifkan dulu mode penyimpanan'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void sharefile(file) async {
    pr.show();
    pr.update(
        message: 'MenyiaMenyiapkan Video ...',
        progressWidget: CircularProgressIndicator(),
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    var request = await HttpClient()
        .getUrl(Uri.parse("http://153.92.4.241/assets/status/video/" + file));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);

    await Share.file('Share Video', file, bytes, 'video/mp4');
    pr.hide();
  }

  Future<bool> _checkPermission() async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result =
        await _permissionHandler.requestPermissions([PermissionGroup.storage]);
    if (result[PermissionGroup.storage] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      int progress = data[2];
      pr.update(
          message: 'Download Video $progress %',
          progressWidget: CircularProgressIndicator(),
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 19.0,
              fontWeight: FontWeight.w600));
      if (progress == 100) {
        pr.hide();
        final snackBar = SnackBar(content: Text('Download selesai'));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
}
