import 'package:flutter/material.dart';

class ServiceDetails extends StatelessWidget {
  final dynamic caregiver;

  const ServiceDetails({Key? key, required this.caregiver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Cuidador')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, size: 32, color: Colors.blueAccent),
                    const SizedBox(width: 12),
                    Text(
                      caregiver.completeName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text('Servicios completados'),
                  subtitle: Text('${caregiver.completedServices}'),
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  leading: const Icon(Icons.attach_money, color: Colors.purple),
                  title: Text('Tarifa por hora'),
                  subtitle: Text('S/. ${caregiver.farePerHour}'),
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.blueGrey),
                  title: Text('Biografía'),
                  subtitle: Text(caregiver.biography),
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  leading: const Icon(Icons.map, color: Colors.redAccent),
                  title: Text('Distritos'),
                  subtitle: Text(caregiver.districtScope),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}