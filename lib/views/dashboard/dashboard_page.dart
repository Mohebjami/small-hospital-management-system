import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital/views/appointments/appointments_page.dart';
import 'package:hospital/views/auth/login_page.dart';
import 'package:hospital/views/doctor_panel/doctor_panel_page.dart';
import 'package:hospital/views/doctors/doctors_page.dart';
import 'package:hospital/views/patients/patients_page.dart';
import 'package:hospital/views/pharmacy/pharmacy_page.dart';
import 'package:hospital/views/reports/reports_page.dart';
import '../../controllers/auth_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final auth = Get.find<AuthController>();
  int selectedIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      _homeView(),
      DoctorsPage(),
      PatientsPage(),
      DoctorPanelPage(),
      PharmacyPage(),
      AppointmentsPage(),
      ReportsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Row(
        children: [
          /// SIDE NAVIGATION
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: 250,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
            
                  /// LOGO / HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.local_hospital,
                          color: Colors.teal, size: 32),
                      SizedBox(width: 8),
                      Text(
                        "Hospital",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
            
                  const SizedBox(height: 30),
            
                  /// USER INFO
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text(
                        auth.currentUser.value?.username
                                .substring(0, 1)
                                .toUpperCase() ??
                            'U',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      auth.currentUser.value?.username ?? "User",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text("Hospital Staff"),
                  ),
            
                  const Divider(),
            
                  /// MENU ITEMS
                  Expanded(
                    child: ListView(
                      children: [
                        _navItem(Icons.home, "Home", 0),
                        _navItem(Icons.person, "Doctors", 1),
                        _navItem(Icons.people, "Patients", 2),
                        _navItem(Icons.medical_services, "Doctor Panel", 3),
                        _navItem(Icons.local_pharmacy, "Pharmacy", 4),
                        _navItem(Icons.event, "Appointments", 5),
                        _navItem(Icons.bar_chart, "Reports", 6),
                      ],
                    ),
                  ),
            
                  /// LOGOUT
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text("Logout"),
                    onTap: () {
                      Get.offAll(LoginPage());
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          /// PAGE CONTENT
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: pages[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  /// Navigation Tile Widget
  Widget _navItem(IconData icon, String title, int index) {
    final isSelected = selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.teal : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.teal : Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? Colors.teal.withValues(alpha: 0.1) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () => setState(() => selectedIndex = index),
    );
  }

  /// Home Dashboard
  Widget _homeView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome, ${auth.currentUser.value?.username}",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Hospital Management Dashboard",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),

          /// QUICK STATS
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _infoCard("Doctors", Icons.person, Colors.blue),
              _infoCard("Patients", Icons.people, Colors.green),
              _infoCard("Appointments", Icons.event, Colors.orange),
              _infoCard("Reports", Icons.bar_chart, Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, IconData icon, Color color) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 15),
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          const Text("Overview data",
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}