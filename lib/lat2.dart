import 'package:flutter/material.dart'; // Mengimpor package Flutter untuk mengakses fungsi dan widget dari Flutter.
import 'package:http/http.dart'
    as http; // Mengimpor package http untuk melakukan permintaan HTTP.
import 'dart:convert'; // Mengimpor package untuk mengkonversi JSON.

void main() {
  runApp(
      const MyApp()); // Memulai aplikasi dengan menjalankan MyApp sebagai root widget.
}

// menampung data hasil pemanggilan API
class Activity {
  // Deklarasi kelas Activity.
  String aktivitas; // Variabel untuk menyimpan aktivitas.
  String jenis; // Variabel untuk menyimpan jenis aktivitas.

  Activity({required this.aktivitas, required this.jenis}); //constructor

  //map dari json ke atribut
  factory Activity.fromJson(Map<String, dynamic> json) {
    // Factory method untuk membuat objek Activity dari JSON.
    return Activity(
      aktivitas: json['activity'], // Mengisi variabel aktivitas dari JSON.
      jenis: json['type'], // Mengisi variabel jenis dari JSON.
    );
  }
}

class MyApp extends StatefulWidget {
  // Kelas MyApp sebagai Stateful widget.
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // Membuat state MyApp.
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  // State dari MyApp.
  late Future<Activity>
      futureActivity; // Variabel untuk menampung hasil future dari pemanggilan API.

  String url = "https://www.boredapi.com/api/activity"; // URL endpoint API.

  Future<Activity> init() async {
    // Fungsi untuk inisialisasi futureActivity.
    return Activity(
        aktivitas: "", jenis: ""); // Mengembalikan objek Activity kosong.
  }

  //fetch data
  Future<Activity> fetchData() async {
    // Fungsi untuk mengambil data dari API.
    final response =
        await http.get(Uri.parse(url)); // Permintaan GET ke URL API.
    if (response.statusCode == 200) {
      // Jika permintaan sukses (status code 200),
      // parse json
      return Activity.fromJson(
          jsonDecode(response.body)); // Mengembalikan objek Activity dari JSON.
    } else {
      // Jika gagal,
      // lempar exception
      throw Exception(
          'Gagal load'); // Melemparkan exception dengan pesan 'Gagal load'.
    }
  }

  @override
  void initState() {
    // Metode initState dipanggil saat widget pertama kali dibuat.
    super.initState();
    futureActivity =
        init(); // Menginisialisasi futureActivity dengan hasil dari fungsi init().
  }

  @override
  Widget build(Object context) {
    // Metode untuk membangun tampilan UI.
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity =
                      fetchData(); // Memperbarui futureActivity dengan hasil pemanggilan fetchData().
                });
              },
              child: Text("Saya bosan ..."), // Teks pada tombol.
            ),
          ),
          FutureBuilder<Activity>(
            future: futureActivity, // Future yang akan dipantau.
            builder: (context, snapshot) {
              // Builder untuk membangun UI berdasarkan status future.
              if (snapshot.hasData) {
                // Jika future mengandung data,
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!
                          .aktivitas), // Menampilkan aktivitas dari data future.
                      Text(
                          "Jenis: ${snapshot.data!.jenis}") // Menampilkan jenis aktivitas dari data future.
                    ]));
              } else if (snapshot.hasError) {
                // Jika future mengandung error,
                return Text('${snapshot.error}'); // Menampilkan pesan error.
              }
              // default: loading spinner.
              return const CircularProgressIndicator(); // Menampilkan loading spinner jika future sedang loading.
            },
          ),
        ]),
      ),
    ));
  }
}
