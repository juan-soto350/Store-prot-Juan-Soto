import 'package:flutter/material.dart';

class CotizadorScreen extends StatefulWidget {
  const CotizadorScreen({super.key});

  @override
  State<CotizadorScreen> createState() => _PantallaCotizadorState();
}

class _PantallaCotizadorState extends State<CotizadorScreen> {
  final TextEditingController _pesoController = TextEditingController();

  //Cuidades donde se pueden enviar el paquete
  final Map<String, int> _cuidades = {
    'Bogota D.C': 8000,
    'Medellín': 12000,
    'Cali': 14000
  };

  //tipos de servicios de entrega con costo adicional
  final Map<String, int> _Envios = {
    'Estándar': 0,
    'Express': 5000,
  };

  String? _cuidadSeleccionada;
  String? _tipoEnvioSeleccionado = 'Estándar';
  bool _SeguroAct = false;

  double? _total;
  String? _ErrorMensaje;

  @override
  void initState() {
    super.initState();
    _cuidadSeleccionada = _cuidades.keys.first;
  }

  //Funcion void para calcular el costo de la cotizacion
  void _calcularCotizacion() {
    final pesoTexto = _pesoController.text.trim();

    if (pesoTexto.isEmpty) {
      setState(() {
        _ErrorMensaje = 'Por favor ingresa el peso del paquete';
        _total = null;
      });
      return;
    }

    final double? peso = double.tryParse(pesoTexto);
    if (peso == null || peso <= 0) {
      setState(() {
        _ErrorMensaje = 'Ingresa un peso válido en Kg (ej. 25.5)';
        _total = null;
      });
      return;
    }

    final int costoCiudad = _cuidades[_cuidadSeleccionada] ?? 0;
    final int costoVelocidad = _Envios[_tipoEnvioSeleccionado] ?? 0;
    final int costoSeguro = _SeguroAct ? 3000 : 0;

    final double total =
        costoCiudad + (peso * 2000) + costoVelocidad + costoSeguro;

    setState(() {
      _total = total;
      _ErrorMensaje = null;
    });
  }

  void _limpiar() {
    _pesoController.clear();
    setState(() {
      _cuidadSeleccionada = _cuidades.keys.first;
      _tipoEnvioSeleccionado = 'Estándar';
      _SeguroAct = false;
      _total = null;
      _ErrorMensaje = null;
    });
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotizador Express de Envíos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ENCABEZADO
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 70, 216, 82),
                      child: Icon(Icons.local_shipping, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cotizador de Envíos Nacionales',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Calcula el costo de tu paquete al instante',
                              style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // PESO DEL PAQUETE
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _pesoController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Peso del paquete (Kg)',
                    hintText: 'Ej. 2.5',
                    prefixIcon: const Icon(Icons.scale, color: Color.fromARGB(255, 63, 181, 112)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // CIUDAD DE DESTINO (DROPDOWN)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: DropdownButtonFormField<String>(
                  value: _cuidadSeleccionada,
                  decoration: const InputDecoration(
                    labelText: 'Ciudad de destino',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.location_city, color: Color.fromARGB(255, 63, 181, 89)),
                  ),
                  items: _cuidades.entries.map((c) {
                    return DropdownMenuItem(
                      value: c.key,
                      child: Text('${c.key} (\$${c.value})'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _cuidadSeleccionada = val;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // TIPO DE ENVÍO (RADIO)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                      child: Text('Tipo de envío',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                    ),
                    ..._Envios.entries.map((tipo) {
                      return RadioListTile<String>(
                        title: Text(tipo.key),
                        subtitle: Text(tipo.value == 0
                            ? 'Sin costo adicional'
                            : '+ \$${tipo.value}'),
                        value: tipo.key,
                        groupValue: _tipoEnvioSeleccionado,
                        activeColor: const Color.fromARGB(255, 96, 181, 63),
                        onChanged: (val) {
                          setState(() {
                            _tipoEnvioSeleccionado = val!;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // SEGURO DE MERCANCÍA (SWITCH)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: SwitchListTile(
                title: const Text('Seguro de mercancía'),
                subtitle: const Text('Protege tu envío por + \$3.000'),
                secondary: const Icon(Icons.verified_user, color: Color.fromARGB(255, 63, 181, 122)),
                value: _SeguroAct,
                activeColor: const Color.fromARGB(255, 84, 216, 106),
                onChanged: (val) {
                  setState(() {
                    _SeguroAct = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // BOTONES DE ACCIÓN
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _calcularCotizacion,
                    icon: const Icon(Icons.calculate),
                    label: const Text('COTIZAR ENVÍO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 106, 228, 95),
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

            // RESULTADO / ERROR
            Card(
              color: _ErrorMensaje != null ? Colors.red[50] : Colors.indigo[50],
              elevation: 3,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: _ErrorMensaje != null ? Colors.red : const Color.fromARGB(255, 63, 181, 83),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      _ErrorMensaje != null ? '⚠️ ATENCIÓN' : 'VALOR TOTAL DEL ENVÍO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _ErrorMensaje != null ? Colors.red : const Color.fromARGB(255, 63, 181, 69),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _ErrorMensaje ??
                          (_total != null
                              ? '\$${_total!.toStringAsFixed(0)}'
                              : '\$0'),
                      style: TextStyle(
                        fontSize: _ErrorMensaje != null ? 14 : 28,
                        fontWeight: FontWeight.bold,
                        color: _ErrorMensaje != null ? Colors.red[800] : const Color.fromARGB(255, 126, 26, 26),
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
}
