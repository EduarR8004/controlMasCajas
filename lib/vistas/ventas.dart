import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmas/vistas/menu.dart';
import 'package:controlmas/modelos/Ciudad.dart';
import 'package:controlmas/modelos/Cliente.dart';
import 'package:controlmas/utiles/Informacion.dart';
import 'package:controlmas/vistas/ventas/ruta.dart';
import 'package:controlmas/modelos/Departamento.dart';
import 'package:controlmas/vistas/widgets/boton.dart';
import 'package:controlmas/vistas/widgets/dropdown.dart';
import 'package:controlmas/controlador/InsertarVenta.dart';



class NuevaVentaView extends StatefulWidget {
  final bool editar;
  final Cliente cliente;
  final bool nuevo;
  final String valor;
 
  NuevaVentaView(this.editar,this.nuevo,{this.cliente,this.valor}): assert(editar == true || cliente ==null);
  @override
  _NuevaVentaViewState createState() => _NuevaVentaViewState();
}

class _NuevaVentaViewState extends State<NuevaVentaView> {
  String dia;
  List partirDia;
  String _myCity;
  String _myState;
  FocusNode cuota;
  FocusNode tipos;
  bool clave=false;
  FocusNode nombre;
  FocusNode vender;
  FocusNode usuario;
  FocusNode telefono;
  String day="Diario";
  FocusNode pApellido;
  FocusNode sApellido;
  FocusNode documento;
  FocusNode ventaFocus;
  dynamic valorAgenda= true;
  double valorEvaluar;
  bool muestraDia=false;
  String dropdownInicial;
  List <Ciudad>citiesList;
  FocusNode claveVerificar;
  String frecuencia="Frecuencia";
  List <Cliente> listaBloqueados;
  List <Departamento> statesList;
  DateTime now = new DateTime.now();
  String dropdown ="Seleccione un día";
  List <String> activo=['Activo','Inactivo'];
  GlobalKey<FormState> keyForm = new GlobalKey();
  String cuotasError="Ingrese el numero de cuotas";
  String ventaError="Ingrese el valor de la venta";
  String emailUsuario='El campo Email es obligatorio.';
  String nombreUsuario='El campo Nombre es obligatorio.';
  String validarUsuario='El campo Usuario es obligatorio.';
  String documentoUsuario='El campo Documento es obligatorio.';
  String claveVenta='Por favor ingrese la clave de autorización';
  String errorDia='Por favor seleccione un día';
  TextEditingController  ciudad= new TextEditingController();
  TextEditingController  alias = new TextEditingController();
  TextEditingController  tipo = new TextEditingController();
  TextEditingController  venta = new TextEditingController();
  TextEditingController  cuotas = new TextEditingController();
  TextEditingController  cliente = new TextEditingController();
  TextEditingController  clavePago = new TextEditingController();
  TextEditingController  telefono1 = new TextEditingController();
  TextEditingController  direccion = new TextEditingController();
  TextEditingController  nombreCliente= new TextEditingController();
  String telefonoUsuario='El campo Número de teléfono es obligatorio.';
  TextEditingController  documentoNumero = new TextEditingController();
  TextEditingController  primerApellido = new TextEditingController();
  TextEditingController  segundoApellido = new TextEditingController();
  List<String> frecuencias=["Frecuencia","Diario","Semanal","Quincenal"];
  TextEditingController  actividadEconomica = new TextEditingController();
  String creacion="Usuario creado correctamente\n""Desea crear un nuevo usuario?";
  List<String> diasSemana=['Seleccione un día','Lunes','Martes','Miercoles','Jueves','Viernes','Sábado','Domingo','Diario'];

