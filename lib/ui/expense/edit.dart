import 'package:badminton_management/common/inprogress.dart';
import 'package:badminton_management/common/notify.dart';
import 'package:badminton_management/common/text_button.dart';
import 'package:badminton_management/provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/appwrite.dart';

class EditExpense extends StatefulWidget {
  const EditExpense({super.key, this.data});

  final Expense? data;

  @override
  _EditExpenseState createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  final TextEditingController _item = TextEditingController();
  final TextEditingController _price = TextEditingController();
  late DateTime _time;

  @override
  void initState() {
    if (widget.data == null) {
      _time = DateTime.now();
    } else {
      _item.text = widget.data!.item;
      _price.text = widget.data!.price.toString();
      _time = widget.data!.date;
    }
    super.initState();
  }

  Future<bool> onDelete(DataProvider dataProvider) async {
    bool ret = await dataProvider.deleteExpense(widget.data!.id);
    if (ret) {
      Notify.show(context, NotiType.success, 'Xoá dữ liệu thành công!');
    } else {
      Notify.show(context, NotiType.error, 'Xoá dữ liệu không thành công!');
    }
    return ret;
  }

  Future<bool> onOK(DataProvider dataProvider) async {
    int price = 0;

    try {
      price = int.parse(_price.text);
    } catch (e) {
      print(e);
      Notify.show(context, NotiType.notice, 'Tên hoặc Số tiền không hợp lệ!');
      return false;
    }

    if (_item.text.isEmpty || price <= 0) {
      Notify.show(context, NotiType.notice, 'Tên hoặc Số tiền không hợp lệ!');
      return false;
    }

    if (widget.data == null) {
      Expense e = Expense(ID.unique(), _time, _item.text, price);
      bool ret = await dataProvider.addExpense(e);
      if (ret) {
        Notify.show(context, NotiType.success, 'Thêm dữ liệu thành công!');
      } else {
        Notify.show(context, NotiType.error, 'Thêm dữ liệu không thành công!');
      }
      return ret;
    } else {
      Expense e = Expense(widget.data!.id, _time, _item.text, price);
      bool ret = await dataProvider.updateExpense(e);
      if (ret) {
        Notify.show(context, NotiType.success, 'Sửa dữ liệu thành công!');
      } else {
        Notify.show(context, NotiType.error, 'Sửa dữ liệu không thành công!');
      }
      return ret;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black12, width: 2)
        ),

        child: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _item,
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: 'Nhập dịch vụ',
                      hintStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.withOpacity(0.3)
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _price,
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: 'Nhập giá',
                      hintStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.withOpacity(0.3)
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _time,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                                barrierDismissible: false,
                                useRootNavigator: false
                            );
                            if (picked != null && picked != _time) {
                              setState(() {_time = picked;});
                            }
                          },
                          icon: const Icon(Icons.calendar_month)
                      ),
                      Text(DateFormat('dd/MM/yyyy').format(_time), style: const TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                  const SizedBox(height: 50),
                  Consumer<DataProvider>(
                      builder: (context, dataProvider, chill) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButtonApp(
                                title: 'Cancel',
                                width: 100,
                                height: 50,
                                textSize: 17,
                                radius: 5,
                                bgColor: Colors.black12,
                                outlineColor: Colors.black26,
                                onPressed: () {
                                  Navigator.pop(context, false);
                                }
                            ),
                            if (widget.data != null)
                              TextButtonApp(
                                  title: 'Delete',
                                  width: 100,
                                  height: 50,
                                  textSize: 17,
                                  radius: 5,
                                  bgColor: Colors.red.withOpacity(0.3),
                                  outlineColor: Colors.red.withOpacity(0.5),
                                  onPressed: () async {
                                    bool ret = await showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {return InProgress(func: onDelete(dataProvider));}
                                    );

                                    if(ret) {
                                      Navigator.pop(context, false);
                                    }
                                  }
                              ),
                            TextButtonApp(
                                title: 'OK',
                                width: 100,
                                height: 50,
                                textSize: 17,
                                radius: 5,
                                bgColor: Colors.white,
                                outlineColor: Colors.blueAccent,
                                onPressed: () async {
                                  bool ret = await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return InProgress(func: onOK(dataProvider));
                                      }
                                  );

                                  if(ret) {
                                    Navigator.pop(context, false);
                                  }
                                }
                            ),
                          ],
                        );
                      }
                  ),
                ],
              ),
            ))
    );
  }
}
