import 'package:flutter/material.dart';
import 'package:safechild/views/appointments/ScheduleDetailsPage.dart';

import '../../services/appoint_service.dart';

class SchedulesListPage extends StatelessWidget {

  const SchedulesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        initialData: [],
        future: AppointService.getCaregivers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null || (snapshot.data as List).isEmpty) {
            print('Datos recibidos en snapshot: ${snapshot.data}');
            return Center(child: Text('No hay datos disponibles.'));
          }
          final caregivers = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 16),
                child: Center(
                  child: Text(
                    'Lista de cuidadores disponibles',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: caregivers.length,
                  itemBuilder: (context, index) {
                    var caregiver = caregivers[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.person, color: Colors.blue, size: 28),
                          radius: 28,
                        ),
                        title: Text(
                          caregiver.completeName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dirección: ${caregiver.address}'),
                              Text('Servicios completados: ${caregiver.completedServices}'),
                              Text('Distrito: ${caregiver.districtsScope}'),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScheduleDetailsPage(caregiver: caregiver),
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}