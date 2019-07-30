import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:s11_login_validacion/src/models/producto_model.dart';
import 'package:s11_login_validacion/src/providers/productos.provider.dart';
import 'package:s11_login_validacion/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final keyForm =
      GlobalKey<FormState>(); //con este manejamos el id para el formulario
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ProductoModel producto = new ProductoModel(); //instancia del modelo

  final _productoProvider =
      new ProductosProvider(); //esta es para la parte de los servicios rest

  File foto;

  bool cargando = false;

  @override
  Widget build(BuildContext context) {
    final productoData = ModalRoute.of(context).settings.arguments;

    if (productoData != null) {
      this.producto = productoData;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Center(child: Text("Producto")),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () {
              _procesarFotografia(0);
            },
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              _procesarFotografia(1);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: this.keyForm,
            child: Column(
              children: <Widget>[
                this._mostrarFoto(),
                this._crearNombre(),
                this.crearPrecio(),
                SizedBox(
                  height: 10.0,
                ),
                this.crearDisponible(),
                this.crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Crea el TextInput del Nombre
  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      validator: (valor) =>
          (valor.length < 3) ? "Es muy corto el nombre del producto" : null,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: "Nombre"),
      onSaved: (titulo) => this.producto.titulo = titulo,
    );
  }

  //este Widget regresaa el precio del producto
  Widget crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: "Precio"),
      validator: (precio) =>
          (!utils.isNumeric(precio)) ? "Ingresa un numero valido" : null,
      onSaved: (precio) => this.producto.valor = double.parse(precio),
    );
  }

  Widget crearDisponible() {
    return SwitchListTile(
      value: this.producto.disponible,
      title: Text("Disponible"),
      activeColor: Colors.deepPurple,
      onChanged: (disponible) {
        setState(() {
          this.producto.disponible = disponible;
        });
      },
    );
  }

  Widget crearBoton() {
    return RaisedButton.icon(
      color: Colors.deepPurple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      label: Text("Guardar"),
      textColor: Colors.white,
      icon: Icon(Icons.save),
      onPressed: (this.cargando) ? null : this._submitForm,
    );
  }

  _submitForm() async {
    if (!this.keyForm.currentState.validate()) return;

    setState(() {
      this.cargando = true;
    });

    this.keyForm.currentState.save();

    if (this.foto != null) {
      this.producto.fotoUrl = await this._productoProvider.subirImagen(foto);
    }

    if (this.producto.id == null) {
      this._productoProvider.crearProducto(producto);
      this.mostrarSnackBar(context, "Registro Creado Exitosamente");
    } else {
      this._productoProvider.editarProducto(producto);
      this.mostrarSnackBar(context, "Registro Modificado Exitosamente");
    }

    Navigator.pop(context);
    setState(() {});
  }

  mostrarSnackBar(BuildContext context, String texto) {
    final snackbar = SnackBar(
      backgroundColor: Colors.lightGreen,
      content: Text("$texto"),
      duration: Duration(milliseconds: 1500),
    );

    this.scaffoldKey.currentState.showSnackBar(snackbar);
  }

  //este nos permite seleccionar la fotografia dentro del carrete
  void _procesarFotografia(int opcion) async {
    ImageSource opcionImagePicker =
        (opcion == 0) ? ImageSource.gallery : ImageSource.camera;

    this.foto = await ImagePicker.pickImage(source: opcionImagePicker);

    print(this.foto);

    if (this.foto == null) {
      this.producto.fotoUrl = null;
      //limpieza
    }
    setState(() {});
  }

  Widget _mostrarFoto() {
    print(this.producto.fotoUrl);
    if (this.producto.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(this.producto.fotoUrl),
        placeholder: AssetImage("assets/jar-loading.gif"),
      );
    } else {
      return Image(
        fit: BoxFit.cover,
        height: 300,
        image: AssetImage(this.foto?.path ?? "assets/no-image.png"),
      );
    }
    /* if (this.producto.fotoUrl != null) {
      return Container();
    } else {
      return Image(
        image: AssetImage("assets/no-image.png"),
        height: 300,
        fit: BoxFit.cover,
      );
    } */
  }
}
