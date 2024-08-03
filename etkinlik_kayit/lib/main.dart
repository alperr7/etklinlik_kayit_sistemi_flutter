import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'event.dart';
import 'registerPage.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Etkinlik Kayıt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventListPage(),
    );
  }
}

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  late Future<List<Event>> futureEvents;

  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents(); // Fetch events from API
  }

  Future<List<Event>> fetchEvents() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/events/'));

    if (response.statusCode == 200) {
      String utf8Response = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(utf8Response);
      return jsonData.map((data) => Event.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Etkinlik Kayıt'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events available'));
          } else {
            return ListView(
              children: snapshot.data!
                  .map((event) => EventCard(event: event))
                  .toList(),
            );
          }
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(event.date);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(event.imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(event.name,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(event.description),
                SizedBox(height: 8),
                Text('Yeri: ${event.location}'),
                Text('Tarih: $formattedDate'), // Formatlanmış tarihi göster
                Text('Kayıtlı Kişi Sayısı: ${event.registeredUsers}'),
                Text('Toplam Kontenjan: ${event.totalSlots}'),
                SizedBox(height: 8),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(
                            eventName: event.name,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Kayıt Ol"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
