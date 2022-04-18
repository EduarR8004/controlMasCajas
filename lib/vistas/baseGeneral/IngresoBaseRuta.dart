import 'package:controlmas/modelos/CuadresSemana.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmas/vistas/menu.dart';
import 'package:controlmas/modelos/Usuarios.dart';
import 'package:controlmas/utiles/Informacion.dart';
import 'package:controlmas/vistas/widgets/boton.dart';
import 'package:controlmas/controlador/InsertarVenta.dart';

class IngresoBaseRutaRetiroDinero extends StatefulWidget {
  final String usuario;
  final String nombre;
  final List<CuadreSemana> cuadre;
  IngresoBaseRutaRetiroDinero({this.cuadre, this.usuario, this.nombre});
  @override
  _IngresoBaseRutaRetiroDineroState createState() => _IngresoBaseRutaRetiroDineroState();
}

class _IngresoBaseRutaRetiroDineroState extends State<IngresoBaseRutaRetiroDinero> {
  dynamic usuario;
  String newValue;
  String selectedRegion;
  List<Usuario> users=[];
  Menu menu = new Menu();
  List<Usuario>pasoParametro=[];
  String dropdown ="Ingrese el gasto";
  final format = DateFormat("yyyy-MM-dd");
  GlobalKey<FormState> keyForm = new GlobalKey();
  TextStyle estiloTitulo=TextStyle(fontWeight: FontWeight.bold,fontSize:16,);
  TextStyle estilo=TextStyle(fontSize:18,);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: null,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar:new AppBar(
            title: Text('Cuedre Base General',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
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
      crossAxisAlignment:CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height:25,),
        Row(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  Text('Nombre',style:estiloTitulo,),
                  Text(widget.nombre,style:estilo),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  Text('Usuario',style:estiloTitulo,),
                  Text(widget.usuario,style:estilo),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Dinero asignado',style:estiloTitulo,),
                  Text(widget.cuadre[0].asignado,style:estilo),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Caja ruta',style:estiloTitulo,),
                  Text(widget.cuadre[1].asignado,style:estilo),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Salidas',style:estiloTitulo,),
                  Text(widget.cuadre[0].salidas,style:estilo),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Entradas',style:estiloTitulo,),
                  Text(widget.cuadre[0].entradas,style:estilo),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height:50,),
        Boton(onPresed:_ingresarDinero,texto:'Aceptar',),
         
      ]
    );
  }

  _ingresarDinero()async{
    double valorAsignado = double.parse(widget.cuadre[0].asignado);
    double cajaRuta = double.parse(widget.cuadre[1].asignado);
    double salida=double.parse(widget.cuadre[0].salidas);
    double entrada=double.parse(widget.cuadre[0].entradas);
    String usuario=widget.usuario;
    if(valorAsignado > 0){
      if(valorAsignado==cajaRuta ){
        var session= Insertar();
        session.crearCuadreSemanal(usuario,entrada,salida)
        .then((_) {
          successDialog(
            context, 
            "Entrada exitosa",
            neutralAction: (){
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (context) => IngresoBaseRutaRetiroDinero(widget.editar))
              // );
            },
          );   
        });
      }else{
        warningDialog(
          context, 
          "Por favor revisar los valores del cuadre semanal",
          neutralAction: (){
          },
        );
      }
    }
  }
}