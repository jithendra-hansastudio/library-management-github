import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lib_mgmt_task/books.dart';
import 'config/api_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library app',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

Future<List<dynamic>> fetchDesign() async {
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/settings'),
    headers: {'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    // Decode response into a dynamic variable
    final dynamic decodedData = jsonDecode(response.body);

    // If Laravel returned a raw JSON List: [...]
    if (decodedData is List) {
      return decodedData;
    }
    // If Laravel returned a wrapped object: {"status": "success", "data": [...]}
    else if (decodedData is Map<String, dynamic>) {
      if (decodedData['data'] is List) {
        return decodedData['data'];
      } else if (decodedData['data'] is Map &&
          decodedData['data']['data'] is List) {
        // Handles Laravel pagination objects
        return decodedData['data']['data'];
      }
    }

    return [];
  } else {
    throw Exception('Failed to load books: ${response.statusCode}');
  }
}

Future<List<dynamic>> _DesignFuture = fetchDesign();

Future<List<dynamic>> fetchBooks() async {
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/books'),
    headers: {'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    // Decode response into a dynamic variable
    final dynamic decodedData = jsonDecode(response.body);

    // If Laravel returned a raw JSON List: [...]
    if (decodedData is List) {
      return decodedData;
    }
    // If Laravel returned a wrapped object: {"status": "success", "data": [...]}
    else if (decodedData is Map<String, dynamic>) {
      if (decodedData['data'] is List) {
        return decodedData['data'];
      } else if (decodedData['data'] is Map &&
          decodedData['data']['data'] is List) {
        // Handles Laravel pagination objects
        return decodedData['data']['data'];
      }
    }
    return [];
  } else {
    throw Exception('Failed to load books: ${response.statusCode}');
  }
}

Future<List<dynamic>> _booksFuture = fetchBooks();

Future<List<dynamic>> fetchAuthors() async {
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/authors'),
    headers: {'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    // Decode response into a dynamic variable
    final dynamic decodedData = jsonDecode(response.body);
    print(decodedData);

    // If Laravel returned a raw JSON List: [...]
    if (decodedData is List) {
      return decodedData;
    }
    // If Laravel returned a wrapped object: {"status": "success", "data": [...]}
    else if (decodedData is Map<String, dynamic>) {
      if (decodedData['data'] is List) {
        return decodedData['data'];
      } else if (decodedData['data'] is Map &&
          decodedData['data']['data'] is List) {
        // Handles Laravel pagination objects
        return decodedData['data']['data'];
      }
    }

    return [];
  } else {
    throw Exception('Failed to load books: ${response.statusCode}');
  }
}

Future<List<dynamic>> _authorFuture = fetchAuthors();

// _booksFuture = fetchBooks();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _booksFuture = fetchBooks();
    _authorFuture = fetchAuthors();
    _DesignFuture = fetchDesign();
  }

  @override
  Widget build(BuildContext context) {
    _DesignFuture;
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusGeometry.circular(10),
                color: Colors.red.shade50
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 40,

                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: .5),

                        shape:  RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15))

                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (BooksScreen(title: 'Books')),
                          ),
                        );
                      },
                      child: Text('Go to Books Catalog'),
                    ),
                  ),
                  Container(height: 30,)
                ],
              ),
            ),
            Container(height: 30,),
            Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  color: Colors.red.shade50
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 40,

                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(width: .5),

                          shape:  RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15))

                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (BooksScreen(title: 'Books')),
                          ),
                        );
                      },
                      child: Text('Go to Books Catalog'),
                    ),
                  ),
                  Container(height: 30,)
                ],
              ),
            ),
            Container(height: 30,),

            Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  color: Colors.red.shade50
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 40,

                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(width: .5),

                          shape:  RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15))

                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (BooksScreen(title: 'Books')),
                          ),
                        );
                      },
                      child: Text('Go to Books Catalog'),
                    ),
                  ),
                  Container(height: 30,)
                ],
              ),
            ),
            Container(height: 30,),

            Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  color: Colors.red.shade50
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 40,

                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(width: .5),

                          shape:  RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15))

                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (BooksScreen(title: 'Books')),
                          ),
                        );
                      },
                      child: Text('Go to Books Catalog'),
                    ),
                  ),
                  Container(height: 30,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