  @override
  void initState() {
    super.initState();
    _getStateList();
    nombre = FocusNode();
    usuario = FocusNode();
    documento = FocusNode();
    telefono = FocusNode();
    ventaFocus = FocusNode();
    claveVerificar = FocusNode();
    dia=DateFormat('EEEE, d').format(now);
    partirDia=dia.split(",");
    dia=partirDia[0];
    if(widget.editar == true){
      valorAgenda=widget.cliente.valor!=null?widget.cliente.valor.toString().split('.'):'';
      nombreCliente.text =widget.cliente.nombre.trim(); 
      documentoNumero.text =widget.cliente.documento.trim(); 
      telefono1.text =widget.cliente.telefono.trim(); 
      ciudad.text = widget.cliente.ciudad==null?'':widget.cliente.ciudad.trim();
      primerApellido.text = widget.cliente.primerApellido.trim();
      segundoApellido.text = widget.cliente.segundoApellido==null?'':widget.cliente.segundoApellido.trim();
      alias.text = widget.cliente.alias==null?'':widget.cliente.alias.trim();
      direccion.text = widget.cliente.direccion==null?'':widget.cliente.direccion.trim();
      actividadEconomica.text = widget.cliente.actividadEconomica==null?'':widget.cliente.actividadEconomica.trim();
      venta.text=widget.cliente.valor==null?'':valorAgenda[0];
      venta.text=widget.valor==null && widget.cliente.valor==null?'':widget.valor;
      valorEvaluar=widget.valor!=null || widget.cliente.valor!=null?double.parse(venta.text):0.0;
      if(valorEvaluar >=500){
        clave=true;
      }else if(valorEvaluar < 500){
        clave=false;
      }
    }
    documento.addListener(() {
      if (documento.hasFocus){
        print("tiene el foco");
      } else {
        _consultarBloqueado(documentoNumero.text);
      }
    },);
  }
 
  Future _getStateList() async {
    var insertar = Insertar();
    var lista =await insertar.consultarDeptos();
    //var data = json.decode(lista);
    setState(() {
      statesList = lista;
    });
  }
  Future _getCitiesList(myState) async {
    var insertar = Insertar();
    var lista =await insertar.consultarCiudad(myState);
    setState(() {
      citiesList = lista;
    });
  }

  Future _consultarBloqueado(documentoNumero) async {
    var insertar = Insertar();
    await insertar.consultarBloqueado(documentoNumero);
    setState(() {
      listaBloqueados = insertar.obtenerBloqueados();
      if(listaBloqueados.length > 0){
        warningDialog(
          context, 
          "Cliente bloqueado, por favor cumuniquese con el supervisor",
          neutralAction: (){
          },
        );
      }
    });
  }
  
