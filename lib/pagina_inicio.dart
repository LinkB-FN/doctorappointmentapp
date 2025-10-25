import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart';

class PaginaInicio extends StatefulWidget {
  const PaginaInicio({super.key});

  @override
  State<PaginaInicio> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeBody(),
    MessagesBody(),
    SettingsBody(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mensajes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio"),
        automaticallyImplyLeading: false,
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "¡Hola, $userName! ¿En qué podemos ayudarte?",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        // Navigate to schedule appointment
                        Navigator.pushNamed(context, Routes.appointment);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.calendar_today, size: 48),
                            SizedBox(height: 8),
                            Text('Agendar una Cita'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        // Navigate to medical tips
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Consejos Médicos')),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.lightbulb, size: 48),
                            SizedBox(height: 8),
                            Text('Consejos médicos'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Especialistas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  SpecialistCard(name: 'Cardiólogo'),
                  SpecialistCard(name: 'Dermatólogo'),
                  SpecialistCard(name: 'Pediatra'),
                  SpecialistCard(name: 'Ginecólogo'),
                  SpecialistCard(name: 'Oftalmólogo'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Doctores Populares',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const DoctorCard(name: 'Dr. Juan Pérez', specialty: 'Cardiólogo'),
            const DoctorCard(name: 'Dra. María López', specialty: 'Dermatóloga'),
          ],
        ),
      ),
    );
  }
}

class SpecialistCard extends StatelessWidget {
  const SpecialistCard({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(name, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.name, required this.specialty});

  final String name;
  final String specialty;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(name),
        subtitle: Text(specialty),
      ),
    );
  }
}

class MessagesBody extends StatelessWidget {
  const MessagesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Mensajes'),
      ),
    );
  }
}

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pushNamed(context, Routes.profile);
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacidad'),
            onTap: () {
              Navigator.pushNamed(context, Routes.privacy);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre nosotros'),
            onTap: () {
              Navigator.pushNamed(context, Routes.aboutus);
            },
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('Admin'),
            onTap: () {
              Navigator.pushNamed(context, Routes.admin);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, Routes.login);
            },
          ),
        ],
      ),
    );
  }
}
