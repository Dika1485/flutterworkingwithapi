import 'package:flutterworkingwithapi/home_page.dart';
import 'package:flutterworkingwithapi/list_data.dart';
import 'package:flutterworkingwithapi/login_page.dart';
import 'package:flutterworkingwithapi/splash.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      const DrawerHeader(
        child: Text('Menu Aplikasi'),
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text('Home'),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Data Mahasiswa'),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ListData(),
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Logout'),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Anda Berhasil Logout'),
                  // content: Text(namauser2),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                );
              });
        },
      ),
    ]));
  }
}
