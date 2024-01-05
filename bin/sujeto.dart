class Sujeto {
  String _codigo;
  int _edad;

 String get codigo => this._codigo;

 set codigo(String value) => this._codigo = value;

  get edad => this._edad;

 set edad( value) => this._edad = value;

  int? puntuacionDirecta;
  int? puntuacionDirectaSpan;
  int? puntuacionInverso;
  int? puntuacionInversoSpan;
  int? puntuacionCreciente;
  int? puntuacionCrecienteSpan;
  int? puntuacionCrecienteIndice;


  Sujeto(this._codigo, this._edad);
}
