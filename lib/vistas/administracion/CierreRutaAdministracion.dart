import 'package:controlmas/utiles/Globals.dart';
import 'package:controlmas/utiles/Informacion.dart';
import 'package:controlmas/vistas/home.dart';
import 'package:controlmas/vistas/widgets/boton.dart';
import 'package:controlmas/vistas/widgets/usuario.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmas/vistas/menu.dart';
import 'package:controlmas/modelos/Usuarios.dart';
import 'package:controlmas/modelos/AsignarAdmin.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:controlmas/modelos/ReporteGasto.dart';
import 'package:controlmas/modelos/ConteoDebeAdmin.dart';
import 'package:controlmas/controlador/InsertarVenta.dart';
class CerrarCajaAdministrador extends StatefulWidget {

  @override
  _CerrarCajaAdministradorState createState() => _CerrarCajaAdministradorState();
}

class _CerrarCajaAdministradorState extends State<CerrarCajaAdministrador> {
  String dia;
  String ini;
  String ffinal;
  double entrega;
  List partirDia;
  String usuario;
  double retiro=0;
  ProgressDialog pr;
  bool crear= false;
  bool mostrar= false;
  double valorEntrega;
  DateTime parseFinal;
  String fechaConsulta;
  FocusNode retiroNode;
  String selectedRegion;
  ReporteGasto _gastos;
  DateTime parseInicial;
  Menu menu = new Menu();
  List<Usuario> users=[];
  List<Usuario> _users=[];
  AsignarAdmin _asignado;
  List<ReporteGasto> gastos;
  List<AsignarAdmin> asignado;
  ConteoDebeAdmin _nuevaVenta;
  ConteoDebeAdmin _recolectado;
  ConteoDebeAdmin _porRecolectar;
  List<ConteoDebeAdmin> nuevaVenta;
  ConteoDebeAdmin _totalNuevaVenta;
  List<ConteoDebeAdmin> totalNuevaVenta;
  DateTime now = new DateTime.now();
  List<ConteoDebeAdmin> recolectado=[];
  List<ConteoDebeAdmin> porRecolectar=[];
  List<ConteoDebeAdmin> totalRecolectado=[];
  final formatSumar = DateFormat("yyyy-MM-dd");
  GlobalKey<FormState> keyForm = new GlobalKey();
  TextStyle textStyleDataCell = TextStyle(fontSize:15,);
  TextEditingController  couta = new TextEditingController();
  TextEditingController  base = new TextEditingController();
  TextEditingController  baseDia = new TextEditingController();
  
  @override
  void initState() {
    ini=formatSumar.format(now);
    ffinal=formatSumar.format(now);
    String fechaInicial=ini+' 00:00:00';
    String fechaFinal=ffinal+' 23:59:59';
    fechaConsulta = formatSumar.format(now);
    parseFinal = DateTime.parse(fechaFinal);
    parseInicial = DateTime.parse(fechaInicial);
    dia=DateFormat('EEEE, d').format(now);
    if(objetosUsuario.contains('CRA001') || objetosUsuario.contains("SA000")){
      crear = true;
    }
    super.initState();
  }
  // Future <double>porEntregar()async{
  //   double resultado =(_asignado.valor+_recolectado.valorCuotas)-(_nuevaVenta.venta+_gasto.valor);
  //   entrega=resultado;
  //   return entrega;              
  // }
  Future<List<ConteoDebeAdmin>>valoresRecolectados(usuario)async{
    var session= Insertar();
    await session.valoresRecolectadosAdmin(parseInicial.millisecondsSinceEpoch, parseFinal.millisecondsSinceEpoch,usuario).then((_){
      recolectado=session.obtenerClientesRecolectadosAdmin();
    });
    return recolectado;
  }

  Future<List<ConteoDebeAdmin>>valoresVentasNuevas(usuario)async{
    var session= Insertar();
    await session.valoresVentasHoyUsuarioAdmin(usuario).then((_){
      nuevaVenta=session.obtenervaloresVentasHoyAdmin();
    });
    return nuevaVenta;
  }

  Future<List<ReporteGasto>>gastosRutaAdmin()async{
    var session= Insertar();
    await session.gastosRutaAdmin(usuario).then((_){
      gastos=session.obtenerGastosFecha();
    });
    return gastos;
  }

