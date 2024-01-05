import 'dart:io';
import 'sujeto.dart';
import 'package:csv/csv.dart';

const numeroOrdenDirecto = [
  [
    [2, 9],
    [5, 4]
  ],
  [
    [3, 9, 6],
    [6, 5, 2]
  ],
  [
    [5, 4, 1, 7],
    [9, 1, 6, 8]
  ],
  [
    [8, 2, 1, 9, 6],
    [7, 2, 3, 4, 9]
  ],
  [
    [5, 7, 3, 6, 4, 8],
    [3, 8, 4, 1, 7, 5]
  ],
  [
    [2, 1, 8, 9, 4, 3, 7],
    [7, 8, 5, 2, 1, 6, 3]
  ],
  [
    [1, 8, 4, 3, 7, 5, 3, 6],
    [2, 7, 9, 6, 3, 1, 4, 8]
  ],
  [
    [7, 2, 6, 1, 9, 4, 8, 3, 5],
    [4, 3, 8, 9, 1, 7, 5, 6, 2]
  ],
  [
    [6, 2, 5, 3, 1, 8, 9, 5, 4, 7],
    [9, 4, 3, 8, 7, 5, 2, 9, 6, 1]
  ],
];

const numeroOrdenInverso = [
  [
    [9, 4],
    [5, 6]
  ],
  [
    [2, 1],
    [1, 3]
  ],
  [
    [
      3,
      9,
    ],
    [
      8,
      5,
    ]
  ],
  [
    [2, 3, 6],
    [5, 4, 1]
  ],
  [
    [4, 5, 8],
    [2, 7, 5]
  ],
  [
    [7, 4, 5, 2],
    [9, 3, 8, 6]
  ],
  [
    [2, 1, 7, 9, 4],
    [5, 3, 3, 8, 7]
  ],
  [
    [1, 6, 4, 7, 5, 8],
    [6, 3, 7, 2, 9, 1]
  ],
  [
    [8, 1, 5, 2, 4, 3, 6],
    [4, 3, 7, 9, 2, 8, 1]
  ],
  [
    [3, 1, 7, 9, 4, 6, 8, 2],
    [9, 8, 1, 6, 3, 2, 4, 7]
  ],
];

const numeroOrdenCreciente = [
  [
    [3, 1],
    [8, 6]
  ],
  [
    [5, 2, 4],
    [4, 3, 3]
  ],
  [
    [4, 1],
    [3, 2]
  ],
  [
    [5, 2, 7],
    [1, 8, 6]
  ],
  [
    [7, 5, 8, 1],
    [4, 2, 9, 3]
  ],
  [
    [1, 5, 6, 2, 8],
    [2, 8, 4, 7, 9]
  ],
  [
    [3, 3, 6, 1, 5],
    [4, 9, 4, 6, 9]
  ],
  [
    [8, 5, 2, 5, 3, 7],
    [6, 1, 4, 7, 9, 3]
  ],
  [
    [9, 7, 9, 6, 2, 6, 8],
    [3, 1, 7, 5, 1, 8, 5]
  ],
  [
    [6, 9, 6, 2, 1, 3, 7, 9],
    [1, 4, 8, 5, 4, 8, 7, 4]
  ],
  [
    [2, 5, 7, 7, 4, 8, 7, 5, 2],
    [9, 1, 8, 3, 6, 3, 9, 2, 6]
  ],
];

void main() async {
  print('''
    **Test Digitos WISC V**
    --------------------
    En todo momento podras salir del test introduciendo la letra q y presionando enter
    Comienza el test:
''');

  print('Introduce el codigo del sujeto: ');
  String? codigo = stdin.readLineSync();
  salirDelPrograma(codigo);

  print('Introduce la edad: ');
  String edad = stdin.readLineSync() ?? '';
  salirDelPrograma(edad);
  int edadInt = comprobacionEsNumero(edad);

  Sujeto sujeto = Sujeto(codigo!, edadInt);

  Map resultadosCreciente = testCreciente(sujeto.edad);

  sujeto.puntuacionCreciente = resultadosCreciente['aciertos'];
  sujeto.puntuacionCrecienteSpan = resultadosCreciente['span'];

  Map resultadosDirecto = testDirecto();

  sujeto.puntuacionDirecta = resultadosDirecto['aciertos'];
  sujeto.puntuacionDirectaSpan = resultadosDirecto['span'];

  Map resultadosIndirecto = testInirecto();

  sujeto.puntuacionInverso = resultadosIndirecto['aciertos'];
  sujeto.puntuacionInversoSpan = resultadosIndirecto['span'];
  sujeto.puntuacionCrecienteIndice = resultadosCreciente['indices'];

  //........

  List<List<dynamic>> listaDatos = [
    ['Codigo', 'Edad', 'Dd', 'SpanDd', 'Di', 'SpanDi', 'Dc', 'SpanDc', 'Puntuacion Directa Digitos'],
    [
      sujeto.codigo,
      sujeto.edad,
      sujeto.puntuacionDirecta,
      sujeto.puntuacionDirectaSpan,
      sujeto.puntuacionInverso,
      sujeto.puntuacionInversoSpan,
      sujeto.puntuacionCreciente,
      sujeto.puntuacionCrecienteSpan,
      sujeto.puntuacionCrecienteIndice,
    ]
  ];

  String csv = ListToCsvConverter().convert(listaDatos);
  Directory directory = Directory('D:/Exercism/Dart/Proyecto_final_Dart/Test');
  final path = directory.path + '/' + sujeto.codigo + '.csv';
  File file = await File(path);
  file.writeAsString(csv);
}

