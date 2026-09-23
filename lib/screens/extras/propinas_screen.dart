import 'package:flutter/material.dart';

class PropinasScreen extends StatefulWidget {
  const PropinasScreen({super.key});

  @override
  State<PropinasScreen> createState() => _PropinasScreenState();
}

class _PropinasScreenState extends State<PropinasScreen> {
  final TextEditingController _cuentaController = TextEditingController(text: '120000');
  double _porcentajePropina = 10;
  int _personas = 3;
  double _total = 132000;
  bool _huboError = false;

  @override
  void dispose() {
    _cuentaController.dispose();
    super.dispose();
  }

  void _calcular() {
    final cuenta = double.tryParse(_cuentaController.text.trim());
    if (cuenta == null || cuenta < 0) {
      setState(() {
        _huboError = true;
        _total = 0;
      });
      return;
    }

    setState(() {
      _huboError = false;
      _total = cuenta * (1 + _porcentajePropina / 100);
    });
  }

  void _cambiarPersonas(int cambio) {
    setState(() {
      _personas = (_personas + cambio).clamp(1, 30);
    });
    _calcular();
  }

  String _moneda(double valor) => '\$${valor.round()}';

  @override
  Widget build(BuildContext context) {
    final propina = _total - (double.tryParse(_cuentaController.text.trim()) ?? 0);
    final porPersona = _total / _personas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Propinas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade50,
                      child: const Icon(Icons.receipt_long, color: Colors.deepPurple),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'División de cuenta',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Calcula la propina y cuánto paga cada persona',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _cuentaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calcular(),
              decoration: InputDecoration(
                labelText: 'Total de la cuenta',
                prefixIcon: const Icon(Icons.attach_money, color: Colors.deepPurple),
                errorText: _huboError ? 'Ingresa un valor válido' : null,
              ),
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PROPINA SUGERIDA',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [10, 15, 20].map((porcentaje) {
                        final seleccionado = _porcentajePropina == porcentaje;
                        return ChoiceChip(
                          label: Text('$porcentaje%'),
                          selected: seleccionado,
                          selectedColor: Colors.deepPurple,
                          labelStyle: TextStyle(
                            color: seleccionado ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (_) {
                            setState(() => _porcentajePropina = porcentaje.toDouble());
                            _calcular();
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('PERSONAS', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _personas > 1 ? () => _cambiarPersonas(-1) : null,
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Colors.deepPurple,
                          tooltip: 'Quitar persona',
                        ),
                        SizedBox(
                          width: 28,
                          child: Text('$_personas', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                          onPressed: _personas < 30 ? () => _cambiarPersonas(1) : null,
                          icon: const Icon(Icons.add_circle_outline),
                          color: Colors.deepPurple,
                          tooltip: 'Agregar persona',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.deepPurple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.deepPurple, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'RESUMEN DE LA CUENTA',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 14),
                    _ResumenFila(label: 'Propina', value: _moneda(propina)),
                    _ResumenFila(label: 'Total con propina', value: _moneda(_total)),
                    const Divider(height: 24),
                    const Text('PAGA CADA PERSONA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 4),
                    Text(
                      _moneda(porPersona),
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.deepPurple),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () {
                _cuentaController.clear();
                setState(() {
                  _porcentajePropina = 10;
                  _personas = 1;
                  _total = 0;
                  _huboError = false;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reiniciar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumenFila extends StatelessWidget {
  const _ResumenFila({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