  Future<List<ConteoDebeAdmin>>valoresVentasNuevasGeneral()async{
    var session= Insertar();
    await session.totalValoresVentasAdmin().then((_){
      totalNuevaVenta=session.obtenerTotalValoresVentasHoyAdmin();
    });
    return totalNuevaVenta;
  }

  Future<List<ConteoDebeAdmin>> valoresPorRecolectar(usuario)async{
    var session= Insertar();
     await session.clientesVisitarAdmin(usuario).then((_){
       porRecolectar=session.obtenerClientesVisitarAdmin();
     });
     return porRecolectar;
  }

  Future<List<AsignarAdmin>> dineroAsignado()async{
    var session= Insertar();
     await session.dineroAsignadoAdmin(usuario).then((_){
       asignado=session.obtenerBaseAdmin();
     });
     return asignado;
  }
  
  validarCierre(){
    warningDialog(
      context, 
      "Desea realizar el cierre de la ruta? El usuario seleccionado no podra seguir actualizando la información",
      negativeText: "Si",
      negativeAction: (){
        crearCierre();
      },
      neutralText: "No",
      neutralAction: (){
      },
    );
  }

  crearCierre()async{
    await pr.show();
    Insertar session= Insertar();
    session.baseSiguienteAdmin(valorEntrega,usuario).then((_){
      session.reporteDiarioAdmin(_recolectado.valorCuotas.toString(),_gastos.valor.toString(),_nuevaVenta.venta.toString(),_asignado.base,valorEntrega.toString(),valorEntrega.toString(),usuario).then((_){
        pr.hide();
        successDialog(
          context, 
          "Cuadre de caja exitoso",
          neutralAction: (){
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Home(),)); 
            });
          },
        );
      }).catchError( (onError){
        pr.hide();
        warningDialog(
          context, 
          "Error de conexión, por favor inténtelo de nuevo",
          neutralAction: (){
            
          },
        );                                     
      });
    }).catchError( (onError){
      pr.hide();
      warningDialog(
        context, 
        "Error de conexión, por favor inténtelo de nuevo",
        neutralAction: (){
          
        },
      );                                     
    });
  }

  Widget tablaGasto(){
  return FutureBuilder<List<ReporteGasto>>(
    //llamamos al método, que está en la carpeta db file database.dart
    future: gastosRutaAdmin(),
    builder: (BuildContext context, AsyncSnapshot<List<ReporteGasto>> snapshot) {
      if (snapshot.hasData) {
        _gastos = gastos[0];
        valorEntrega=(_asignado.base+_recolectado.valorCuotas)-(_nuevaVenta.venta+_gastos.valor);
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Gastos: "+_gastos.valor.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
              Text("Entrega: "+valorEntrega.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)) 
            ],
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}

 

  Widget tablaBase(){
  return FutureBuilder<List<AsignarAdmin>>(
    //llamamos al método, que está en la carpeta db file database.dart
    future: dineroAsignado(),
    builder: (BuildContext context, AsyncSnapshot<List<AsignarAdmin>> snapshot) {
      if (snapshot.hasData) {
        _asignado = asignado[0];
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  Text("Dinero asignado: "+_asignado.base.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
                  // SizedBox(width: 10),
                  // Text("Base: "+_asignado.valor.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
                
            ],
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}
  Widget tablaPorRecolectar(){
  return FutureBuilder<List<ConteoDebeAdmin>>(
    //llamamos al método, que está en la carpeta db file database.dart
    future: valoresPorRecolectar(usuario),
    builder: (BuildContext context, AsyncSnapshot<List<ConteoDebeAdmin>> snapshot) {
      if (snapshot.hasData) {
        _porRecolectar = porRecolectar[0];
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Clientes por visitar: "+_porRecolectar.documentos.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
              _porRecolectar.valorCuotas==null?Text("Total a recaudar: "+"0",style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)):Text("Total a recaudar: "+_porRecolectar.valorCuotas.toStringAsFixed(1),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
            ],
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}

 Widget tablaNuevaVenta(){
  return FutureBuilder<List<ConteoDebeAdmin>>(
    //llamamos al método, que está en la carpeta db file database.dart
    future: valoresVentasNuevas(usuario),
    builder: (BuildContext context, AsyncSnapshot<List<ConteoDebeAdmin>> snapshot) {
      if (snapshot.hasData) {
        _nuevaVenta = nuevaVenta[0];
        return Padding(
          padding:const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nuevas Ventas: "+_nuevaVenta.documentos.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
              Text("Valor : "+_nuevaVenta.venta.toString() ,style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
            ],
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}
Widget tablaNuevaVentaGeneral(){
  return FutureBuilder<List<ConteoDebeAdmin>>(
    //llamamos al método, que está en la carpeta db file database.dart
    future: valoresVentasNuevasGeneral(),
    builder: (BuildContext context, AsyncSnapshot<List<ConteoDebeAdmin>> snapshot) {
      if (snapshot.hasData) {
        _totalNuevaVenta = totalNuevaVenta[0];
        return Padding(
          padding:const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nuevas Ventas: "+_totalNuevaVenta.documentos.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
              Text("Valor : "+_totalNuevaVenta.venta.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
            ],
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}

Widget tablaRecolectado(){
  return FutureBuilder<List<ConteoDebeAdmin>>(
    //llamamos al método, que está en la carpeta db file database.dart
    future: valoresRecolectados(usuario),
    builder: (BuildContext context, AsyncSnapshot<List<ConteoDebeAdmin>> snapshot) {
      if (snapshot.hasData) {
        _recolectado = recolectado[0];
        return Padding(
          padding:const EdgeInsets.fromLTRB(8, 2,0, 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _recolectado.documentos!=null?Text("Clientes visitados: "+_recolectado.documentos.toString()+" ("+((_recolectado.documentos/_porRecolectar.documentos)*100).toStringAsFixed(1)+"%)",style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)):Text("Clientes visitados: "+_recolectado.documentos.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
              _recolectado.valorCuotas!=null?Text("Total recaudado: "+_recolectado.valorCuotas.toStringAsFixed(1)+" ("+((_recolectado.valorCuotas/_porRecolectar.valorCuotas)*100).toStringAsFixed(1)+"%)",style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)):Text("Total recaudado: "+_recolectado.valorCuotas.toStringAsFixed(1),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
            ],
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}

 @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
      message: 'Sincronizando la información',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      textAlign:TextAlign.center,
      progressTextStyle: TextStyle(
      color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
      color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    return WillPopScope(
    onWillPop: () async => false,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text('Estado Ruta',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
          ),
          drawer: menu,
          body:  new SingleChildScrollView(
            child:
            Container(
              color: Colors.white,
              child:new Center(
              //margin: new EdgeInsets.fromLTRB(100,0,100,0),
                child: new Form(
                key: keyForm,
                  child:Container( 
                    width: 700,
                    height:500,
                    alignment: Alignment.center,
                    margin: new EdgeInsets.fromLTRB(0,20,0,0),
                    color:Colors.white,
                    child:formUI(),
                  ) 
                ),
              )
            )
          ),
        ),
      ),
    );
  }

  Widget separador(){
    return 
    mostrar?Padding(
      padding: const EdgeInsets.fromLTRB(10,0,10,0),
      child: const Divider(
        height: 5,
        thickness: 2,
        //indent: 20,
        //endIndent: 20,
      ),
    ):Container();
  }

  Widget formUI() {
    return  Column(
      mainAxisAlignment:MainAxisAlignment.start,
      crossAxisAlignment:CrossAxisAlignment.center,
      children: <Widget>[
        ListarUsuario(),
        Container(height:20,),
        mostrar?
        Expanded(
          child: SizedBox(
            child:tablaPorRecolectar(),
          ),
        ):Container(),
        separador(),
        mostrar?
        Expanded(
          child: SizedBox(
            child:tablaRecolectado(),
          ),
        ):Container(),
        separador(),
        mostrar?
        Expanded(
          child: SizedBox(
            height:10,
            child:tablaNuevaVenta(),
          ),
        ):Container(),
        separador(),
        // Container(height:20,),
        // mostrar?Text('Ventas Generales',style:TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey,fontSize:20,)):Container(),
        // Container(height:10,),
        // mostrar?
        // Expanded(
        //   child: SizedBox(
        //     height:10,
        //     child:tablaNuevaVentaGeneral(),
        //   ),
        // ):Container(),   
        mostrar?
        Expanded(
          child: SizedBox(
            height:10,
            child:tablaBase(),
          ),
        ):Container(),  
        separador(), 
        mostrar?
        Expanded(
          child: SizedBox(
            height:10,
            child:tablaGasto(),
          ),
        ):Container(),
        crear?mostrar?Boton(onPresed: validarCierre,texto:'Aceptar',):Container():Container(),
      ]
    );
  }

  @override
  void dispose() {
    couta.dispose();
    base.dispose();
    baseDia.dispose();
    super.dispose();
  }
}