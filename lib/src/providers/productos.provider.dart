import 'dart:convert';
import 'dart:io';

import "package:http/http.dart" as http;
import 'package:mime_type/mime_type.dart';
import "package:http_parser/http_parser.dart";

import 'package:s11_login_validacion/src/models/producto_model.dart';

class ProductosProvider {
  final url = "https://chatfirebase-39f18.firebaseio.com";

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = "${this.url}/productos.json";

    //el productoModelToJson lo que hace es
    //lo convierte en forma de mapa y despues lo convierte en un string
    final resp = await http.post(url, body: productoModelToJson(producto));

    print(resp.body);
    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = "${this.url}/productos/${producto.id}.json";

    //el productoModelToJson lo que hace es
    //lo convierte en forma de mapa y despues lo convierte en un string
    final resp = await http.put(url, body: productoModelToJson(producto));

    print(resp.body);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final _url = "${this.url}/productos.json";

    final resp = await http.get(_url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    final List<ProductoModel> productos = new List();

    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);

      prodTemp.id = id;

      productos.add(prodTemp);
    });

    print(productos);
    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final _url = "${this.url}/productos/$id.json";

    final resp = await http.delete(_url);
    print(resp);

    return 1;
  }

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/rodrigoh00per/image/upload?upload_preset=q724r1la");
//se pone como uri ya que asi se pide para poder enviar la imagen

    final imagenRequest =
        http.MultipartRequest("POST", url); //se preparar el request

    //TENEMOS QUE SABER LA EXTENSION DE LA IMAGEN
    final tipoImagen =
        mime(imagen.path).split("/"); //para poder sacar la extension

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(
            tipoImagen[0],
            tipoImagen[
                1])); //se agrega a un tipo de request para poder enviar el archivo

    imagenRequest.files.add(file); //se agrega el archivo al request

    final streamResponse =
        await imagenRequest.send(); //empezamos el stream para subir la iamgen

    final resp = await http.Response.fromStream(
        streamResponse); //esperamos la respuesta del respectivo stream

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print("Algo salio mal");
      return null;
    }
    final respData = json.decode(resp.body);

    return respData["secure_url"];
  }
}