  crearCliente()async{  
    var session= Insertar();
    //await pr.show();
    session.insertar(
      nombre:nombreCliente.text.trim(),
      direccion:direccion.text.trim(),
      cuotas:cuotas.text.trim(),
      valorVenta:venta.text.trim(),
      telefono: telefono1.text.trim(),
      departamento:_myState,
      ciudad:_myCity,
      primerApellido:primerApellido.text.trim(),
      segundoApellido:segundoApellido.text.trim(),
      alias: alias.text.trim(),
      actividadEconomica:actividadEconomica.text.trim(),
      documento:documentoNumero.text.trim(),
      frecuencia:frecuencia.trim(),
      tipo:widget.nuevo,
      clave:clave?clavePago.text:'Continuar',
      day: day,
      diaRecoleccion: dropdown,
    ).then((data) {
      if(data['respuesta']){
        if(data['motivo'].toString()=="Cliente bloqueado, por favor cumuniquese con el supervisor"){
          warningDialog(
            context, 
            data['motivo'].toString(),
            neutralAction: (){
            },
          );
        }else{
          if(data['clave']==false){
            warningDialog(
              context, 
              data['motivo'].toString(),
              neutralAction: (){
              },
            );
          }else{
            successDialog(
              context, 
              data['motivo'].toString(),
              neutralAction: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RecoleccionView(boton: true,))
                );
              },
            );
          }
        }
      }else{
        warningDialog(
          context, 
          data['motivo'].toString(),
          neutralAction: (){
          },
        );  
      }      
    });
  }
   
   consultarVentas(){
     var insertar = Insertar();
    insertar.consultarVentas();
   }
  consultarDeptos(){
    var insertar = Insertar();
    insertar.consultarDeptos();
  }

  consultaRecoleccion(){
    var insertar = Insertar();
    insertar.consultarRecoleccion();
  }
  
  @override
  void dispose() {
    ciudad.dispose();
    alias.dispose();
    tipo.dispose();
    venta.dispose();
    cuotas.dispose();
    cliente.dispose();
    clavePago.dispose();
    telefono1.dispose();
    direccion.dispose();
    nombreCliente.dispose();
    documentoNumero.dispose();
    primerApellido.dispose();
    segundoApellido.dispose();
    actividadEconomica.dispose();
    super.dispose();
  }

 formItemsDesign(icon, item) {
   return Padding(
     padding: EdgeInsets.symmetric(vertical:4),
     child: Card(child: ListTile(leading: Icon(icon), title: item)),
   );
 }

  void _frecuencias(newValue){
    if(newValue!="Frecuencia")
    {
      if(newValue=='Semanal' || newValue=='Quincenal')
      {
        setState(() {
          frecuencia = newValue.toString();
          muestraDia=true;
        });
      }else{
        setState(() {
          frecuencia = newValue.toString();
          muestraDia=false;
          dropdown="Diario";
          
        });
      }
      
    }else{
      setState(() {
        frecuencia = newValue.toString();
      });
    }
  }

  void _tipoDia(String tipoDia){
    String diaBase;
    switch (tipoDia) {
      case 'Lunes':
        diaBase ='Monday';
        break;
      case 'Martes':
        diaBase ='Tuesday';
        break;
      case 'Miercoles':
        diaBase='Wednesday';
        break;
      case 'Jueves':
        diaBase ='Thursday';
        break;
        case 'Viernes':
        diaBase ='Friday';
        break;
      case 'Sábado':
        diaBase ='Saturday';
        break;
      case 'Domingo':
        diaBase ='Sunday';
        break;
      default:
        diaBase="Diario";
    }
    setState(() {
      day = diaBase;     
      dropdown = tipoDia.toString();
    });
  }
  _onPressed () {
    consultarDeptos();
    if(venta.text==''){
      ventaFocus.requestFocus();
      warningDialog(
        context, 
        ventaError,
        negativeAction: (){
        },
      );
      return;
    }
    if(nombreCliente.text==''){
      nombre.requestFocus();
        warningDialog(
          context, 
          validarUsuario,
          negativeAction: (){
          },
        );
        return;
    }
    if(documentoNumero.text==''){
      documento.requestFocus();
      warningDialog(
        context, 
        documentoUsuario,
        negativeAction: (){
        },
      );
      return;
    }
    if(telefono1.text==''){
      telefono.requestFocus();
      warningDialog(
        context, 
        telefonoUsuario,
        negativeAction: (){
        },
      );
      return;
    }
    if(cuotas.text==''){
      cuota.requestFocus();
      warningDialog(
        context, 
        cuotasError,
        negativeAction: (){
        },
      );
      return;
    }
    if( int.parse(cuotas.text)>50 ){
      //cuota.requestFocus();
      warningDialog(
        context, 
        'El maximo de cuotas es 50, por favor revisar',
        negativeAction: (){
        },
      );
      return;
    }
    if(clave==true && clavePago.text==''){
      warningDialog(
        context, 
        claveVenta,
        neutralAction: (){
          claveVerificar.requestFocus();
        },
      );
      return;
    }
    if(muestraDia==true && dropdown=='Diario' || dropdown=='Seleccione un día'){
      warningDialog(
        context, 
        errorDia,
        neutralAction: (){
          claveVerificar.requestFocus();
        },
      );
      return;
    }
    if (!keyForm.currentState.validate()){
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data'))
      );                            
    }else{
      crearCliente();
    } 
  }
  String validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Este es un campo obligatorio";
    } else if (!regExp.hasMatch(value)) {
      return "El nombre debe de ser a-z y A-Z";
    }
    return null;
  }

  String validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Por favor ingrese el número de teléfono";
    } else if (value.length != 10) {
      return "El número debe tener 10 digitos";
    }
    return null;
  }

  String validatePass(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0 && widget.editar==false) {
      return "La contraseña es necesaria";
    }else{
      if (value.length < 8) {
        return "Minimo 8 Caracteres";
      } else {
        return null;
      }
    }
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Por favor ingrese el email";
    } else if (!regExp.hasMatch(value)) {
      return "Correo inválido";
    } else {
      return null;
    }
  }

  String validateEmailOptional(String value) {
   String pattern =
       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
   RegExp regExp = new RegExp(pattern);
   if (value.length > 0) {
      if (!regExp.hasMatch(value)) {
      return "Correo invalido";
       } else {
        return null;
      }
   } else {
     return null;
   }
  }

  save() {
    if(widget.editar == true){
      //editar_usuario();
    }else{
      //crear_usuario();
    } 
  }
  @override
  Widget build(BuildContext context) {
    var menu = new Menu();
    return WillPopScope(
    onWillPop: null,
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar: new AppBar(
            title: Text("Nueva venta",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20,),)
            //flexibleSpace:encabezado,
            //backgroundColor:Colors.blue
            // Colors.transparent,
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
                    height: 1350,
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
  Widget estado(){
    return Container(
      height: 40,
      width: 150,
      //alignment: Alignment.topLeft,
      margin: const EdgeInsets.fromLTRB(5, 10, 0, 10),
      //margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border(bottom:BorderSide(width: 1,
          color: Color.fromRGBO(83, 86, 90, 1.0),
        ),
        ),
      ),
      child:
        DropdownButtonHideUnderline(
          child:DropdownButton<String>(
            hint: Padding(
              padding: const EdgeInsets.all(0),
              child:Text(dropdownInicial, 
                textAlign: TextAlign.left,style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontFamily: 'Karla',
                ),
              ),
            ),
            value: dropdownInicial,
            // icon: Icon(Icons.arrow_circle_down_rounded),
            // iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black,fontSize: 15),
            underline: Container(
              height: 2,
              color: Colors.green,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownInicial= newValue;
              });
            },
            items:activo.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child:Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2,2,2),
                  child:new Text(value,textAlign: TextAlign.left,
                  style: new TextStyle(color: Colors.black)),
                ),
              );
            }).toList(),
          ),
        ),
    );
  }
  Widget formUI() {
    return  Column(
      children: <Widget>[
        formItemsDesign(
          Icons.person,
          TextFormField(
            controller: nombreCliente,
            focusNode: nombre,
            decoration: new InputDecoration(
              labelText: 'Nombre',
            ),
            validator: (value){
              if (value.isEmpty) {
                return 'Por favor Ingrese el Nombre';
              }
            },
          )
        ),
        formItemsDesign(
          Icons.person_add,
          TextFormField(
            controller: primerApellido,
            focusNode: pApellido,
            decoration: new InputDecoration(
              labelText: 'Primer Apellido',
            ),
            validator: (value){
              if (value.isEmpty) {
                return 'Por favor Ingrese el Nombre';
              }
            },
          )
        ),
        formItemsDesign(
          Icons.person_add_alt,
          TextFormField(
            controller: segundoApellido,
            focusNode: sApellido,
            decoration: new InputDecoration(
              labelText: 'Segundo Apellido',
            ),
          )
        ),
        formItemsDesign(
          Icons.attribution_rounded,
          TextFormField(
            controller: documentoNumero,
            focusNode: documento,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              labelText: 'Documento',
            ),
            validator: (value){
              if (value.isEmpty) {
                
                return 'Por favor Ingrese el Documento';
              }
            },
            // onChanged: (text){
            //   setState(() {
            //     _consultarBloqueado(text);
            //   });
            // },
          )
        ),
        formItemsDesign(
          Icons.person_add_sharp,
          TextFormField(
            controller: alias,
            decoration: new InputDecoration(
              labelText: 'Alias',
            ),
            keyboardType: TextInputType.text,
            //maxLength: 10,
          )
        ),
        formItemsDesign(
          Icons.phone,
          TextFormField(
            controller: telefono1,
            focusNode: telefono,
            decoration: new InputDecoration(
              labelText: 'Número de teléfono',
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: validateMobile,
          )
        ),
        formItemsDesign(
          Icons.home,
          TextFormField(
            controller: direccion,
            //focusNode: correo,
            decoration: new InputDecoration(
              labelText: 'Dirección',
            ),
            keyboardType: TextInputType.text,
            //validator: validateEmail,
          )
        ),
        formItemsDesign(
          Icons.money,
          TextFormField(
            controller: venta,
            focusNode: ventaFocus,
            // onChanged: (text){
            //   if(double.parse(venta.text)>= 500){
            //     setState(() {
            //       clave = true;
            //       claveVerificar.requestFocus();
            //     });
            //     warningDialog(
            //       context, 
            //       claveVenta,
            //       negativeAction: (){
            //       },
            //     );
            //     return;
            //   }else{
            //     setState(() {
            //       clave= false;    
            //     });
            //   }
            // },
            decoration: new InputDecoration(
              labelText: 'Venta',
            ),
            keyboardType: TextInputType.phone,
            //maxLength: 10,
            //validator: validateMobile,
          )
        ),
        clave?
        formItemsDesign(
          Icons.lock_open_rounded,
          TextFormField(
            controller: clavePago,
            focusNode: claveVerificar,
            decoration: new InputDecoration(
              labelText: 'Clave',
            ),
            validator:(value){
              if (value.isEmpty) {
                return 'Por favor la clave';
              }
            },
          ),
        )
        :Container(),
        formItemsDesign(
          Icons.check_box,
          TextFormField(
            controller: cuotas,
            focusNode: cuota,
            decoration: new InputDecoration(
              labelText: 'Cuotas',
            ),
            keyboardType: TextInputType.phone,
            //maxLength: 10,
            //validator: validateMobile,
          )
        ),
        formItemsDesign(
          Icons.check,
          DropdownSoatView(texto:frecuencia ,documentosLista:frecuencias,alCambiar: _frecuencias,dropdownValor: frecuencia),
        ),
        muestraDia?formItemsDesign(
          Icons.calendar_today,
          DropdownSoatView(texto:dropdown ,documentosLista:diasSemana,alCambiar: _tipoDia,dropdownValor: dropdown),
        ):Container(),
        formItemsDesign(
          Icons.add_location_alt,
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _myState,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Departamento',textAlign:TextAlign.left),
                        onChanged: (String newValue) {
                          setState(() {
                            _myState = newValue;
                            _getCitiesList(_myState);
                            print(_myState);
                          });
                        },
                        items: statesList?.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item.nombre),
                            value: item.nombre,
                          );
                        })?.toList() ??
                        [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        formItemsDesign(
          Icons.add_location_rounded,
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _myCity,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Ciudad',textAlign:TextAlign.left,),
                        onChanged: (String newValue) {
                          setState(() {
                            _myCity = newValue;
                            print(_myCity);
                          });
                        },
                        items: citiesList?.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item.nombre),
                            value: item.nombre,
                          );
                        })?.toList() ??
                        [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // formItemsDesign(
        //   Icons.email,
        //   TextFormField(
        //     controller: ciudad,
        //     focusNode: correo,
        //     decoration: new InputDecoration(
        //       labelText: 'Ciudad',
        //     ),
        //     keyboardType: TextInputType.text,
        //     maxLength: 60,
        //     //validator: validateEmail,
        //   )
        // ),
        formItemsDesign(
          Icons.miscellaneous_services,
          TextFormField(
            controller: actividadEconomica,
            //focusNode: telefono,
            decoration: new InputDecoration(
              labelText: 'Actividad Economica',
            ),
            keyboardType: TextInputType.text,
          )
        ),
        // widget.editar?formItemsDesign(
        //     Icons.check,
        //     widget.editar?estado():Container(),
        // ):Container(),
        Boton(onPresed: _onPressed,texto: 'Aceptar',),                            
      ],
    );
  }

  
}