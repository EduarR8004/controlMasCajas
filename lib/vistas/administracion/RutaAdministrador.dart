import 'package:controlmas/modelos/ConteoDebeAdmin.dart';
import 'package:controlmas/modelos/TotalRutaAdmin.dart';
import 'package:controlmas/modelos/Usuarios.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:controlmas/vistas/menu.dart';
import 'package:controlmas/modelos/RutaAdmin.dart';
import 'package:controlmas/controlador/InsertarVenta.dart';
import 'package:controlmas/vistas/administracion/RecoleccionAdmin.dart';


class RutaAdminView extends StatefulWidget {
  RutaAdminView({this.usuario});
  final String usuario;
  @override
  _RutaAdminViewState createState() => _RutaAdminViewState();
}

class _RutaAdminViewState extends State<RutaAdminView> {
  String ini;
  String ffinal;
  String usuario;
  bool mostrar= false;
  String fechaConsulta;
  DateTime parseFinal;
  DateTime parseInicial;
  String selectedRegion;
  List<Usuario> users=[];
  List<Usuario> _users=[];
  ConteoDebeAdmin _porAgendar;
  List<RutaAdminTotal> agendado=[];
  DateTime now = new DateTime.now();
  List<ConteoDebeAdmin> recolectado=[];
  final format = DateFormat("dd/MM/yyyy hh:mm");
  final formatSumar = DateFormat("yyyy-MM-dd");

  @override
  void didUpdateWidget(RutaAdminView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      //widget.boton==true?boton=true:boton=false;
    });
  }
  @override
  void initState() {
    fechaConsulta = formatSumar.format(now);
    ini=formatSumar.format(now);
    ffinal=formatSumar.format(now);
    String fechaInicial=ini+' 00:00:00';
    String fechaFinal=ffinal+' 23:59:59';
    parseInicial = DateTime.parse(fechaInicial);
    parseFinal = DateTime.parse(fechaFinal);
    super.initState();
  }

  Future<List<RutaAdmin>> ventas(String usuario){
    var insertar = Insertar();
    return insertar.descargarRuta(usuario);
  }
  Future<List<ConteoDebeAdmin>>valoresRecolectados(usuario)async{
    var session= Insertar();
    await session.valoresRecolectadosAdmin(parseInicial.millisecondsSinceEpoch, parseFinal.millisecondsSinceEpoch,usuario).then((_){
      recolectado=session.obtenerClientesRecolectadosAdmin();
    });
    return recolectado;
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

  Widget cardCuenta(RutaAdmin item){
    DateTime fecha= DateTime.fromMillisecondsSinceEpoch(item.fecha);
    int diffDays = now.difference(fecha).inDays;
    double diferencia = diffDays-item.numeroCuota;
    String motivo=item.motivo;
    Icon iconoEstado;
    Color color;
    Icon icono;
    if(diferencia <=3 )
    {
      icono=Icon(Icons.thumb_up, size:30,color:Colors.green);
    }else if(diferencia > 3 && diferencia < 6)
    {
      icono=Icon(Icons.thumbs_up_down , size:30,color:Colors.yellow);
    }else if(diferencia == 0)
    {
      icono=Icon(Icons.person, size:30,);
    }else{
      icono=Icon(Icons.thumb_down_sharp, size:30,color:Colors.red);
    }

    if(motivo=="abono" || motivo=="pago"|| motivo=="Prestamo"){
      iconoEstado=Icon(Icons.check, size:20,color:Colors.green);
      color=Colors.green;
    }else if(motivo!="abono" && motivo!="pago"){
      iconoEstado=Icon(Icons.clear, size:20,color:Colors.red);
    }
    print(diffDays);
    return 
    Card(
      child:
      ListTile(
        leading:icono,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("D:"+item.idCliente.toString()+" "+item.alias,style: TextStyle(
              fontSize: 18,)
            ),
            Text(item.nombre+" "+item.primerApellido,style: TextStyle(
              fontSize: 18,)
            ),
          ],
        ),
        subtitle:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text((item.cuotas-item.numeroCuota).toStringAsFixed(1),style: TextStyle(fontSize:15,)),
                Text(" / ",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize:15,)),
                Text(item.saldo.toStringAsFixed(1),style: TextStyle(fontSize:15,)),
                Text(" / ",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize:15,)),
                Text(item.valorCuota.toStringAsFixed(1),style: TextStyle(fontSize:15,)),
                iconoEstado,
                SizedBox(width: 5.0),
                Text(item.valorTemporal.toStringAsFixed(1),style: TextStyle(fontSize:15,color: color)),
                SizedBox(width: 5.0),
              ],
            ),
            Text(format.format((DateTime.fromMillisecondsSinceEpoch(item.orden,isUtc:false))).toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:15)), 
          ],
        ),
        onTap: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => RecoleccionAdmin(data: item,),)); }
          );
        },
      )
    );
  }
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    var menu = new Menu();
    return SafeArea(
      child: Scaffold(
        appBar: new AppBar(title: new Text('Ruta'),actions: <Widget>[
        ],
        ),
        drawer: menu,
        body: Center(child:body()),
      )
    );
  }
  Widget body(){
    return Column(
      children: [
        dataBody(),
        mostrar?
        Expanded(
          child:Container(
            width:360,
            child:listaVentas(usuario)
          )   
        ):Container(),
        mostrar?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: 
            // Expanded(
            //   child: 
              SizedBox(
                child:tablaTotal(),
              ),
            //),
          ),
        ):Container(),
      ],
    );
  }
  FutureBuilder<List<RutaAdmin>> listaVentas(String usuario) {
    return FutureBuilder<List<RutaAdmin>>(
      //llamamos al método, que está en la carpeta db file database.dart
      future: ventas(usuario),
      builder: (BuildContext context, AsyncSnapshot<List<RutaAdmin>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            //Count all records
            itemCount: snapshot.data.length,
            // todos los registros que están en la tabla del usuario se pasan a un elemento Elemento del usuario = snapshot.data [index];
            itemBuilder: (BuildContext context, int index){
              RutaAdmin item = snapshot.data[index];
              //delete one register for id
              return cardCuenta(item);
              // return Dismissible(
              //   key: UniqueKey(),
              //   background: Container(color: Colors.red),
              //   onDismissed: (diretion) {
              //     //DatabaseProvider.db.eliminarId(item.id,"producto");
              //   },
              //   //Ahora pintamos la lista con todos los registros
              //   child:cardCuenta(item),
              // );
            },
          );
        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget tablaTotal(){
    return FutureBuilder<List<ConteoDebeAdmin>>(
      //llamamos al método, que está en la carpeta db file database.dart
      future: valoresRecolectados(usuario),
      builder: (BuildContext context, AsyncSnapshot<List<ConteoDebeAdmin>> snapshot) {
        if (snapshot.hasData) {
          _porAgendar = recolectado[0];
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _porAgendar.valorCuotas==null?Text("Valor día: "+"0",style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,color:Colors.blueGrey)):Text("Valor día: "+_porAgendar.valorCuotas.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,color:Colors.blueGrey)),
                  ],
                ),
              ],
            ),
          );
        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}