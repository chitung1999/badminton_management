import 'package:badminton_management/database/database.dart';
import 'package:flutter/material.dart';
import 'general.dart';
import 'detail.dart';
import '../common/drop_down.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.isAdmin});

  final bool isAdmin;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _reload(String str) {
    dataModel.filterGraph(str);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(children: [DropDown(onSelected: _reload)],),
            SizedBox(height: (height > 800 ? (height - 800) / 2 : 0) + 20),
            Wrap(
              spacing: (width > 1300 ? (width - 1300) / 4 : 0) + 20,
              runSpacing: 50,
              alignment: WrapAlignment.center,
              children: [
                General(),
                Detail(),
                Container(
                  width: 420,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.deepPurple),
                    color: Colors.blueGrey.withOpacity(0.5)
                  ),
                  child: Column(
                    children: [
                      const Text('Nội quy',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      const SizedBox(height: 20),
                      Text('- Khung giờ cố định: 20-22h CN hàng tuần\n- Lệ phí thành viên: 200k/tháng\n- Lệ phí bạn bè: 50k/tháng',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey[800],
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
