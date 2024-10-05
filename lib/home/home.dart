import '../database/database.dart';
import 'package:flutter/material.dart';
import 'graph.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.month});

  final String month;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, int> _dataGeneral = {};
  Map<String, int> _dataDetail = {};

  @override
  void initState() {
    _dataGeneral = database.getDataGeneral(widget.month);
    _dataDetail = database.getDataDetail(widget.month);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(50),
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            SizedBox(height: width > 1240 ? (height - 700) / 2 : 0),
            Wrap(
              spacing: width > 1240 ? (width - 1240) / 4 : 20,
              runSpacing: 50,
              alignment: WrapAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: 400, height: 500, child: Graph(data: _dataGeneral)),
                    Text(
                      'Tổng quan',
                      style: TextStyle(fontSize: 20, color: Colors.blueGrey[800], fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: 400, height: 500, child: Graph(data: _dataDetail)),
                    Text(
                      'Chi tiêu',
                      style: TextStyle(fontSize: 20, color: Colors.blueGrey[800], fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
                SizedBox(width: 300, child: Image.asset('data/icon/note.png'),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
