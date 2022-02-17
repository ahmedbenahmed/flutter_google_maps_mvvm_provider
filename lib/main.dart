import 'package:flutter/material.dart';
import 'package:flutter_google_maps/screens/home_page.dart';
import 'package:flutter_google_maps/viewmodels/place_list_view_model.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
          create: (_) => PlaceListViewModel(), child: HomePage()),
    );
  }
}
