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
      return Center(
        child: SizedBox(
          width: 1600,
          height: 720,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(child: DropDown(onSelected: _reload)),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  General(),
                  const SizedBox(width: 20),
                  Detail(),
                  const SizedBox(width: 20),
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
            ],
          ),
        ),
      );
  }
}
