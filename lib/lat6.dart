import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Enum for UniversityEvent
enum UniversityEvent { load, countryChanged }

// UniversityBloc class to manage state and fetch universities
class UniversityBloc extends Bloc<UniversityEvent, List<dynamic>> {
  String selectedCountry = 'Indonesia'; // Initialize selectedCountry

  UniversityBloc() : super([]);

  @override
  Stream<List<dynamic>> mapEventToState(UniversityEvent event) async* {
    if (event == UniversityEvent.load ||
        event == UniversityEvent.countryChanged) {
      yield await fetchUniversities(selectedCountry);
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

  void changeCountry(String country) {
    selectedCountry = country; // Update selectedCountry
    add(UniversityEvent.countryChanged);
  }
}

class UniversityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UniversityBloc universityBloc =
        BlocProvider.of<UniversityBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Daftar Universitas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.amber,
      ),
      body: BlocBuilder<UniversityBloc, List<dynamic>>(
        builder: (context, universities) {
          // Access selectedCountry from UniversityBloc
          String selectedCountry =
              context.select((UniversityBloc bloc) => bloc.selectedCountry);

          return Column(
            children: [
              DropdownButton<String>(
                value: selectedCountry,
                onChanged: (String? newValue) {
                  universityBloc.changeCountry(newValue!);
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
          );
        },
      ),
    );
  }
}

void main() {
  runApp(
    BlocProvider(
      create: (context) => UniversityBloc()..add(UniversityEvent.load),
      child: MaterialApp(
        home: UniversityList(),
      ),
    ),
  );
}