Map testDirecto() {
  print('--------------------------------');
  print('Comienza el test Orden Directo');
  print('--------------------------------');

  int aciertos = 0;
  int span = 0;
  int fallosEnItem = 0;

  for (var fila in numeroOrdenDirecto) {
    fallosEnItem = 0;
    for (var subfila in fila) {
      print(subfila);
      while (true) {
        print('Introduce [s] o [n] siha acertado');
        String? haAcertado = stdin.readLineSync();
        salirDelPrograma(haAcertado);
        if (haAcertado != null) {
          haAcertado = haAcertado.toLowerCase();
          if (haAcertado == 's') {
            aciertos++;
            break;
          } else if (haAcertado == 'n') {
            fallosEnItem++;
            break;
          } else {
            print('Tienes que colocar "s" o "n" para poder continuar');
          }
        }
      }
    }
    if (fila[0].length > 2) {
      span = fila[0].length - 1;
    }
    if (fallosEnItem == 2) {
      break;
    }
  }
  // print(aciertos);
  // print(span);
  return {'aciertos': aciertos, 'span': span};
}

Map testInirecto() {
  print('--------------------------------');
  print('Comienza el test Orden Indirecto');
  print('--------------------------------');

  int aciertos = 0;
  int span = 0;
  int fallosEnItem = 0;

  int contEjemplo = 0;
  //int spanAnterior = 0;

  for (var fila in numeroOrdenInverso) {
    fallosEnItem = 0;
    for (var subfila in fila) {
      if (contEjemplo == 0) {
        print('Ejemplo: $subfila');
      } else {
        print(subfila);
        while (true) {
          print('Introduce [s] o [n] siha acertado');
          String? haAcertado = stdin.readLineSync();
          salirDelPrograma(haAcertado);
          if (haAcertado != null) {
            haAcertado = haAcertado.toLowerCase();
            if (haAcertado == 's') {
              aciertos++;
              span = subfila.length;
              break;
            } else if (haAcertado == 'n') {
              fallosEnItem++;
              break;
            } else {
              print('Tienes que colocar "s" o "n" para poder continuar');
            }
          }
        }
      }
    }

    if (contEjemplo != 0) {
      if (fallosEnItem == 2) {
        break;
      }
    } else {
      contEjemplo++;
    }
  }
  // print(aciertos);
  // print(span);
  return {'aciertos': aciertos, 'span': span};
}

Map testCreciente(int edad) {
  print('--------------------------------');
  print('Comienza el test Orden Creciente');
  print('--------------------------------');

  int aciertos = 0;
  int span = 0;
  int fallosEnItem = 0;

  int indicesAcertados = 0;

  int contEjemplo = 0;
  bool testInicialSuperado = true;
  //int spanAnterior = 0;

  if (edad == 6 || edad == 7) {
    //Entre 6 y 7 años
    print('Pide que cuente hasta 3');
    while (true) {
      print('Introduce [s] o [n] siha acertado');
      String? haAcertado = stdin.readLineSync();
      salirDelPrograma(haAcertado);
      if (haAcertado != null) {
        haAcertado = haAcertado.toLowerCase();
        if (haAcertado == 's') {
          for (var fila in numeroOrdenCreciente) {
            fallosEnItem = 0;
            for (var subfila in fila) {
              //Mas de 6 o 7 años

              if (contEjemplo < 2) {
                print('Ejemplo: $subfila');
              } else {
                print(subfila);
                while (true) {
                  print('Introduce [s] o [n] siha acertado');
                  String? haAcertado = stdin.readLineSync();
                  salirDelPrograma(haAcertado);
                  if (haAcertado != null) {
                    haAcertado = haAcertado.toLowerCase();
                    if (haAcertado == 's') {
                      aciertos++;
                      span = subfila.length;
                      indicesAcertados += subfila.length;
                      break;
                    } else if (haAcertado == 'n') {
                      fallosEnItem++;
                      break;
                    } else {
                      print(
                          'Tienes que colocar "s" o "n" para poder continuar');
                    }
                  }
                }
              }
            }
            if (contEjemplo >= 2) {
              if (fallosEnItem == 2) {
                break;
              }
            } else {
              contEjemplo++;
            }
          }
          break;
        } else if (haAcertado == 'n') {
          break;
        } else {
          print('Tienes que colocar "s" o "n" para poder continuar');
        }
      }
    }
  }

  // print(aciertos);
  // print(span);
  return {'aciertos': aciertos, 'span': span, 'indices': indicesAcertados};
}

void salirDelPrograma(String? entrada) {
  if (entrada == 'q') {
    print('Seguro que deseas salir? Introduce q de nuevo');
    String? respuesta = stdin.readLineSync();

    if (respuesta == 'q') {
      exit(0);
    }
  }
}

int comprobacionEsNumero(String entrada) {
  if (int.tryParse(entrada!) == null) {
    print('Edad no valida no se ha reconocido el numero');
    exit(0);
  } else {
    return int.parse(entrada);
  }
}
