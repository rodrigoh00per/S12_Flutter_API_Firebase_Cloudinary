import 'package:flutter/material.dart';
import 'package:s11_login_validacion/bloc/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[this._crearFondo(context), _loginForm(context)],
    ));
  }

  Widget _crearFondo(context) {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height * 0.40,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0)
      ])),
    );

    final circulo = Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(top: 20, child: circulo),
        Positioned(top: 300, left: 50, child: circulo),
        Positioned(right: -40, child: circulo),
        Positioned(right: -40, child: circulo),
        Container(
          padding: EdgeInsets.only(top: 60),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.person_pin_circle,
                color: Colors.white,
                size: 130,
              ),
              SizedBox(
                width: double.infinity,
                height: 10,
              ),
              Text(
                "Rodrigo Guerrero",
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
        )
      ],
    );
  }

  _loginForm(BuildContext context) {
    final bloc = Provider.of(context);

    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(children: [
        SafeArea(
          child: Container(
            height: 180.0,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 30.0),
          padding: EdgeInsets.symmetric(vertical: 50.0),
          decoration: BoxDecoration(boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black26,
                blurRadius: 3.0,
                offset: Offset(0.0, 5.0),
                spreadRadius: 3.0)
          ], color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
          width: size.width * 0.85,
          child: Column(
            children: <Widget>[
              Text(
                "Ingreso a la Aplicación",
                style: TextStyle(fontSize: 20.0),
              ),
              inputEmail(bloc),
              inputPassword(bloc, context),
              SizedBox(height: 30.0),
              crearBoton(bloc, context)
            ],
          ),
        ),
        Text("¿Olvido su Contraseña?")
      ]),
    );
  }

  Widget inputEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.streamEmail,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(Icons.email, color: Colors.deepPurple),
                hintText: "rodrigo.prueba@gmail.com",
                labelText: "Introduce tu correo",
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget inputPassword(LoginBloc bloc, context) {
    final theme = Theme.of(context);
    return StreamBuilder(
      stream: bloc.streamPassword,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Theme(
              data: theme.copyWith(primaryColor: Colors.deepPurple),
              child: new TextField(
                obscureText: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock, color: Colors.deepPurple),
                    labelText: "Introduce tu contraseña",
                    counterText: snapshot.data,
                    errorText: snapshot.error),
                onChanged: bloc.changePassword,
              ),
            ));
      },
    );
  }

  Widget crearBoton(LoginBloc bloc, BuildContext context) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return RaisedButton(
            color: Colors.deepPurple,
            textColor: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              child: Text("Ingresar"),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onPressed: (snapshot.hasData)
                ? () {
                    Navigator.pushReplacementNamed(context, "home");
                  }
                : null,
          );
        });
  }
}
