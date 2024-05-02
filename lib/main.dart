import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MataKuliah {
  final String kode;
  final String nama;
  final int sks;
  final String nilai;

  MataKuliah({
    required this.kode,
    required this.nama,
    required this.sks,
    required this.nilai,
  });

  factory MataKuliah.fromJson(Map<String, dynamic> json) {
    return MataKuliah(
      kode: json['kode'],
      nama: json['nama'],
      sks: json['sks'],
      nilai: json['nilai'],
    );
  }
}

class TranskripMahasiswa {
  final String nama;
  final String npm;
  final String programStudi;
  final List<MataKuliah> mataKuliah;

  TranskripMahasiswa({
    required this.nama,
    required this.npm,
    required this.programStudi,
    required this.mataKuliah,
  });

  factory TranskripMahasiswa.fromJson(Map<String, dynamic> json) {
    List<dynamic> mataKuliahJson = json['matkul'];
    List<MataKuliah> mataKuliahList =
        mataKuliahJson.map((item) => MataKuliah.fromJson(item)).toList();

    return TranskripMahasiswa(
      nama: json['nama'],
      npm: json['npm'],
      programStudi: json['prodi'],
      mataKuliah: mataKuliahList,
    );
  }
}

double hitungIPK(List<MataKuliah> mataKuliah) {
  double totalSks = 0;
  double totalBobot = 0;

  for (var matkul in mataKuliah) {
    double sks = matkul.sks.toDouble();
    String nilai = matkul.nilai;
    double bobot;

    if (nilai == 'A') {
      bobot = 4.0;
    } else if (nilai == 'A-') {
      bobot = 3.7;
    } else if (nilai == 'B+') {
      bobot = 3.3;
    } else if (nilai == 'B') {
      bobot = 3.0;
    } else if (nilai == 'B-') {
      bobot = 2.7;
    } else if (nilai == 'C+') {
      bobot = 2.3;
    } else if (nilai == 'C') {
      bobot = 2.0;
    } else if (nilai == 'C-') {
      bobot = 1.7;
    } else if (nilai == 'D+') {
      bobot = 1.3;
    } else if (nilai == 'D') {
      bobot = 1.0;
    } else {
      bobot = 0.0;
    }

    totalSks += sks;
    totalBobot += sks * bobot;
  }

  return totalBobot / totalSks;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late TranskripMahasiswa transkripMahasiswa;

  @override
  void initState() {
    super.initState();

    String jsonString = '''
    {
      "nama": "Deva Elmada R",
      "npm": "22082010004",
      "prodi": "Sistem Informasi",
      "matkul": [
        {
          "kode": "pengmob",
          "nama": "Pemrograman Mobile",
          "sks": 3,
          "nilai": "A"
        },
        {
          "kode": "PKTI",
          "nama": "Pengukuran Kinerja Teknologi Informasi",
          "sks": 3,
          "nilai": "A"
        },
        {
          "kode": "statkom",
          "nama": "Statitiska Komputasi",
          "sks": 3,
          "nilai": "A"
        },
        {
          "kode": "kecpri",
          "nama": "Kecakapan Pribadi",
          "sks": 3,
          "nilai": "A"
        },
        {
          "kode": "ebuss",
          "nama": "E-Bussiness",
          "sks": 3,
          "nilai": "A"
        },
        {
          "kode": "pengweb",
          "nama": "Pemrograman Websites",
          "sks": 3,
          "nilai": "A"
        }
      ]
    }
    ''';

    Map<String, dynamic> jsonMap = json.decode(jsonString);
    transkripMahasiswa = TranskripMahasiswa.fromJson(jsonMap);
  }

  @override
  Widget build(Object context) {
    double ipk = hitungIPK(transkripMahasiswa.mataKuliah);

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hitung IPK Mahasiswa'),
          backgroundColor: Colors.amber,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Nama: ${transkripMahasiswa.nama}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('NPM\: ${transkripMahasiswa.npm}',
                  style: TextStyle(fontSize: 16)),
              Text(
                'Program Studi: ${transkripMahasiswa.programStudi}',
                style: TextStyle(fontSize: 16),
              ),
              Text('IPK: ${ipk.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: transkripMahasiswa.mataKuliah.length,
                  itemBuilder: (context, index) {
                    MataKuliah matkul = transkripMahasiswa.mataKuliah[index];
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Kode: ${matkul.kode}',
                                style: TextStyle(fontSize: 16)),
                            Text('Nama: ${matkul.nama}',
                                style: TextStyle(fontSize: 16)),
                            Text('SKS: ${matkul.sks}',
                                style: TextStyle(fontSize: 16)),
                            Text('Nilai: ${matkul.nilai}',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
