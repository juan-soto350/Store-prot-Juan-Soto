import 'package:flutter/material.dart';

class PantallaCalculadora extends StatefulWidget {
  const PantallaCalculadora({super.key});

  @override
  State<PantallaCalculadora> createState() => _PantallaCalculadoraState();
}

class _PantallaCalculadoraState extends State<PantallaCalculadora> {
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();

  String _resultado = "0.0";
  bool _huboError = false;

  // Operación seleccionada actualmente (por defecto SUM)
  String _operacion = "SUM";

  // Valida y obtiene los dos números ingresados.
  // Devuelve null si hay error (y ya actualiza _resultado/_huboError).
  List<double>? _obtenerValores() {
    final t1 = _num1Controller.text.trim();
    final t2 = _num2Controller.text.trim();

    if (t1.isEmpty || t2.isEmpty) {
      setState(() {
        _resultado = "Por favor ingresa ambos números";
        _huboError = true;
      });
      return null;
    }

    final double? n1 = double.tryParse(t1);
    final double? n2 = double.tryParse(t2);

    if (n1 == null || n2 == null) {
      setState(() {
        _resultado = "Valores numéricos inválidos, por favor intente de nuevo";
        _huboError = true;
      });
      return null;
    }

    return [n1, n2];
  }

  // FUNCION VOID DE SUMA
  void _realizarSuma() {
    final valores = _obtenerValores();
    if (valores == null) return;
    setState(() {
      _resultado = "${valores[0] + valores[1]}";
      _huboError = false;
    });
  }

  // FUNCION VOID DE RESTA
  void _realizarResta() {
    final valores = _obtenerValores();
    if (valores == null) return;
    setState(() {
      _resultado = "${valores[0] - valores[1]}";
      _huboError = false;
    });
  }

  // FUNCION VOID DE MULTIPLICACION
  void _realizarMultiplicacion() {
    final valores = _obtenerValores();
    if (valores == null) return;
    setState(() {
      _resultado = "${valores[0] * valores[1]}";
      _huboError = false;
    });
  }

  // FUNCION VOID DE DIVISION
  void _realizarDividicion() {
    final valores = _obtenerValores();
    if (valores == null) return;

    if (valores[1] == 0) {
      setState(() {
        _resultado = "No se puede dividir entre cero";
        _huboError = true;
      });
      return;
    }

    setState(() {
      _resultado = "${valores[0] / valores[1]}";
      _huboError = false;
    });
  }

  // Ejecuta la operación según el botón seleccionado
  void _calcular() {
    switch (_operacion) {
      case "SUM":
        _realizarSuma();
        break;
      case "RES":
        _realizarResta();
        break;
      case "MUL":
        _realizarMultiplicacion();
        break;
      case "DIV":
        _realizarDividicion();
        break;
    }
  }

  // FUNCION VOID PARA LIMPIAR/BORRAR LOS VALORES
  void _limpiar() {
    _num1Controller.clear();
    _num2Controller.clear();
    setState(() {
      _resultado = "0.0";
      _huboError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.indigoAccent,
                      child: Icon(Icons.calculate, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Calculadora Interactiva',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Aprendiendo a hacer una calculadora en flutter',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CONTROLADOR 1 DE LOS NUMEROS
            TextField(
              controller: _num1Controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Valor 1',
                hintText: 'Ej. 15.4',
                prefixIcon: const Icon(Icons.looks_one, color: Colors.indigo),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // BOTONES DE OPERACION: SUM, RES, MUL, DIV
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _botonOperacion("SUM", Icons.add, Colors.green),
                _botonOperacion("RES", Icons.remove, Colors.red),
                _botonOperacion("MUL", Icons.close, Colors.orange),
                _botonOperacion("DIV", Icons.percent, Colors.purple),
              ],
            ),
            const SizedBox(height: 16),

            // CONTROLADOR 2 DE LOS NUMEROS
            TextField(
              controller: _num2Controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Valor 2',
                hintText: 'Ej. 10.6',
                prefixIcon: const Icon(Icons.looks_two, color: Colors.indigo),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // BOTON PARA CALCULAR EL RESULTADO
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _calcular,
                    icon: const Icon(Icons.calculate_outlined),
                    label: const Text('CALCULAR OPERACION'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _limpiar,
                  icon: const Icon(Icons.refresh),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.all(14),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),

            // TARJETA DE RESULTADO / ERROR
            Card(
              color: _huboError ? Colors.red[50] : Colors.indigo[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: _huboError ? Colors.red : Colors.indigo, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      _huboError ? '⚠️ ATENCIÓN' : 'RESULTADO FINAL DE SU OPERACION',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _huboError ? Colors.red : Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _resultado,
                      style: TextStyle(
                        fontSize: _huboError ? 14 : 28,
                        fontWeight: FontWeight.bold,
                        color: _huboError ? Colors.red[800] : Colors.indigo[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Construye cada botón de operación, resaltando el que está seleccionado
  Widget _botonOperacion(String texto, IconData icono, Color color) {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          _operacion = texto;
        });
      },
      icon: Icon(icono),
      label: Text(texto),
      style: ElevatedButton.styleFrom(
        backgroundColor: _operacion == texto ? color : Colors.grey[300],
        foregroundColor: _operacion == texto ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
