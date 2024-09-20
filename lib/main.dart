import 'package:badminton_management/database/database.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'common/icon_text_btn.dart';
import 'home/home.dart';
import 'invest/invest.dart';
import 'expense/expense.dart';
import 'login/login.dart';


void main() async {
  await dataModel.loadData();
  runApp(const TheApp());
}

class TheApp extends StatefulWidget {
  const TheApp({super.key});

  @override
  _TheAppState createState() => _TheAppState();
}

class _TheAppState extends State<TheApp> {
  int _currentIndex = 0;
  bool _isAdmin = false;

  void _onLogin(context) async  {
    bool? ret = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Login();
        }
    );
    if(ret == true) {
      setState(() {_isAdmin = true;});
    }
  }

  void _onLogout() async {
    setState(() {_isAdmin = false;});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Badminton Management',
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff636FA4), Color(0xff6b6b83), Color(0xff83a4d4)],
                stops: [0, 0.5, 1],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          title: const Text('Badminton Management',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white70
            )),
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconTextBtn(
                  width: 150,
                  height: 40,
                  bgColor: Colors.transparent,
                  title: _isAdmin ? 'Logout' : 'Login',
                  icon: _isAdmin ? Icons.logout : Icons.login,
                  onPressed: () async {
                    _isAdmin ? _onLogout() : _onLogin(context);
                  },
                );
              }
            ),
            const SizedBox(width: 40)
          ]),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            Home(isAdmin: _isAdmin),
            Invest(isAdmin: _isAdmin),
            Expense(isAdmin: _isAdmin)
          ],
        ),
        bottomSheet: ConvexAppBar(
          height: 70,
          gradient: const LinearGradient(
            colors: [Color(0xff636FA4), Color(0xff6b6b83), Color(0xff83a4d4)],
            stops: [0, 0.5, 1],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          shadowColor: Colors.deepPurpleAccent,
          color: Colors.black.withOpacity(0.6),
          activeColor: Colors.white,
          backgroundColor: Colors.blueGrey,
          elevation: 3,
          items: const [
            TabItem(icon: Icons.home, title: 'Tổng quan'),
            TabItem(icon: Icons.monetization_on, title: 'Tiền thu'),
            TabItem(icon: Icons.outbond, title: 'Tiền chi'),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}