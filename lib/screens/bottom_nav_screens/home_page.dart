import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'clinic_management.dart';
import 'patient_management.dart';
import 'user_management.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home-page';
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Drawer(
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    context.go(UserManagement.routeName);
                  },
                  child: Text(UserManagement.routeName),
                ),
                TextButton(
                  onPressed: () {
                    context.go(PatientManagement.routeName);
                  },
                  child: Text(PatientManagement.routeName),
                ),
                TextButton(
                  onPressed: () {
                    context.go(ClinicManagement.routeName);
                  },
                  child: Text(ClinicManagement.routeName),
                ),
              ],
            ),
          ),
          Expanded(child: Center(child: child)),
        ],
      ),
    );
  }
}
