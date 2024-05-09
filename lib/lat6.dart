import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class UniversityEvent {}

class FetchUniversitiesEvent extends UniversityEvent {
  final String country;
  FetchUniversitiesEvent(this.country);
}

class UniversityBloc extends Bloc<UniversityEvent, List<dynamic>> {
  UniversityBloc() : super([]) {
    on<FetchUniversitiesEvent>(_onFetchUniversities);
  }

  void _onFetchUniversities(
      FetchUniversitiesEvent event, Emitter<List<dynamic>> emit) async {
    try {
      final universities = await fetchUniversities(event.country);
      emit(universities);
    } catch (error) {
      // Handle error
    }
  }

  Future<List<dynamic>> fetchUniversities(String country) async {
    final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=$country'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load universities');
    }
  }
}

class UniversityList extends StatelessWidget {
  final List<String> aseanCountries = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Daftar Universitas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.amber,
      ),
      body: BlocBuilder<UniversityBloc, List<dynamic>>(
        builder: (context, universities) {
          return Container(
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
                  value: 'Indonesia', // Default value
                  onChanged: (String? newValue) {
                    context
                        .read<UniversityBloc>()
                        .add(FetchUniversitiesEvent(newValue!));
                  },
                  items: aseanCountries
                      .map<DropdownMenuItem<String>>((String value) {
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BlocProvider(
      create: (_) => UniversityBloc()
        ..add(FetchUniversitiesEvent('Indonesia')), // Default country
      child: UniversityList(),
    ),
  ));
}
