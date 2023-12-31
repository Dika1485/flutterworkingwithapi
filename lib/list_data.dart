import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutterworkingwithapi/side_menu.dart';
import 'package:flutterworkingwithapi/tambah_data.dart';
import 'package:flutterworkingwithapi/edit_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListData extends StatefulWidget {
  const ListData({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  List<Map<String, String>> dataMahasiswa = [];
  String url = Platform.isAndroid
      ? 'http://192.168.1.28/flutterworkingwithapi/index.php'
      : 'http://localhost/flutterworkingwithapi/index.php';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if ((response.statusCode == 200) &&
        response.body != "Data mahasiswa kosong.") {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataMahasiswa = List<Map<String, String>>.from(data.map((item) {
          return {
            'nama': item['nama'] as String,
            'jurusan': item['jurusan'] as String,
            'id': item['id'] as String,
          };
        }));
      });
    }
  }

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('List Data Mahasiswa'),
        ),
        drawer: const SideMenu(),
        body: Column(children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TambahData(),
                ),
              );
            },
            child: const Text('Tambah Data Mahasiswa'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataMahasiswa.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dataMahasiswa[index]['nama']!),
                  subtitle: Text('Jurusan: ${dataMahasiswa[index]['jurusan']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          //lihatMahasiswa(index);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title:
                                        Text('${dataMahasiswa[index]['nama']}'),
                                    content: Text(
                                        'Jurusan : ${dataMahasiswa[index]['jurusan']}')
                                    // actions: [
                                    //   TextButton(
                                    //     child: const Text('OK'),
                                    //     onPressed: () {
                                    //       Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               const HomePage(),
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    //   ],
                                    );
                              });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          //editMahasiswa(index);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditData(
                                      id: int.parse(
                                          dataMahasiswa[index]['id']!),
                                      nama: '${dataMahasiswa[index]['nama']}',
                                      jurusan:
                                          '${dataMahasiswa[index]['jurusan']}')));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteData(int.parse(dataMahasiswa[index]['id']!))
                              .then((result) {
                            if (result['pesan'] == 'berhasil') {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Data berhasil dihapus'),
                                      // content: const Text('ok'),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.pushReplacement(
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
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ]));
  }
}
