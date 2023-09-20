import 'dart:convert';
import 'dart:io';
import 'package:flutterworkingwithapi/list_data.dart';
import 'package:flutterworkingwithapi/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);
  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final jurusanController = TextEditingController();
  Future postData(String nama, String jurusan) async {
    // print(nama);
    String url = Platform.isAndroid
        ? 'http://192.168.1.28/flutterworkingwithapi/index.php'
        : 'http://localhost/flutterworkingwithapi/index.php';
    //String url = 'http://127.0.0.1/apiTrash/prosesLoginDriver.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"nama": "$nama", "jurusan": "$jurusan"}';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add data');
    }
  }

  _buatInput(control, String hint) {
    return TextFormField(
      controller: control,
      decoration: InputDecoration(
        hintText: hint,
      ),
      validator: (String? value) {
        return (value == null || value.isEmpty)
            ? "Please enter some text"
            : null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Data Mahasiswa'),
        ),
        drawer: const SideMenu(),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buatInput(namaController, 'Masukkan Nama Mahasiswa'),
                _buatInput(jurusanController, 'Masukkan Nama Jurusan'),
                ElevatedButton(
                  child: const Text('Tambah Mahasiswa'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String nama = namaController.text;
                      String jurusan = jurusanController.text;
                      // print(nama);
                      postData(nama, jurusan).then((result) {
                        //print(result['pesan']);
                        if (result['pesan'] == 'berhasil') {
                          showDialog(
                              context: context,
                              builder: (context) {
                                //var namauser2 = namauser;
                                return AlertDialog(
                                  title: const Text('Data berhasil ditambah'),
                                  // content: const Text('ok'),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ListData(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                        setState(() {});
                      });
                    }
                  },
                ),
              ],
              // Tugas Kelompok • Lanjutkan untuk delete data, edit data, dan rea
            ),
          ),
        ));
  }
}
