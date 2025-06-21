import 'package:flutter/material.dart';
import 'package:safechild/modelo/service/AppointService.dart';

import 'ServiceDetails.dart';

class ServiceList extends StatelessWidget {
  final List<dynamic> serviceList;
  final Map<int, List<dynamic>> schedules;
  final void Function(int caregiverId) onServiceTap;

  const ServiceList({
    Key? key,
    required this.serviceList,
    required this.schedules,
    required this.onServiceTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: FutureBuilder(
        initialData: [],
        future: AppointService.getCaregivers(),
        builder: (context, AsyncSnapshot<List> snapshot){
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index){
                var caregiver = snapshot.data![index];
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
                          Text('Distrito: ${caregiver.districtScope}'),
                        ],
                      ),
                    ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetails(caregiver: caregiver),
                          ),
                        );
                      },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                );
              });
        },
      ),
    );
  }
}