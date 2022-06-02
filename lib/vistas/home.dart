import 'package:controlmas/vistas/portada.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:controlmas/vistas/menu.dart';
import 'package:controlmas/vistas/ventas.dart';
import 'package:controlmas/utiles/Globals.dart';
import 'package:controlmas/vistas/ventas/ruta.dart';
import 'package:controlmas/vistas/login/login.dart';
import 'package:controlmas/utiles/Informacion.dart';
import 'package:controlmas/controlador/InsertarVenta.dart';
import 'package:controlmas/vistas/agenda/listarAgenda.dart';
import 'package:controlmas/vistas/gastos/ListarGastos.dart';
import 'package:controlmas/vistas/historial/Historial.dart';
import 'package:controlmas/vistas/cerrarCaja/CerrarCaja.dart';

class Home extends StatefulWidget {
  final List objetos;
  Home({this.objetos});
  //const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> objMenu=[];
   @override
  void initState() {
    super.initState();
    // if(Platform.isAndroid){
    //   _asignarDineroInicial();
    // }
  }
  Future <List<String>>objetosMenu()async{
    objMenu=objetosUsuario;
    return objMenu;              
  }
  // _asignarDineroInicial()async{
  //   var session= Insertar();
  //   session.asignarDineroInicial()
  //   .then((_) {
  //   });
  // }
  void showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    // final message = hasInternet
    //     ? 'You have again ${result.toString()}'
    //     : 'You have no internet';
    //final color = hasInternet ? Colors.green : Colors.red;
    if(hasInternet){
      _actualizar();
    }
    
