import 'package:controlmas/controlador/InsertarVenta.dart';
import 'package:controlmas/utiles/Informacion.dart';
import 'package:controlmas/vistas/menu.dart';
import 'package:controlmas/vistas/widgets/boton.dart';
import 'package:flutter/material.dart';

class Claves extends StatefulWidget {

  @override
  _ClavesState createState() => _ClavesState();
}

class _ClavesState extends State<Claves> {
  TextEditingController  couta = new TextEditingController();
  GlobalKey<FormState> keyForm = new GlobalKey();
  String dropdown ="Ingrese la cantidad de claves";
  Menu menu = new Menu();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async => false,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text('Generar Claves',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
                    width: 600,
                    height: 400,
                    margin: new EdgeInsets.fromLTRB(0,20,0,0),
                    color:Colors.white,
                    child:formUI(),
                  ) 
                ),
              )
            )
          )
        ),
      ),
    );
  }
  formItemsDesign(icon, item) {
   return Padding(
     padding: EdgeInsets.symmetric(vertical:4),
     child: Card(child: ListTile(leading: Icon(icon), title: item)),
   );
  }
  Widget formUI() {
    return  Column(
      mainAxisAlignment:MainAxisAlignment.start,
      crossAxisAlignment:CrossAxisAlignment.start,
      children: <Widget>[
        formItemsDesign(
          Icons.lock_open_rounded,
          TextFormField(
            controller: couta,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              labelText: 'Cantidad',
            ),
            validator:(value){
              if (value.isEmpty) {
                return 'Por favor Ingrese la cantidad de claves';
              }
            },
          ),
        ),
        Boton(onPresed: _crearClaves,texto:'Aceptar',),
         
      ]
    );
  }

  _crearClaves()async{
    int clave = int.parse(couta.text);
    if(couta.text!=""){
      var session= Insertar();
      session.generarClaves(clave)
      .then((_) {
        successDialog(
          context, 
          "Se crearon las claves correctamente",
          neutralAction: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Claves())
            );
          },
        );   
      });
    }else{
      warningDialog(
        context, 
        "Por favor ingrese un valor",
        neutralAction: (){
        },
      );
    }
  }
}