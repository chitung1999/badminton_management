import 'package:badminton_management/provider/filter_provider.dart';
import 'package:badminton_management/provider/data_provider.dart';
import 'package:badminton_management/ui/expense/expense.dart';
import 'package:badminton_management/ui/home/home.dart';
import 'package:badminton_management/ui/receive/receive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/account_provider.dart';
import 'provider/screen_provider.dart';
import 'ui/header/header.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AccountProvider()),
        ChangeNotifierProvider(create: (context) => ScreenProvider()),
        ChangeNotifierProvider(create: (context) => FilterProvider()),
        ChangeNotifierProvider(create: (context) => DataProvider()),
      ],
      child: const TheApp(),
    )
  );
}

class TheApp extends StatelessWidget {
  const TheApp({super.key});
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context, listen: false);
    Future<bool> initialize = data.initialize();

    return MaterialApp(
      title: 'Badminton Management',
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: const HeaderApp(),
          toolbarHeight: 60
        ),
        body: FutureBuilder<bool>(
          future: initialize,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator()
              ));
            } else {
              return Consumer<ScreenProvider>(
                builder: (context, screen, child) {
                  return IndexedStack(
                    index: screen.getIndex(),
                    children: const [
                      Home(),
                      ReceiveScreen(),
                      ExpenseScreen(),
                    ],
                  );
                }
              );
            }
          }
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}