    //Utils.showTopSnackBar(context, message, color);
  }
    _actualizar(){  
    var session= Insertar();
    session.enviarClientes(actualizar: false).then((_){
      session.actualizarVentas().then((_){
        session.enviarHistorial().then((_){
          session.enviarGastos().then((_){
          });
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var menu = new Menu();
    return WillPopScope(
      onWillPop: () async => false,
      child:SafeArea(
        top: false,
        key: _scaffoldKey,
        child: Scaffold(
          appBar: new AppBar(
            flexibleSpace: Container(
            //height: 60,
            //width: 700,
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:<Widget>[
                  Text("ControlMax",style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold
                  )),
                  Padding(
                  padding: EdgeInsets.fromLTRB(0,15,2,0),
                    child:Container(
                      width:250,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:<Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.exit_to_app_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () { 
                            },
                          ),
                          InkWell(
                            onTap: () {
                              if(Platform.isAndroid){
                                var session= Insertar();
                                session.copiaVentas().then((_) {
                                  session.copiaCliente().then((_) {
                                    session.copiaGasto().then((_) {
                                      session.copiaHistorialMovimiento().then((_) {
                                        session.borrarTablas().then((_) {
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                          Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Portada(editar: false,),));});
                                        });
                                      });
                                    });
                                  });
                                });
                              }else{
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Login(true),));}
                                );
                              }
                            },
                            child:Text("Cerrar Sesión",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //backgroundColor: Colors.transparent,
          ),
          drawer: menu,
          body:Container(
            color: Colors.white,
            child:body()
            //dataBody(),
          )
        ),
      ),
    );
  }

  body(){
    return FutureBuilder <List<String>>(
      future:objetosMenu(),
      builder:(context,snapshot){
        if(snapshot.hasData){
        return  
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
              child:Center(
                child: Container(
                  width: 600,
                  height: 630,
                  color:Colors.white,
                  child:Column(
                    children: [
                      SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Control",style: TextStyle(
                          color: Color.fromRGBO(83, 86, 90, 1.0),
                          fontSize: 40,
                          fontWeight: FontWeight.bold
                          )),
                          Icon(Icons.add_circle, size:60,color:Colors.blueGrey),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 120,
                        width: 180,
                        child: Icon(Icons.bar_chart_sharp, size:120,color:Colors.blueGrey),
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.symmetric(horizontal:10),                             
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          objMenu.contains("AD001") || objMenu.contains("SA000")?
                          miCardAsignarDinero():Container(),
                          objMenu.contains("VCVN001") || objMenu.contains("SA000")?
                          miCardVenta():Container(),
                          objMenu.contains("VRC001") || objMenu.contains("SA000")?
                          miCardRuta():Container(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          objMenu.contains("HU001") || objMenu.contains("SA000")?
                          miCardHistorial():Container(),
                          objMenu.contains("VRC001") || objMenu.contains("SA000")?
                          miCardGastos():Container(),
                          objMenu.contains("VRC001") || objMenu.contains("SA000")?
                          miCardCerrarCaja():Container(),
                      ],
                      )
                    ],
                  )
                )
              ),
          );
        }else{
          return
          Center(
            child:CircularProgressIndicator()
            //Splash1(),
          );
        }
      },
    );
  }

  onPressedVenta(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NuevaVentaView(false,false,false))
    );
  }
  onPressedRuta(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RecoleccionView(boton: true,))
    );
  }
  onPressedCierreCaja(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CerrarCaja())
    );
  }
  onPressedGastos(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => DataTableGastos())
    );
  }
  onPressedListarAgenda(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ListarAgenda())
    );
  }
  onPressedHistorial(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Historial())
    );
  }
  
  Card miCardVenta() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(8),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: <Widget>[ 
            InkWell(
              onTap: ()async{
                if(Platform.isAndroid){
                  onPressedVenta();
                  final result = await Connectivity().checkConnectivity();
                  showConnectivitySnackBar(result);
                }else{
                  warningDialog(
                    context, 
                    "Esta funcionalidad solo esta desponible en su teléfono móvil",
                    neutralAction: (){
                      
                    },
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child:Icon(Icons.person_add_alt_1  , size:80,color:Colors.blueGrey),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text('Ventas'),
            ),
          ],
        ),
      )
    );
  }
  Card miCardRuta() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(8),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: ()async{
                if(Platform.isAndroid){
                  onPressedRuta();
                  final result = await Connectivity().checkConnectivity();
                  showConnectivitySnackBar(result);
                }else{
                  warningDialog(
                    context, 
                    "Esta funcionalidad solo esta desponible en su teléfono móvil",
                    neutralAction: (){
                      
                    },
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.two_wheeler_rounded  , size:80,color:Colors.blueGrey),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text('Ruta'),
            ),
          ],
        ),
      )
    );
  }
  Card miCardHistorial() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(8),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                if(Platform.isAndroid){
                  onPressedHistorial();
                }else{
                  warningDialog(
                    context, 
                    "Esta funcionalidad solo esta desponible en su teléfono móvil",
                    neutralAction: (){
                      
                    },
                  );
                }
              },
              child:
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.auto_stories  , size:80,color:Colors.blueGrey),
              ),
            ),
            // Usamos Container para el contenedor de la descripción
            Container(
              padding: EdgeInsets.all(10),
              child: Text('Historial'),
            ),
          ],
        ),
      )
    );
  }

  Card  miCardAsignarDinero() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(8),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                if(Platform.isAndroid){
                  onPressedListarAgenda();
                }else{
                  warningDialog(
                    context, 
                    "Esta funcionalidad solo esta desponible en su teléfono móvil",
                    neutralAction: (){
                      
                    },
                  );
                }
              },
              child: 
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.point_of_sale   , size:80,color:Colors.blueGrey),
              ),
            ),
            // Usamos Container para el contenedor de la descripción
            Container(
              padding: EdgeInsets.all(5),
              child: Text('Agenda'),
            ),
          ],
        ),
      )
    );
  }

  Card miCardCerrarCaja() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(8),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                if(Platform.isAndroid){
                  onPressedCierreCaja();
                }else{
                  warningDialog(
                    context, 
                    "Esta funcionalidad solo esta desponible en su teléfono móvil",
                    neutralAction: (){
                      
                    },
                  );
                }
              },
              child: 
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.bar_chart_sharp,size:80,color:Colors.blueGrey),
              ),
            ),
            // Usamos Container para el contenedor de la descripción
            Container(
              padding: EdgeInsets.all(5),
              child: Text('Cerrar'),
            ),
            // Container(
            //   padding: EdgeInsets.all(5),
            //   child: Text('Caja'),
            // ),
          ],
        ),
      )
    );
  }

  Card miCardGastos() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(8),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                if(Platform.isAndroid){
                  onPressedGastos();
                }else{
                  warningDialog(
                    context, 
                    "Esta funcionalidad solo esta desponible en su teléfono móvil",
                    neutralAction: (){
                      
                    },
                  );
                }
              },
              child: 
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.money_off,size:80,color:Colors.blueGrey),
              ),
            ),
            // Usamos Container para el contenedor de la descripción
            Container(
              padding: EdgeInsets.all(5),
              child: Text('Gastos'),
            ),
            // Container(
            //   padding: EdgeInsets.all(5),
            //   child: Text('Caja'),
            // ),
          ],
        ),
      )
    );
  }
}