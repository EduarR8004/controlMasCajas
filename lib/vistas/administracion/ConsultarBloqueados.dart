import 'dart:async';
import 'package:controlmas/modelos/TotalBloquedos.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmas/vistas/menu.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:controlmas/modelos/Usuarios.dart';
import 'package:controlmas/utiles/Informacion.dart';
import 'package:controlmas/vistas/widgets/boton.dart';
import 'package:controlmas/modelos/ReporteDiario.dart';
import 'package:controlmas/modelos/ClienteBloqueado.dart';
import 'package:controlmas/controlador/InsertarVenta.dart';
import 'package:controlmas/vistas/administracion/ConsultarFechaBloqueados.dart';

class ConsultarBloqueados extends StatefulWidget {
  final String parametro;
  final String fechaInicial;
  final String fechaFinal;
  
  ConsultarBloqueados({Key key,this.parametro,this.fechaFinal,this.fechaInicial}) : super();
 
  final String title = "Consultar Bloqueados";
 
  @override
  ConsultarBloqueadosState createState() => ConsultarBloqueadosState();
}
 
class ConsultarBloqueadosState extends State<ConsultarBloqueados> {
  bool sort;
  bool validar;
  Usuario consulta;
  bool borrar=false;
  String mensaje,texto;
  bool refrescar = false;
  List<Widget> lista =[];
  List<ClienteBloqueado> users=[];
  List<TotalBloqueados> total=[];
  List<ReporteDiario> selectedUsers;
  String dropdownValue = 'Opciones';
  final format = DateFormat("dd/MM/yyyy");
  String eliminarUsuario='Usuario Eliminado Correctamente';
  
  
  Future <List<ClienteBloqueado>> listarProduccion()async{
    var usuario= Insertar();
    if(selectedUsers.length > 0){
        return users;
    }else if(borrar==true)
    {
      return users;
    }else if(users.length > 0)
    {
      return users;
    }
    else
    {
      print(widget.fechaInicial);
      print(widget.fechaFinal);
      await usuario.descargarBloqueados(widget.fechaInicial,widget.fechaFinal,widget.parametro).then((_){
        var preUsuarios=usuario.obtenerClientesBloqueados();
        for ( var usuario in preUsuarios)
        {
          users.add(usuario);
        }        
      });
      return users;
    }
  }

  Future <List<TotalBloqueados>> listarTotalProduccion()async{
    var usuario= Insertar();
    if(total.length > 0)
    {
      return total;
    }
    else
    {
      await usuario.descargarTotalBloqueados(widget.fechaInicial,widget.fechaFinal,widget.parametro).then((_){
        var preUsuarios=usuario.obtenerTotalBloqueados();
        for ( var usuario in preUsuarios)
        {
          total.add(usuario);
        }        
      });
      return total;
    }
  }
    
  @override
  void initState() {
    sort = false;
    selectedUsers = [];
    super.initState();
  }

