import 'package:flutter/material.dart';

import '../../models/schedule.dart';
import '../../models/scheduleShift.dart';
import '../../services/appoint_service.dart';

class ScheduleDetailsPage extends StatefulWidget {
  final dynamic caregiver;

  const ScheduleDetailsPage({Key? key, required this.caregiver}) : super(key: key);

  @override
  State<ScheduleDetailsPage> createState() => _ScheduleDetailsPageState();
}

class _ScheduleDetailsPageState extends State<ScheduleDetailsPage> {

  Future<void> _showDaysDialog(BuildContext context) async {
    final schedules = await AppointService().getSchedulesByCaregiverId(widget.caregiver.id);
    if (schedules.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Horarios disponibles'),
          content: Text('No hay horarios disponibles.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecciona un día'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: schedules.map((schedule) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ElevatedButton(
                  child: Text(schedule.availableDate),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showShiftsDialog(context, schedule);
                  },
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showShiftsDialog(BuildContext context, Schedule schedule) {
    final List<ScheduleShift> availableShifts = (schedule.scheduleShifts as List)
        .where((shift) => (shift as ScheduleShift).available)
        .cast<ScheduleShift>()
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Turnos disponibles para ${schedule.availableDate}'),
        content: availableShifts.isEmpty
            ? const Text('No hay turnos disponibles para este día.')
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: availableShifts.map<Widget>((shift) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ElevatedButton(
                child: Text(shift.shift),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showTimeInputDialog(context, schedule, shift);
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showTimeInputDialog(BuildContext context, Schedule schedule, ScheduleShift shift) {
    final startController = TextEditingController();
    final endController = TextEditingController();
    String? errorText; // Declarar aquí

    // Definir rangos según el turno
    TimeOfDay minTime, maxTime;
    switch (shift.shift) {
      case 'MORNING':
        minTime = const TimeOfDay(hour: 6, minute: 0);
        maxTime = const TimeOfDay(hour: 11, minute: 0);
        break;
      case 'AFTERNOON':
        minTime = const TimeOfDay(hour: 12, minute: 0);
        maxTime = const TimeOfDay(hour: 17, minute: 0);
        break;
      case 'EVENING':
        minTime = const TimeOfDay(hour: 18, minute: 0);
        maxTime = const TimeOfDay(hour: 23, minute: 0);
        break;
      default:
        minTime = const TimeOfDay(hour: 0, minute: 0);
        maxTime = const TimeOfDay(hour: 23, minute: 59);
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          void validateAndSubmit() {
            final startText = startController.text;
            final endText = endController.text;

            try {
              final start = TimeOfDay(
                hour: int.parse(startText.split(':')[0]),
                minute: int.parse(startText.split(':')[1]),
              );
              final end = TimeOfDay(
                hour: int.parse(endText.split(':')[0]),
                minute: int.parse(endText.split(':')[1]),
              );

              // Validar que los minutos sean 00
              if (start.minute != 0 || end.minute != 0) {
                setState(() {
                  errorText = 'Solo se permiten horas en punto (minutos 00).';
                });
                return;
              }

              bool inRange(TimeOfDay t) =>
                  (t.hour > minTime.hour || (t.hour == minTime.hour && t.minute >= minTime.minute)) &&
                      (t.hour < maxTime.hour || (t.hour == maxTime.hour && t.minute <= maxTime.minute));

              if (!inRange(start) || !inRange(end)) {
                setState(() {
                  errorText = 'Las horas deben estar dentro del turno seleccionado.';
                });
              } else {
                final startMinutes = start.hour * 60 + start.minute;
                final endMinutes = end.hour * 60 + end.minute;
                if (endMinutes - startMinutes < 60) {
                  setState(() {
                    errorText = 'La diferencia debe ser de al menos 1 hora.';
                  });
                } else if (endMinutes <= startMinutes) {
                  setState(() {
                    errorText = 'La hora de fin debe ser mayor a la de inicio.';
                  });
                } else {
                  Navigator.of(context).pop();
                  // Aquí puedes continuar con el POST de la reserva
                }
              }
            } catch (e) {
              setState(() {
                errorText = 'Formato de hora inválido. Usa HH:mm';
              });
            }
          }

          return AlertDialog(
            title: Text('Ingrese hora de inicio y fin (${shift.shift})'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: startController,
                  decoration: const InputDecoration(labelText: 'Hora de inicio (HH:mm)'),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: endController,
                  decoration: const InputDecoration(labelText: 'Hora de fin (HH:mm)'),
                  keyboardType: TextInputType.datetime,
                ),
                if (errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(errorText!, style: const TextStyle(color: Colors.red)),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: validateAndSubmit,
                child: const Text('Reservar'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final caregiver = widget.caregiver;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Cuidador')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              margin: const EdgeInsets.all(20),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 32,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          caregiver.completeName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28, thickness: 1.2),
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.teal),
                      title: Text('Dirección'),
                      subtitle: Text(caregiver.address),
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      leading: const Icon(Icons.star, color: Colors.orange),
                      title: Text('Experiencia'),
                      subtitle: Text('${caregiver.caregiverExperience} años'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text('Servicios completados'),
                      subtitle: Text('${caregiver.completedServices}'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.attach_money,
                        color: Colors.purple,
                      ),
                      title: Text('Tarifa por hora'),
                      subtitle: Text('S/. ${caregiver.farePerHour}'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.info_outline,
                        color: Colors.blueGrey,
                      ),
                      title: Text('Biografía'),
                      subtitle: Text(caregiver.biography),
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      leading: const Icon(Icons.map, color: Colors.redAccent),
                      title: Text('Distritos'),
                      subtitle: Text(caregiver.districtsScope),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.schedule),
              label: const Text('Ver horarios'),
              onPressed: () => _showDaysDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
