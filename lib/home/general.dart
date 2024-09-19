import 'package:badminton_management/database/database.dart';
import 'graph.dart';
import 'package:flutter/material.dart';

class General extends StatelessWidget {
  const General({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, int> data = {};
    for(int i = 0; i < 4; i++) {
      data[dataModel.keyGraph[i]] = dataModel.graph[dataModel.keyGraph[i]]!;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(width: 400, height: 500, child: Graph(data: data)),
        Text('Tổng quan',
            style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.bold
            )
        ),
      ],
    );
  }
}
