import 'common/drop_down.dart';
import 'common/text_btn.dart';
import 'database/database.dart';
import 'package:flutter/material.dart';
import 'home/home.dart';
import 'invest/invest.dart';
import 'expense/expense.dart';
import 'login/login.dart';

void main() async {
  await database.initialize();
  runApp(const TheApp());
}

class TheApp extends StatefulWidget {
  const TheApp({super.key});

  @override
  _TheAppState createState() => _TheAppState();
}

class _TheAppState extends State<TheApp> {
  int _currentIndex = 0;
  String _currentMonth = database.data.keys.toList()[0];
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
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Badminton Manager',
      home: Scaffold(
        body: Column(
          children: [
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff355C7D), Color(0xff6C5B7B), Color(0xffC06C84)],
                  stops: [0, 0.5, 1],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (width >= 1160)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset('data/icon/icon_app.png'),
                        const Text(' Badminton ', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text('manager', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(width: 80),
                        TextBtn(title: 'Thống kê', onPressed: (){setState(() {_currentIndex = 0;});}),
                        const SizedBox(width: 50),
                        TextBtn(title: 'Tiền thu', onPressed: (){setState(() {_currentIndex = 1;});}),
                        const SizedBox(width: 50),
                        TextBtn(title: 'Tiền chi', onPressed: (){setState(() {_currentIndex = 2;});}),
                        const SizedBox(width: 50),
                        Builder(
                          builder: (context) {
                            return TextBtn(
                              title: _isAdmin ? 'Đăng xuất' : 'Đăng nhập',
                              onPressed: (){_isAdmin ? _onLogout() : _onLogin(context);}
                            );
                          }
                        ),
                      ],
                    ),
                  if (width < 1160)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Builder(
                          builder: (context) {
                            return PopupMenuButton<int> (
                              icon: const Icon(Icons.dehaze), iconSize: 30, iconColor: Colors.white70,
                              position: PopupMenuPosition.under,
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                                const PopupMenuItem<int>(
                                  value: 0,
                                  child: Text('Thống kê', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
                                ),
                                const PopupMenuItem<int>(
                                  value: 1,
                                  child: Text('Tiền thu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
                                ),
                                const PopupMenuItem<int>(
                                  value: 2,
                                  child: Text('Tiền chi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
                                ),
                                PopupMenuItem<int>(
                                  value: 3,
                                  child: Text(_isAdmin ? 'Đăng xuất' : 'Đăng nhập', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
                                ),
                              ],
                              onSelected: (int index) {
                                if(index == 3) {
                                  _isAdmin ? _onLogout() : _onLogin(context);
                                } else {setState(() {_currentIndex = index;});}
                              },
                            );
                          }
                        ),
                        if (width > 640) const SizedBox(width: 50),
                        if (width > 640) Image.asset('data/icon/icon_app.png'),
                        if (width > 640) const Text(' Badminton ', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                        if (width > 640) const Text('manager', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  DropDown(
                    onSelected: (String month) {
                      setState(() {_currentMonth = month;});
                    },
                    data: database.data.keys.toList()
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  Home(key: ValueKey(_currentMonth), month: _currentMonth),
                  Invest(key: ValueKey(_currentMonth), month: _currentMonth, isAdmin: _isAdmin),
                  Expense(key: ValueKey(_currentMonth), month: _currentMonth, isAdmin: _isAdmin)
                ]
              )
            )
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}