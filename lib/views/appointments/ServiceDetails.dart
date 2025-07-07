import 'package:flutter/material.dart';
import '../../modelo/service/AppointService.dart';
import '../../modelo/beans/Schedule.dart';
import '../../modelo/beans/ScheduleShift.dart';

class ServiceDetails extends StatefulWidget {
  final dynamic caregiver;

  const ServiceDetails({Key? key, required this.caregiver}) : super(key: key);

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
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
                  // Aquí puedes manejar la selección del turno
                  Navigator.of(context).pop();
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