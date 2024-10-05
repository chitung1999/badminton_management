import '../common/text_box_btn.dart';
import '../database/database.dart';
import 'package:flutter/material.dart';
import '../common/config_app.dart';
import 'dart:html' as html;

class Expense extends StatefulWidget {
  const Expense({super.key, required this.isAdmin, required this.month});

  final String month;
  final bool isAdmin;

  @override
  _ExpenseState createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  final List<String> _titles = ['Thời gian', 'Mặt hàng', 'Số tiền'];
  final TextEditingController _controller = TextEditingController();
  late List<DataExpense> _data;
  late int _sum;
  bool _isEdit = false;

  String _getString(DataExpense item, int num) {
    switch (num) {
      case 0: return item.date;
      case 1: return item.item;
      case 2: return item.price.toString();
      default: return '';
    }
  }

  @override
  void initState() {
    _data = database.data[widget.month]!.expense;
    _sum = database.data[widget.month]!.totalExpense;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height - 100,
      padding: EdgeInsets.symmetric(horizontal: width > 1280 ? (width - 1280) / 2 : 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                        StatusApp ret = await database.saveExpense(_controller.text);
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
                        _controller.text = database.strExpenseData;
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

                  _data.length, (index) => Container(
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey.withOpacity(0.1))
                ),
                child: Row(
                  children: [
                    for(int i = 0; i < _titles.length; i++)
                      Expanded(child: Center(
                        child: Text(
                          _getString(_data[index], i),
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
                        'Tổng: $_sum',
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
    );
  }
}
