// import 'dart:async';
// //import 'package:controlmas/vistas/baseGeneral/FechasBase.dart';
// import 'package:controlmas/vistas/baseGeneral/FechasBase.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:controlmas/vistas/menu.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:controlmas/modelos/Usuarios.dart';
// import 'package:controlmas/utiles/Informacion.dart';
// import 'package:controlmas/modelos/ListarCaja.dart';
// import 'package:controlmas/vistas/widgets/boton.dart';
// import 'package:controlmas/controlador/InsertarVenta.dart';

// class ConsultarBasegeneral extends StatefulWidget {
//   final String fechaInicial;
//   final String fechaFinal;
//   final String usuario;
  
//   ConsultarBasegeneral({Key key,this.fechaFinal,this.fechaInicial, this.usuario}) : super();
 
//   final String title = "Gestión de Usuarios";
 
//   @override
//   ConsultarBasegeneralState createState() => ConsultarBasegeneralState();
// }
 
// class ConsultarBasegeneralState extends State<ConsultarBasegeneral> {
//   bool sort;
//   bool validar;
//   Usuario consulta;
//   bool borrar=false;
//   String mensaje,texto;
//   bool refrescar = false;
//   List<Widget> lista =[];
//   List<ListarCaja> users=[];
//   List<ListarCaja> total=[];
//   List<ListarCaja> selectedUsers;
//   String dropdownValue = 'Opciones';
//   final format = DateFormat("dd/MM/yyyy");
//   String eliminarUsuario='Usuario Eliminado Correctamente';
  
  
//   Future <List<ListarCaja>> listarProduccion()async{
//     var usuario= Insertar();
//     if(selectedUsers.length > 0){
//         return users;
//     }else if(borrar==true)
//     {
//       return users;
//     }else if(users.length > 0)
//     {
//       return users;
//     }
//     else
//     { 
//       if(widget.usuario==null){
//         await usuario.listarCaja(widget.fechaInicial,widget.fechaFinal).then((_){
//           var preUsuarios=usuario.obtnerListarCaja();
//           for ( var usuario in preUsuarios)
//           {
//             users.add(usuario);
//           }        
//         });
//       }else{
//         await usuario.listarCajaUsuario(widget.fechaInicial,widget.fechaFinal,widget.usuario).then((_){
//           var preUsuarios=usuario.obtnerListarCaja();
//           for ( var usuario in preUsuarios)
//           {
//             users.add(usuario);
//           }        
//         });
//       }
//       return users;
//     }
//   }

//   Future <List<ListarCaja>> listarTotalProduccion()async{
//     var usuario= Insertar();
//     if(total.length > 0)
//     {
//       return total;
//     }
//     else
//     {
//       await usuario.listarTotalCaja(widget.fechaInicial,widget.fechaFinal,widget.usuario).then((_){
//         var preUsuarios=usuario.obtnerTotalCaja();
//         for ( var usuario in preUsuarios)
//         {
//           total.add(usuario);
//         }        
//       });
//       return total;
//     }
//   }

  
    
//   @override
//   void initState() {
//     sort = false;
//     //widget.data;
//     selectedUsers = [];
//     //_controller.text=widget.data.parametro;
//     //users =widget.data.usuarios ;
//     //listarUsuario();
//     super.initState();
//   }

//   void borrarTabla(){
//     setState(() {
//       users=[]; 
//     });
//   }
  
//   onSortColum(int columnIndex, bool ascending) {
//     if (columnIndex == 0) {
//       if (ascending) {
//         users.sort((a, b) => a.usuario.compareTo(b.usuario));
//       } else {
//         users.sort((a, b) => b.usuario.compareTo(a.usuario));
//       }
//     }
//   }
 
//   onSelectedRow(bool selected, ListarCaja user) async {
//     setState(() {
//       if (selected) {
//         selectedUsers.add(user);
//       } else {
//         selectedUsers.remove(user);
//       }
//     });
//   }
//   deleteSelected() async {
//     setState(() {
//       if (selectedUsers.isNotEmpty) {
//         List<ListarCaja> temp = [];
//         temp.addAll(selectedUsers);
//         for (ListarCaja user in temp) {
//           //eliminar();
//           users.remove(user);
//           selectedUsers.remove(user);  
//        }
//         successDialog(
//           context, 
//           'Usuario Eliminado Correctamente',
//           neutralText: "Aceptar",
//           neutralAction: (){
//           },
//         );
//       }else
//       {
//         warningDialog(
//           context, 
//           'Por favor seleccione un usuario',
//             negativeAction: (){
//           },
//         );
//       }
//     });
//   }
 
