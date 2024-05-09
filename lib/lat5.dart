import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Enum for UniversityEvent
enum UniversityEvent { load, countryChanged }

// UniversityCubit class to manage state and fetch universities
class UniversityCubit extends Cubit<List<dynamic>> {
  String selectedCountry = 'Indonesia'; // Initialize selectedCountry

  UniversityCubit() : super([]);

  void fetchUniversities(String country) async {
    final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=$country'));

    if (response.statusCode == 200) {
      emit(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load universities');
    }
  }

  void changeCountry(String country) {
    selectedCountry = country; // Update selectedCountry
    fetchUniversities(country);
  }
}

class UniversityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Daftar Universitas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.amber,
      ),
      body: BlocBuilder<UniversityCubit, List<dynamic>>(
        builder: (context, universities) {
          // Access selectedCountry from UniversityCubit
          String selectedCountry =
              context.select((UniversityCubit cubit) => cubit.selectedCountry);

          return Column(
            children: [
              DropdownButton<String>(
                value: selectedCountry,
                onChanged: (String? newValue) {
                  context.read<UniversityCubit>().changeCountry(newValue!);
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
      create: (context) => UniversityCubit(),
      child: MaterialApp(
        home: UniversityList(),
      ),
    ),
  );
}