  void borrarTabla(){
    setState(() {
      users=[]; 
    });
  }
  
  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        users.sort((a, b) => a.usuario.compareTo(b.usuario));
      } else {
        users.sort((a, b) => b.usuario.compareTo(a.usuario));
      }
    }
  }
 
  onSelectedRow(bool selected, ReporteDiario user) async {
    setState(() {
      if (selected) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    });
  }
  deleteSelected() async {
    setState(() {
      if (selectedUsers.isNotEmpty) {
        List<ReporteDiario> temp = [];
        temp.addAll(selectedUsers);
        for (ReporteDiario user in temp) {
          //eliminar();
          users.remove(user);
          selectedUsers.remove(user);  
       }
        successDialog(
          context, 
          'Usuario Eliminado Correctamente',
          neutralText: "Aceptar",
          neutralAction: (){
          },
        );
      }else
      {
        warningDialog(
          context, 
          'Por favor seleccione un usuario',
            negativeAction: (){
          },
        );
      }
    });
  }
 
  Widget  dataBody(texto) {
    return FutureBuilder <List<ClienteBloqueado>>(
      future:listarProduccion(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          var textStyleDataCell = TextStyle(fontSize:15,);
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView( 
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                MaterialStateColor.resolveWith((states) =>Colors.blueGrey, ),
                sortAscending: sort,
                sortColumnIndex: 0,
                horizontalMargin:10,
                columnSpacing:10,
                columns: [
                  DataColumn(
                    label: Text("Nombre",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Nombre",
                    // onSort: (columnIndex, ascending) {
                    //   setState(() {
                    //     sort = !sort;
                    //   });
                    //   onSortColum(columnIndex, ascending);
                    // }
                  ),
                  DataColumn(
                    label: Text("Fecha",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Fecha",
                    // onSort: (columnIndex, ascending) {
                    //   setState(() {
                    //     sort = !sort;
                    //   });
                    //   onSortColum(columnIndex, ascending);
                    // }
                  ),
                  DataColumn(
                    label: Text("Venta",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Venta",
                  ),
                  DataColumn(
                    label: Text("N.cuotas",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "N.cuotas",
                  ),
                  DataColumn(
                    label: Text("Saldo",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Saldo",
                  ),
                  DataColumn(
                    label: Text("Ult.Cuota",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Ult.Cuota",
                  ),
                  DataColumn(
                    label: Text("Ciudad",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Ciudad",
                  ),
                  DataColumn(
                    label: Text("Colaborador",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Colaborador",
                  ),
                ],
                rows: users.map(
                  (user) => DataRow(
                    //selected: selectedUsers.contains(user),
                    // onSelectChanged: (b) {
                    //   print("Onselect");
                    //   onSelectedRow(b, user);
                    // },
                    cells: [
                      DataCell(
                        Text(user.nombre+' '+user.primerApellido,style: textStyleDataCell),
                        onTap: () {
                        },
                      ),
                      DataCell(
                        Text(user.fecha,style: textStyleDataCell),
                      ),
                      DataCell(
                        Text( user.solicitado.toString(),style: textStyleDataCell),
                      ),
                      DataCell(
                        Text( user.numeroCuota.toString(),style: textStyleDataCell),
                      ),
                      DataCell(
                        Text( user.saldo.toString(),style: textStyleDataCell),
                      ),
                      DataCell(
                        Text( user.cuotasTemporal.toString(),style: textStyleDataCell),
                      ),
                      DataCell(
                        Text(user.ciudad.toString(),style: textStyleDataCell)),
                      DataCell(
                        Text(user.nombreUsuario.toString(),style: textStyleDataCell),
                      ),
                    ]
                  ),
                ).toList(),
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

  Widget  dataTotal(texto) {
    return FutureBuilder <List<TotalBloqueados>>(
      future:listarTotalProduccion(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          var textStyleDataCell = TextStyle(fontSize:15,);
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView( 
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                MaterialStateColor.resolveWith((states) =>Colors.blueGrey, ),
                //Color.fromRGBO(136,139, 141, 1.0)
                sortAscending: sort,
                sortColumnIndex: 0,
                horizontalMargin:10,
                columnSpacing:10,
                columns: [
                  DataColumn(
                    label: Text("Venta",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Venta",
                  ),
                  DataColumn(
                    label: Text("Solicitado",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Solicitado",
                  ),
                  DataColumn(
                    label: Text("Saldo",style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:15,
                    )),
                    numeric: false,
                    tooltip: "Saldo",
                  ),
                ],
                rows: total.map(
                  (user) => DataRow(
                    cells: [
                      DataCell(
                        Text( user.venta.toString(),style: textStyleDataCell),
                      ),
                      DataCell(
                        Text(user.solicitado.toString(),style: textStyleDataCell)),
                      DataCell(
                        Text(user.saldo.toString(),style: textStyleDataCell),
                      ),
                     
                    ]
                  ),
                ).toList(),
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

  void confirm (dialog){
    Alert(
      context: context,
      type: AlertType.error,
      title: "Faltan Permisos",
      desc: dialog,
      buttons: [
        DialogButton(
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }
  _onPressedBuscar(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => ConsultarFechaBloqueados(),)); 
    });
  }
  @override
  Widget build(BuildContext context) {  
    var menu = new Menu();
    return WillPopScope(
    onWillPop: () async => false,
      child: SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text("Bloqueados",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
            //flexibleSpace:encabezado,
            //backgroundColor:Colors.blue
            // Colors.transparent,
          ),
          drawer: menu,
          body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Container(
                color:Colors.white,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child:Container(
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child:Boton(onPresed: _onPressedBuscar,texto:'Nuevas fechas',size: 15,), 
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:dataBody(texto),
              ),
              Container(
                child:Text("Totales",style: TextStyle(
                  color:Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize:20,
                )), 
              ),
              Container(
                //child:Expanded(
                  child:
                  dataTotal(texto),
                //), 
              )
            ],
          ),
        ),
      ), 
    );
  }
  
}

class UsuarioEnvio {
  String token;
  UsuarioEnvio({this.token});
}
