import 'package:badminton_management/common/graph.dart';
import 'package:badminton_management/provider/data_provider.dart';
import 'package:badminton_management/provider/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<FilterProvider, DataProvider>(
      builder: (context, time, data, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: (constraints.maxWidth > 1000 && constraints.maxHeight > 600)  ? (constraints.maxHeight / 2 - 300) : 30,
                horizontal: 50
              ),
              child: Center(
                child: Wrap(
                  spacing: 100.0,
                  runSpacing: 30.0,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: 400, height: 500, child: Graph(data: data.getReceiveGraph(time.getTime()))),
                        Text(
                          'Tổng quan',
                          style: TextStyle(fontSize: 20, color: Colors.blueGrey[800], fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: 400, height: 500, child: Graph(data: data.getExpenseGraph(time.getTime()))),
                        Text(
                          'Chi tiêu',
                          style: TextStyle(fontSize: 20, color: Colors.blueGrey[800], fontWeight: FontWeight.bold)
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}
