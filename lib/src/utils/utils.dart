bool isNumeric(String valor) {
  if (valor.length < 1) return false;

  final numero = num.tryParse(valor);

  return (numero == null) ? false : true;
}
