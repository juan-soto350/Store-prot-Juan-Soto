import '../../models/medico.dart';
import 'package:flutter/material.dart';

class DetalleScreen extends StatelessWidget {
  final Medico medico;
  const DetalleScreen({super.key, required this.medico});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Médico'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.indigo.shade100,
                          child: Text(
                            medico.nombre
                                .split(' ')
                                .map((p) => p.isNotEmpty ? p[0] : '')
                                .take(2)
                                .join(),
                            style: const TextStyle(fontSize: 20, color: Colors.indigo),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(medico.nombre,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(medico.especialidad, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                            ],
                          ),
                        ),
                        Chip(
                          label: Text(
                            medico.disponibleHoy ? 'Disponible hoy' : 'No disponible',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: medico.disponibleHoy ? Colors.green : Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text('Consultorio: ${medico.consultorio}', style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 6),
                    Text('Ubicación: ${medico.ubicacion}', style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 6),
                    Text('Experiencia: ${medico.anosExperiencia} años', style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 6),
                    Text('Precio de consulta: ${medico.precioConsulta}', style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Descripción', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(medico.descripcion, style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: medico.disponibleHoy
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Cita solicitada'),
                            content: Text('Tu cita con ${medico.nombre} ha sido solicitada con éxito.'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
                            ],
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(medico.disponibleHoy ? 'Solicitar cita' : 'No disponible'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