//   Widget  dataBody(texto) {
//     return FutureBuilder <List<ListarCaja>>(
//       future:listarProduccion(),
//       builder:(context,snapshot){
//         if(snapshot.hasData){
//           var textStyleDataCell = TextStyle(fontSize:15,);
//           return SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: SingleChildScrollView( 
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 headingRowColor:
//                 MaterialStateColor.resolveWith((states) =>Colors.blueGrey, ),
//                 //Color.fromRGBO(136,139, 141, 1.0)
//                 sortAscending: sort,
//                 sortColumnIndex: 0,
//                 horizontalMargin:10,
//                 columnSpacing:10,
//                 columns: [
//                   DataColumn(
//                     label: Text("Fecha",style: TextStyle(
//                       color:Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize:15,
//                     )),
//                     numeric: false,
//                     tooltip: "Fecha",
//                     // onSort: (columnIndex, ascending) {
//                     //   setState(() {
//                     //     sort = !sort;
//                     //   });
//                     //   onSortColum(columnIndex, ascending);
//                     // }
//                   ),
//                   DataColumn(
//                     label: Text("Supervisor",style: TextStyle(
//                       color:Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize:15,
//                     )),
//                     numeric: false,
//                     tooltip: "Supervisor",
//                   ),
//                   DataColumn(
//                     label: Text("Ingreso",style: TextStyle(
//                       color:Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize:15,
//                     )),
//                     numeric: false,
//                     tooltip: "Ingreso",
//                   ),
//                   DataColumn(
//                     label: Text("Retiro",style: TextStyle(
//                       color:Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize:15,
//                     )),
//                     numeric: false,
//                     tooltip: "Retiro",
//                   ),
//                   DataColumn(
//                     label: Text("Base",style: TextStyle(
//                       color:Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize:15,
//                     )),
//                     numeric: false,
//                     tooltip: "Base",
//                   ),
//                   DataColumn(
//                     label: Text("Entrega",style: TextStyle(
//                       color:Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize:15,
//                     )),
//                     numeric: false,
//                     tooltip: "Entrega",
//                   ),
//                   DataColumn(
//                     label: Text("Ruta",style: TextStyle(
//                       color:Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize:15,
//                     )),
//                     numeric: false,
//                     tooltip: "Ruta",
//                   ),
//                 ],
//                 rows: users.map(
//                   (user) => DataRow(
//                     //selected: selectedUsers.contains(user),
//                     // onSelectChanged: (b) {
//                     //   print("Onselect");
//                     //   onSelectedRow(b, user);
//                     // },
//                     cells: [
//                       DataCell(
//                         Text(user.fecha,style: textStyleDataCell),
//                       ),
//                       DataCell(
//                         Text( user.administrador.toString(),style: textStyleDataCell),
//                       ),
//                       DataCell(
//                         Text(user.ingreso.toString(),style: textStyleDataCell),
//                       ),
//                       DataCell(
//                         Text( user.retiro.toString(),style: textStyleDataCell),
//                       ),
//                       DataCell(
//                         Text(user.salida.toString(),style: textStyleDataCell)),
//                       DataCell(
//                         Text( user.entrada.toString(),style: textStyleDataCell),
//                       ),
//                       DataCell(
//                         Text( user.ruta.toString(),style: textStyleDataCell),
//                       ),
//                     ]
//                   ),
//                 ).toList(),
//               ),
//             ),
//           );
//         }else{
//           return
//           Center(
//             child:CircularProgressIndicator()
//             //Splash1(),
//           );
//         }
//       },
//     );
//   }
//   Widget  dataTotal(texto) {
//     return FutureBuilder <List<ListarCaja>>(
//       future:listarTotalProduccion(),
//       builder:(context,snapshot){
//         if(snapshot.hasData){
//           var textStyleDataCell = TextStyle(fontSize:15,);
//           return SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: SingleChildScrollView( 
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 headingRowColor:
//                 MaterialStateColor.resolveWith((states) =>Colors.blueGrey, ),
//                 //Color.fromRGBO(136,139, 141, 1.0)
//                 sortAscending: sort,
//                 sortColumnIndex: 0,
//                 horizontalMargin:10,
//                 columnSpacing:10,
//                 columns: [
//                   DataColumn(
//                     label: Text("Ingreso",style: TextStyle(
//                       color:Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize:15,
//                     )),
//                     numeric: false,
//                     tooltip: "Ingreso",
//                   ),
//                   DataColumn(
//                     label: Text("Retiro",style: TextStyle(
//                       color:Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize:15,
//                     )),
//                     numeric: false,
//                     tooltip: "Retiro",
//                   ),
//                   DataColumn(
//                     label: Text("Base",style: TextStyle(
//                       color:Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize:15,
//                     )),
//                     numeric: false,
//                     tooltip: "Base",
//                   ),
//                   DataColumn(
//                     label: Text("Entrega",style: TextStyle(
//                       color:Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize:15,
//                     )),
//                     numeric: false,
//                     tooltip: "Entrega",
//                   ),
//                   DataColumn(
//                     label: Text("Saldo",style: TextStyle(
//                       color:Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize:15,
//                     )),
//                     numeric: false,
//                     tooltip: "Saldo",
//                   ),
//                 ],
//                 rows: total.map(
//                   (user) => DataRow(
//                     //selected: selectedUsers.contains(user),
//                     // onSelectChanged: (b) {
//                     //   print("Onselect");
//                     //   onSelectedRow(b, user);
//                     // },
//                     cells: [
//                       DataCell(
//                         Text(user.ingreso.toStringAsFixed(1),style: textStyleDataCell),
//                       ),
//                       DataCell(
//                         Text( user.retiro.toStringAsFixed(1),style: textStyleDataCell),
//                       ),
//                       DataCell(
//                         Text(user.salida.toStringAsFixed(1),style: textStyleDataCell)),
//                       DataCell(
//                         Text( user.entrada.toStringAsFixed(1),style: textStyleDataCell),
//                       ),
//                       DataCell(
//                         Text( ((user.ingreso+user.entrada)-(user.retiro+user.salida)).toStringAsFixed(1),style: textStyleDataCell),
//                       ),
//                     ]
//                   ),
//                 ).toList(),
//               ),
//             ),
//           );
//         }else{
//           return
//           Center(
//             child:CircularProgressIndicator()
//             //Splash1(),
//           );
//         }
//       },
//     );
//   }
//   void confirm (dialog){
//     Alert(
//       context: context,
//       type: AlertType.error,
//       title: "Faltan Permisos",
//       desc: dialog,
//       buttons: [
//         DialogButton(
//           child: Text(
//             "Aceptar",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           width: 120,
//         )
//       ],
//     ).show();
//   }
//   _onPressedBuscar(){
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => FechasBase(),)); 
//     });
//   }
//   @override
//   Widget build(BuildContext context) {  
//     var menu = new Menu();
//     return WillPopScope(
//     onWillPop: () async => false,
//       child: SafeArea(
//         top: false,
//         child:Scaffold(
//           appBar:new AppBar(
//             title: Text("Caja Total",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
//             //flexibleSpace:encabezado,
//             //backgroundColor:Colors.blue
//             // Colors.transparent,
//           ),
//           drawer: menu,
//           body: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           verticalDirection: VerticalDirection.down,
//             children: <Widget>[
//               Container(
//                 color:Colors.white,
//                 child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Padding(
//                       padding: EdgeInsets.all(10.0),
//                       child:Container(
//                         decoration: BoxDecoration(
//                           //color: Colors.white,
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child:Boton(onPresed: _onPressedBuscar,texto:'Nuevas fechas',size: 15,), 
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child:dataBody(texto),
//               ),
//               Container(
//                 child:Text("Totales",style: TextStyle(
//                   color:Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize:20,
//                 )), 
//               ),
//               Container(
//                 //child:Expanded(
//                   child:
//                   dataTotal(texto),
//                 //), 
//               )
//             ],
//           ),
//         ),
//       ), 
//     );
//   }
  
// }

// class UsuarioEnvio {
//   String token;
//   UsuarioEnvio({this.token});
// }
