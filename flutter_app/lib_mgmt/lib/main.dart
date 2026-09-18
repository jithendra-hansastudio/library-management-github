import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
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
      } else if (decodedData['data'] is Map && decodedData['data']['data'] is List) {
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
      } else if (decodedData['data'] is Map && decodedData['data']['data'] is List) {
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
  int _counter = 0;
  @override
  void initState() {
    super.initState();
    _booksFuture = fetchBooks();
    _authorFuture = fetchAuthors();
  }

  @override
  Widget build(BuildContext context) {

    print(_authorFuture);
    return Scaffold(
      appBar: AppBar(title: const Text('Library Books')),
      body: FutureBuilder<List<dynamic>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books found in MariaDB.'));
          }

          final books = snapshot.data!;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                leading: const Icon(Icons.book),
                title: Hero(
                    tag: index,
                    child: Text(book['book_name'] ?? 'Untitled')),
                subtitle: Text('Author name: ${book['author']['author_name'] ?? 'Unknown'}'),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context)=> DetailScreen(item:book), ),);

                },
              );
            },
          );
        },
      ),
    );

  }
}


class DetailScreen extends StatefulWidget{
  const DetailScreen({super.key, required this.item});
  final Map item;

  @override
  State<DetailScreen> createState() => _DetailScreen();
    }
class _DetailScreen extends State<DetailScreen>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.item['book_name']}'),
      ),
      body: Container(
        alignment: Alignment.bottomCenter,

          child: Center(child:
          Container(
            child: FutureBuilder(
              future: _booksFuture, // Your async function returning Future<String>
              builder: (context, snapshot) {
                return Container(

                  color: Colors.pink.shade50,
                  child: ListView.builder(
                    itemCount: widget.item.length-3,
                    itemBuilder: (context, index) {
                      String key = widget.item.keys.elementAt(index);
                      dynamic value = widget.item[key];

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          subtitle: Text(key.toString()),

                          title: Text(value.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),

                        ),
                      );
                    },
                  )
                );
                // if (snapshot.hasData) {
                //   return Text('{snapshot.data?[widget.item]['']}');
                //   // return Text(snapshot.data[0]['book_name']!); // Display the resolved string
                // } else if (snapshot.hasError) {
                //   return Text('Error: ${snapshot.error}');
                // }
                return CircularProgressIndicator(); // Show loading indicator
              },
            ),
          )   ))
          // Text(
          //     '${dataList[widget.item]}'
          // ))),

    );
  }


}