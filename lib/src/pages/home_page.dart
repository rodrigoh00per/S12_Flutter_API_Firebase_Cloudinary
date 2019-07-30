import 'package:flutter/material.dart';
import 'package:s11_login_validacion/src/models/producto_model.dart';
import 'package:s11_login_validacion/src/providers/productos.provider.dart';
/* import 'package:s11_login_validacion/bloc/provider.dart'; */

class HomePage extends StatelessWidget {
  final _productoProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    /* final bloc = Provider.of(context); */
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: this.crearListado(),
      floatingActionButton: this._crearBoton(context),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurple,
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, "producto"),
    );
  }

  Widget crearListado() {
    return FutureBuilder(
      future: this._productoProvider.cargarProductos(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (BuildContext context, int index) =>
                this.crearItem(productos[index], context),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

//este es un listTile con el producto para poder mostrar su data
  crearItem(ProductoModel producto, BuildContext context) {
    return Dismissible(
        direction: DismissDirection.endToStart,
        key: UniqueKey(),
        background: Container(
          padding: EdgeInsets.only(right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          this._productoProvider.borrarProducto(producto.id);
        },

        //AQUI VAMOS A MOSTRAR EL TITULO,PRECIO Y EL ID
        child: Card(
          child: Column(
            children: <Widget>[
//mostrar imagen
              (producto.fotoUrl == null)
                  ? Image(
                      image: AssetImage("assets/no-image.png"),
                    )
                  : FadeInImage(
                      image: NetworkImage(producto.fotoUrl),
                      placeholder: AssetImage("assets/jar-loading.gif"),
                      height: 300.0,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),

              ListTile(
                title: Text(
                    "Titulo:${producto.titulo} - Precio:${producto.valor}"),
                subtitle: Text(producto.id),
                onTap: () {
                  Navigator.pushNamed(context, "producto", arguments: producto);
                },
              ),
            ],
          ),
        ));
  }
}
