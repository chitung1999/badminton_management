import 'package:badminton_management/common/text_box_btn.dart';
import 'package:badminton_management/database/database.dart';
import 'package:flutter/material.dart';
import '../common/drop_down.dart';
import '../common/config_app.dart';
import 'dart:html' as html;

class Expense extends StatefulWidget {
  const Expense({super.key, required this.isAdmin});

  final bool isAdmin;

  @override
  _ExpenseState createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  final List<String> _titles = ['Thời gian', 'Mặt hàng', 'Số tiền'];
  final TextEditingController _controller = TextEditingController();
  bool _isEdit = false;

  String _getString(DataExpense item, int num) {
    switch (num) {
      case 0: return item.date;
      case 1: return item.item;
      case 2: return item.price.toString();
      default: return '';
    }
  }

  void _reload(String str) {
    dataModel.filterExpense(str);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1280,
        height: 810,
        padding: const EdgeInsets.only(bottom: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(child: DropDown(onSelected: _reload)),
                if(widget.isAdmin) Row(
                  children: [
                    if(_isEdit) TextBoxBtn(
                      title: 'Cancel',
                      width: 150,
                      height: 50,
                      radius: 5,
                      bgColor: Colors.white,
                      textColor: Colors.blueGrey,
                      onPressed: (){
                        setState(() {_isEdit = false;});
                      }
                    ),
                    const SizedBox(width: 20),
                    TextBoxBtn(
                      title: _isEdit? 'OK' : 'Edit',
                      width: 150,
                      height: 50,
                      radius: 5,
                      onPressed: () async {
                        if(_isEdit) {
                          StatusApp ret = await dataModel.saveExpense(_controller.text);
                          if(ret == StatusApp.success) {
                            ConfigApp.showNotify(context, MessageType.success, StatusApp.success);
                            setState(() {_isEdit = false;});
                            await Future.delayed(const Duration(seconds: 2));
                            html.window.location.reload();
                          } else {
                            ConfigApp.showNotify(context, MessageType.error, ret);
                          }
                        }
                        else {
                          _controller.text = dataModel.strExpense;
                          setState(() {_isEdit = true;});
                        }
                      }
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.3),
                border: Border.all(color: Colors.blueGrey)
              ),
              child: Row(
                children: [
                  for(int i = 0; i < _titles.length; i++)
                    Expanded(child:
                    Center(
                      child: Text(
                        _titles[i],
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey[800],
                          fontWeight: FontWeight.bold
                        )
                      ),
                    )
                    )
                ],
              ),
            ),
            Expanded(child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(vertical: BorderSide(color: Colors.blueGrey))
              ),
              child: _isEdit ?
              TextField(
                controller: _controller,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ) :
              ListView(
                children: List.generate(
                  dataModel.expense.length, (index) => Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey.withOpacity(0.1))
                  ),
                  child: Row(
                    children: [
                      for(int i = 0; i < _titles.length; i++)
                        Expanded(child: Center(
                          child: Text(
                            _getString(dataModel.expense[index], i),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ))
                    ],
                  ),
                ))
              )
            )),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.3),
                border: Border.all(color: Colors.blueGrey)
              ),
              child: Row(
                children: [
                  for(int i = 0; i < _titles.length; i++)
                    Expanded(
                      child: (i != _titles.length - 1) ? Container() : Center(
                        child: Text(
                          'Tổng: ${dataModel.graph['Đã chi']}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey[800],
                            fontWeight: FontWeight.bold
                          )
                        ),
                      )
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
