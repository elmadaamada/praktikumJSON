import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UniversityList extends StatefulWidget {
  @override
  _UniversityListState createState() => _UniversityListState();
}

class _UniversityListState extends State<UniversityList> {
  List universities = []; // List untuk menyimpan data universitas
  String selectedCountry = 'Indonesia'; // Negara ASEAN default

  // Fungsi untuk mengambil data universitas dari API berdasarkan negara
  Future<void> _fetchUniversities(String country) async {
    final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=$country'));

    if (response.statusCode == 200) {
      // Memeriksa status code response
      setState(() {
        universities = jsonDecode(response
            .body); // Mengupdate state universities dengan data dari API
      });
    } else {
      throw Exception(
          'Failed to load universities'); // Melempar exception jika gagal mengambil data
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUniversities(
        selectedCountry); // Memanggil fungsi _fetchUniversities saat widget pertama kali dibuat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Daftar Universitas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 240, 249, 196),
              Color.fromARGB(255, 240, 249, 196)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedCountry,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCountry = newValue!;
                  _fetchUniversities(selectedCountry);
                });
              },
              items: <String>[
                'Indonesia',
                'Singapore',
                'Malaysia',
                'Thailand',
                'Vietnam',
                'Philippines',
                'Myanmar',
                'Cambodia',
                'Laos',
                'Brunei'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: universities.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        String url = universities[index]['web_pages'][0];
                        // Buka URL situs web universitas
                      },
                      child: ListTile(
                        title: Text(
                          universities[index]['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        subtitle: Text(
                          universities[index]['web_pages'][0],
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UniversityList(),
  ));
}
