import 'dart:io';
import 'package:controlmas/vistas/portada.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:controlmas/vistas/login/login.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



void main() async  {
   WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
   HttpOverrides.global = new MyHttpOverrides ();
  runApp(MyApp());
}
class CambiarTema extends InheritedWidget{

  const CambiarTema({Widget child,this.onTap,Key key}):super(child: child,key: key);
  final VoidCallback onTap;
  static CambiarTema of(BuildContext context)=>context.findAncestorWidgetOfExactType<CambiarTema>();
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget)=> false;

}
class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool cambiarColor = true;
  @override
  Widget build(BuildContext context) => OverlaySupport(
    child: CambiarTema(
      onTap: (){  
        setState(() {
          cambiarColor=!cambiarColor;
        });
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Control Más',
        theme: cambiarColor?ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryColor: Colors.blueGrey,
          accentColor: Colors.blueGrey,
          // appBarTheme:AppBarTheme(
          //   brightness: Brightness.dark,
          // )
        ):ThemeData(
          primarySwatch:Colors.red,
          primaryColor: Colors.red,
          accentColor: Colors.red,
          // appBarTheme:AppBarTheme(
          //   brightness: Brightness.dark,
          // )
        ),
        home:portada(),
        //Login(false),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en','US'), // English
          const Locale('es','CO'), // Spanish
         // const Locale('fr'), // French
         // const Locale('zh'), // Chinese
        ],
      ),
    ),
  );

  Widget portada(){
    if(Platform.isAndroid){
      return Portada(editar: false,);
    }else{  
      return Login(false);
    }
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
  return super.createHttpClient(context)
  ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

