import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmas/vistas/menu.dart';
import 'package:controlmas/modelos/Gasto.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:controlmas/modelos/Asignar.dart';
import 'package:controlmas/modelos/Usuarios.dart';
import 'package:controlmas/modelos/ConteoDebeAdmin.dart';
import 'package:controlmas/controlador/InsertarVenta.dart';
class ReporteCajaAdministrador extends StatefulWidget {

  @override
  _ReporteCajaAdministradorState createState() => _ReporteCajaAdministradorState();
}

class _ReporteCajaAdministradorState extends State<ReporteCajaAdministrador> {
  String dia;
  String ini;
  String ffinal;
  double entrega;
  List partirDia;
  String usuario;
  double retiro=0;
  ProgressDialog pr;
  List<Gasto> gastos;
  bool mostrar= false;
  String fechaConsulta;
  FocusNode retiroNode;
  String selectedRegion;
  Menu menu = new Menu();
  List<Usuario> users=[];
  List<Usuario> _users=[];
  DateTime parseFinal;
  DateTime parseInicial;
  List<Asignar> asignado=[];
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

  Future<List<ConteoDebeAdmin>>valoresVentasNuevasGeneral()async{
    var session= Insertar();
    await session.totalValoresVentasAdmin().then((_){
      totalNuevaVenta=session.obtenerTotalValoresVentasHoyAdmin();
    });
    return totalNuevaVenta;
  }

  // Future<List<Gasto>>gastosDia()async{
  //   var session= Insertar();
  //   await session.consultarGasto().then((_){
  //     gastos=session.obtenerGastos();
  //   });
  //   return gastos;
  // }

  Future<List<ConteoDebeAdmin>> valoresPorRecolectar(usuario)async{
    var session= Insertar();
     await session.clientesVisitarAdmin(usuario).then((_){
       porRecolectar=session.obtenerClientesVisitarAdmin();
     });
     return porRecolectar;
  }

  // Future<List<ConteoDebe>> nuevasVentas()async{
  //   var session= Insertar();
  //    await session.ventasNuevas().then((_){
  //      nuevaVenta=session.obtenerNuevasVentas();
  //    });
  //    return nuevaVenta;
  // }

  Future <List<Usuario>> listarUsuario()async{
    var usuario= Insertar();
    if(users.length > 0)
    {
      return users;
    }
    else
    {
      await usuario.descargarUsuarios().then((_){
        var preUsuarios=usuario.obtenerUsuarios();
        for ( var usuario in preUsuarios)
        {
          users.add(usuario);
        }        
      });
      return users;
    }
  }

  Widget dataBody() {
    return FutureBuilder<List<Usuario>>(
      future:listarUsuario(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          _users = (users).toList();
          return  Container(
            height: 50,
            width: 300,
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(10, 5, 10,10),
            decoration: BoxDecoration(
              border: Border(bottom:BorderSide(width: 1,
                color: Color.fromRGBO(83, 86, 90, 1.0),
              ),),
            ),
            child: DropdownButtonHideUnderline(
              child: new DropdownButton<String>(
                hint:Text('Seleccione un usuario', textAlign: TextAlign.center,style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Karla',
                  ),), 
                // Padding(
                //   padding: EdgeInsets.fromLTRB(5, 2, 5,2),
                //   //child: Center(
                //       child:Text('Seleccione un usuario', textAlign: TextAlign.center,style: TextStyle(
                //   fontSize: 15.0,
                //   fontFamily: 'Karla',
                //   ),),
                // ),
                //),
                value:selectedRegion,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    selectedRegion = newValue;
                    if(newValue !='Seleccione un usuario'){
                      usuario=selectedRegion;
                      mostrar=true;
                    }
                  });
                },
                items: _users.map((Usuario map) {
                  return new DropdownMenuItem<String>(
                    value: map.usuario,
                    //child: Center(
                    child:
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0,2),
                      child:
                      new Text(map.nombreCompleto,textAlign: TextAlign.center,
                        style: new TextStyle(color: Colors.black)
                      ),
                    ),
                  //),
                  );
                }).toList(),
              ),
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

  // Widget tablaEntrega(){
  //   return FutureBuilder<double>(
  //     //llamamos al método, que está en la carpeta db file database.dart
  //     future: porEntregar(),
  //     builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
  //       if (snapshot.hasData) {
  //         return Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text("Entrega: "+entrega.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
  //             ],
  //           ),
  //         );
  //       }else {
  //         return Center(child: CircularProgressIndicator());
  //       }
  //     },
  //   );
  // }

//   Widget tablaBase(){
//   return FutureBuilder<List<ConteoDebe>>(
//     //llamamos al método, que está en la carpeta db file database.dart
//     future: valoresPorRecolectar(),
//     builder: (BuildContext context, AsyncSnapshot<List<ConteoDebe>> snapshot) {
//       if (snapshot.hasData) {
//         _porRecolectar = porRecolectar[0];
//         return Padding(
//           padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text("Base Ini: "+baseInicial.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,color: Colors.green)),
//                   SizedBox(width: 10),
//                   Text("Base Act: "+_asignado.valor.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }else {
//         return Center(child: CircularProgressIndicator());
//       }
//     },
//   );
// }
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
              Text("Valor : "+_nuevaVenta.venta.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,)),
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
                    height:400,
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
        dataBody(),
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
        Container(height:20,),
        mostrar?Text('Ventas Generales',style:TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey,fontSize:20,)):Container(),
        Container(height:10,),
        mostrar?
        Expanded(
          child: SizedBox(
            height:10,
            child:tablaNuevaVentaGeneral(),
          ),
        ):Container(),        
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