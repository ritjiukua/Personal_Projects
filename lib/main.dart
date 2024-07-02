import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'quote_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'affirmations_page.dart'; // Adjust this import based on your project structure

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key); // Corrected constructor

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String> futureRandomQuote;
  late Future<String> futureTodayQuote;

  @override
  void initState() {
    super.initState();
    futureRandomQuote = QuoteService().fetchRandomQuote();
    futureTodayQuote = QuoteService().fetchTodayQuote();
  }

  void _reloadRandomQuote() {
    setState(() {
      futureRandomQuote = QuoteService().fetchRandomQuote();
    });
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final TextStyle quoteTextStyle = GoogleFonts.greatVibes(
      fontSize: 36,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );
    final List<Widget> pages = [
      Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white10, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: 300,
                  child: FutureBuilder<String>(
                    future: futureRandomQuote,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text(
                          snapshot.data ?? 'No quote available',
                          textAlign: TextAlign.center,
                          style: quoteTextStyle,
                        );
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              IconButton(
                icon: Icon(Icons.refresh),
                color: Colors.blue,
                iconSize: 30,
                onPressed: _reloadRandomQuote,
              ),
            ],
          ),
        ),
      ),
      AffirmationsPage(),
    ];

    return MaterialApp(
      home: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.white,
          fixedColor: Colors.blue,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.health_and_safety_rounded), label: "Motivation"),
            BottomNavigationBarItem(icon: Icon(Icons.notes), label: "Notes"),
          ],
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
