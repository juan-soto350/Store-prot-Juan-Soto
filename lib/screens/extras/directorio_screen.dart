import '../../models/medico.dart';
import 'package:flutter/material.dart';
import 'detalle_medico_screen.dart';

class DirectorioScreen extends StatefulWidget {
  const DirectorioScreen({super.key});

  @override
  State<DirectorioScreen> createState() => _DirectorioScreenState();
}

class _DirectorioScreenState extends State<DirectorioScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _mostrarSoloDisponibles = false;

  final List<Medico> _medicos = [
    Medico(
      id: '1',
      nombre: 'Juan Soto',
      especialidad: 'Médico General',
      anosExperiencia: '20',
      precioConsulta: '3000 Dólares',
      disponibleHoy: false,
      consultorio: 'Consultorio 101',
      ubicacion: 'Centro Médico La Esperanza',
      descripcion: 'Médico general con amplia experiencia en atención primaria, consultas de seguimiento y prevención de enfermedades.',
    ),
    Medico(
      id: '2',
      nombre: 'Hanna Aguirre',
      especialidad: 'Cirugía, Neurocirugía, Ortodoncia',
      anosExperiencia: '25',
      precioConsulta: '6000 Dólares',
      disponibleHoy: true,
      consultorio: 'Consultorio 203',
      ubicacion: 'Clínica San José',
      descripcion: 'Especialista en neurocirugía y ortodoncia con más de 25 años de práctica en procedimientos complejos y cuidado integral.',
    ),
    Medico(
      id: '3',
      nombre: 'Santiago Pastrosa',
      especialidad: 'Psicología',
      anosExperiencia: '10',
      precioConsulta: '1500 Dólares',
      disponibleHoy: false,
      consultorio: 'Consultorio 304',
      ubicacion: 'Centro Psicológico Vida Sana',
      descripcion: 'Psicólogo clínico orientado a terapias individuales y grupales con foco en bienestar emocional y manejo del estrés.',
    ),
    Medico(
      id: '4',
      nombre: 'Kerry Gonzales',
      especialidad: 'Pediatría',
      anosExperiencia: '5',
      precioConsulta: '1000 Dólares',
      disponibleHoy: true,
      consultorio: 'Consultorio 402',
      ubicacion: 'Hospital Infantil Luz',
      descripcion: 'Pediatra con trato amable y cuidado especial para pacientes infantiles, vacunación y seguimiento de crecimiento.',
    ),
    Medico(
      id: '5',
      nombre: 'Anderson Gomez',
      especialidad: 'Cirugía Plástica',
      anosExperiencia: '40',
      precioConsulta: '6000 Dólares',
      disponibleHoy: true,
      consultorio: 'Consultorio 502',
      ubicacion: 'Clínica Bella',
      descripcion: 'Cirujano plástico con décadas de experiencia en reconstrucción y procedimientos estéticos seguros y personalizados.',
    ),
  ];

  List<Medico> get _medicosFiltrados {
    final query = _searchController.text.toLowerCase().trim();
    return _medicos.where((medico) {
      final nombre = medico.nombre.toLowerCase();
      final especialidad = medico.especialidad.toLowerCase();
      final disponible = !_mostrarSoloDisponibles || medico.disponibleHoy;
      final coincide = query.isEmpty || nombre.contains(query) || especialidad.contains(query);
      return coincide && disponible;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicos = _medicosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Directorio Médico'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              Material(
                elevation: 2,
                shadowColor: Colors.black12,
                borderRadius: BorderRadius.circular(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Buscar médico, especialidad o ubicación',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  FilterChip(
                    label: const Text('Solo disponibles hoy'),
                    selected: _mostrarSoloDisponibles,
                    selectedColor: Colors.indigo.shade100,
                    labelStyle: TextStyle(color: _mostrarSoloDisponibles ? Colors.indigo.shade900 : Colors.black87),
                    backgroundColor: Colors.grey.shade200,
                    onSelected: (value) => setState(() => _mostrarSoloDisponibles = value),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${medicos.length} médicos encontrados',
                      textAlign: TextAlign.end,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: medicos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.search_off, size: 56, color: Colors.indigo),
                            SizedBox(height: 12),
                            Text('No se encontró ningún médico.', style: TextStyle(fontSize: 16, color: Colors.black54)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: medicos.length,
                        itemBuilder: (context, index) {
                          final item = medicos[index];
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            margin: const EdgeInsets.only(bottom: 14),
                            elevation: 3,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => DetalleScreen(medico: item)),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundColor: Colors.indigo.shade50,
                                          child: Text(
                                            item.nombre
                                                .split(' ')
                                                .map((p) => p.isNotEmpty ? p[0] : '')
                                                .take(2)
                                                .join(),
                                            style: const TextStyle(fontSize: 18, color: Colors.indigo),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(item.nombre, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 4),
                                              Text(item.especialidad, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                                            ],
                                          ),
                                        ),
                                        Chip(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          label: Text(item.disponibleHoy ? 'Disponible' : 'No disponible'),
                                          backgroundColor: item.disponibleHoy ? Colors.green.shade100 : Colors.grey.shade300,
                                          labelStyle: TextStyle(color: item.disponibleHoy ? Colors.green.shade900 : Colors.black87),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 8,
                                      children: [
                                        _DataChip(icon: Icons.work_outline, label: '${item.anosExperiencia} años'),
                                        _DataChip(icon: Icons.location_on_outlined, label: item.consultorio),
                                        _DataChip(icon: Icons.price_check, label: item.precioConsulta),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(item.ubicacion, style: const TextStyle(color: Colors.black54, fontSize: 14)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DataChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.indigo),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87))
        ],
      ),
    );
  }
}
