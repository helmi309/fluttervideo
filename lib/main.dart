import 'dart:async';
import 'package:demoflutter/HomeScreen.dart';
import 'package:demoflutter/Disimpan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Demo Flutter',
        home: SplashScreen(),
      routes: <String, WidgetBuilder>{
          "/home" : (context) => HomeScreen(),
          "/disimpan" : (context) => DisimpanScreen(),
        },
    );
  }
}
class SplashScreen extends StatefulWidget { // splash screen
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  int modAnimation = 0;
  Timer _timer;


  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
    super.initState();
    Future.delayed(Duration(seconds: 3), (){
      _timer.cancel();
      controller.dispose();
      Navigator.of(context).pushReplacementNamed('/home');

    });

    _timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        if (modAnimation == 0){
          modAnimation = 1;
        }else{
          modAnimation = 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    Widget getLoading(){
      List<Widget> lst = [];
      for(int i = 0; i < 30; i++){
        int iMod = i % 2;
        lst.add(AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.ease,
          width: 3,
          height: iMod == modAnimation ? 30 : 20,
          decoration: BoxDecoration(
              color: iMod == modAnimation ? Colors.blue : Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(5))
          ),
        ));
        lst.add(SizedBox(
          width: 3,
        ));
      }

      return Container(
        padding: EdgeInsets.all(10),
        height: 80,
        //color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: lst,
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Color.fromRGBO(255, 255, 255, 1.0),
            width: size.width,
            height: size.height - MediaQuery.of(context).padding.top,
            child: FadeTransition(
              opacity: animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset('images/icon.png'),
                      ),
                    ),
                  ),
                  getLoading(),
                  Container(
                    child: Text("Loading..."),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
