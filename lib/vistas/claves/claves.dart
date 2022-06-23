import 'package:controlmas/controlador/InsertarVenta.dart';
import 'package:controlmas/modelos/Usuarios.dart';
import 'package:controlmas/utiles/Informacion.dart';
import 'package:controlmas/vistas/menu.dart';
import 'package:controlmas/vistas/widgets/boton.dart';
import 'package:controlmas/vistas/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Claves extends StatefulWidget {

  @override
  _ClavesState createState() => _ClavesState();
}

class _ClavesState extends State<Claves> {
  dynamic usuario;
  bool todos=true;
  String resultado;
  String selectedRegion;
  Menu menu = new Menu();
  List<Usuario> users=[];
  List<Usuario> _users=[];
  bool mostrarClave= false;
  List<Usuario>pasoParametro=[];
  bool mostrarTipoClave= false;
  String dropdown ="Ingrese la cantidad de claves";
  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController  couta = new TextEditingController();
  String dropdownCuotas ="Seleccione el tipo de clave";
  List<String> cantidadCuotas=["Seleccione el tipo de clave","Copia de seguridad","500","550","600","650","700","750","800","850","900","950","1000","1050","1100","1150","1200","1250","1300","1350","1400","1450","1500","1550","1800","2000"];
  String generateRandomString(int len) {
    var r = Random();
    const _chars = '1234567890';
    setState(() {
      resultado=List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join(); 
      mostrarTipoClave=true;   
    });
    print(resultado);
    return resultado;
  }
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.white,
            child:new Center(
            //margin: new EdgeInsets.fromLTRB(100,0,100,0),
              child:dataBody(),
            )
          ),
        ),
        mostrarTipoClave? formItemsDesign(
          Icons.check,
          DropdownSoatView(texto:dropdownCuotas ,documentosLista:cantidadCuotas,alCambiar: _alCambiar,dropdownValor: dropdownCuotas),
        ):Container(),
        mostrarClave?Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.white,
            child:new Center(
            //margin: new EdgeInsets.fromLTRB(100,0,100,0),
              child:Text(resultado,style: TextStyle(fontSize:25,)),
            )
          ),
        ):Container(),
        
        Boton(onPresed: _crearClaves,texto:'Aceptar',),
         
      ]
    );
  }
  void _alCambiar(newValue){
    if(newValue!="Seleccione el tipo de clave")
    { 
      generateRandomString(4);
      setState(() {
        dropdownCuotas =newValue.toString();
        mostrarClave= true;
      });
    }else{

    }
  }
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
                      todos=false;
                      mostrarTipoClave=true;
                      usuario=users.where((a) => a.usuario==newValue);
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

  _crearClaves()async{
    if(dropdownCuotas !="Seleccione el tipo de clave" && selectedRegion!='Seleccione un usuario'){
      for ( var par in usuario)
        {
          pasoParametro.add(par);
        }
        var codParametro;
        pasoParametro.map((Usuario map) {
          codParametro=map.usuario;
        }).toList();
      var session= Insertar();
      session.generarClaves(resultado,codParametro,dropdownCuotas)
      .then((_) {
        successDialog(
          context, 
          "Se creó la clave $resultado para $dropdownCuotas correctamente",
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
        "Por favor seleccione el usuario y el tipo de clave",
        neutralAction: (){
        },
      );
    }
  }
}