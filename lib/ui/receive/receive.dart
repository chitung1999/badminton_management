import 'package:badminton_management/common/add_button.dart';
import 'package:badminton_management/common/item_table.dart';
import 'package:badminton_management/provider/account_provider.dart';
import 'package:badminton_management/provider/data_provider.dart';
import 'package:badminton_management/provider/filter_provider.dart';
import 'package:badminton_management/ui/receive/edit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({super.key});

  @override
  _ReceiveState createState() => _ReceiveState();
}

class _ReceiveState extends State<ReceiveScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: width > 1320 ? (width - 1280) / 2 : 20, vertical: 30),
      child: Column(
        children: [
          AddButtonApp(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {return const EditReceive();}
              );
            }
          ),
          ItemTable(
            titles: const ['Thời gian', 'Tên', 'Số tiền', 'Trạng thái'],
            bgColor: Colors.blueGrey[100]!, textColor: Colors.blueGrey[800]!, isHeader: true
          ),
          Consumer3<DataProvider, FilterProvider, AccountProvider>(
            builder: (context, data, time, ac, chill) {
              final List<Receive> receive = data.getReceives(time.getTime());
              return Column(
                children: [
                  for(int i = 0; i < receive.length; i++)
                    ItemTable(
                      titles: [DateFormat('dd/MM/yyyy').format(receive[i].date), receive[i].name, receive[i].value.toString(), receive[i].status ? 'Đã thu' : 'Chưa thu'],
                      textColor: Colors.blueGrey[800]!,
                      onDoubleClick: () {
                        if (ac.getAccount()) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {return EditReceive(data: receive[i]);}
                          );
                        }
                      },
                    )
                ],
              );
            }
          ),
        ],
      ),
    );
  }
}