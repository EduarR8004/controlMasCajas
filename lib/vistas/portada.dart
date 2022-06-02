import 'package:controlmas/utiles/Informacion.dart';
import 'package:controlmas/vistas/home.dart';
import 'package:controlmas/vistas/login/login.dart';
import 'package:controlmas/vistas/widgets/boton.dart';
import 'package:flutter/material.dart';

class Portada extends StatefulWidget {
  final bool editar;
  const Portada({Key key, this.editar}) : super(key: key);
  @override
  State<Portada> createState() => _PortadaState();
}

class _PortadaState extends State<Portada> {
  _onPressed(){
    warningDialog(
      context, 
      "Recargue su saldo para seguir apostando",
      neutralAction: (){
        
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
          body:  new SingleChildScrollView(
            child:
            Container(
              color: Colors.blueGrey.shade300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    GestureDetector(child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,50,10,0),
                      child: 
                      Text('Salir',style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                      ),
                    ),
                      onTap:(){
                        if(widget.editar){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Home())
                          );
                        }else{
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login(false)));
                        }
                      },
                    )
                  ],),
                  SizedBox(
                    height:5.0,
                  ),
                  Container(
                    height: 400,
                    child: Image.asset("assets/img/Football.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Haz tu primera apuesta, si fallas te regalamos una apuesta gratuita del mismo monto hasta por un valor de 250. Aplican términos y condiciones",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Recarga tu cuenta Ingresa la cantidad que desees para empezar a apostar",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 19,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        // Text(

                        //   "Secure, manage, and exchange\n"
                        //       "your favorite cryptocurrencies\n"
                        //       "like Bitcoin.",

                        //   style: TextStyle(
                        //     fontFamily: 'Montserrat',
                        //     fontSize: 18,
                        //     color: Colors.white,
                        //     fontWeight: FontWeight.w300,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Boton(onPresed: _onPressed,texto:'Aceptar',),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}