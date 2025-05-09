import 'package:badminton_management/common/inprogress.dart';
import 'package:badminton_management/common/notify.dart';
import 'package:badminton_management/common/text_button.dart';
import 'package:badminton_management/provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/appwrite.dart';

class EditReceive extends StatefulWidget {
  const EditReceive({super.key, this.data});

  final Receive? data;

  @override
  _EditReceiveState createState() => _EditReceiveState();
}

class _EditReceiveState extends State<EditReceive> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _value = TextEditingController();
  late DateTime _time;
  late bool _isCheck;

  @override
  void initState() {
    if (widget.data == null) {
       _time = DateTime.now();
      _isCheck = false;
    } else {
      _name.text = widget.data!.name;
      _value.text = widget.data!.value.toString();
      _time = widget.data!.date;
      _isCheck = widget.data!.status;
    }
    super.initState();
  }

  Future<bool> onDelete(DataProvider dataProvider) async {
    bool ret = await dataProvider.deleteReceive(widget.data!.id);
    if (ret) {
      Notify.show(context, NotiType.success, 'Xoá dữ liệu thành công!');
    } else {
      Notify.show(context, NotiType.error, 'Xoá dữ liệu không thành công!');
    }
    return ret;
  }

  Future<bool> onOK(DataProvider dataProvider) async {
    int value = 0;

    try {
      value = int.parse(_value.text);
    } catch (e) {
      print(e);
      Notify.show(context, NotiType.notice, 'Tên hoặc Số tiền không hợp lệ!');
      return false;
    }

    if (_name.text.isEmpty || value <= 0) {
      Notify.show(context, NotiType.notice, 'Tên hoặc Số tiền không hợp lệ!');
      return false;
    }

    if (widget.data == null) {
      Receive r = Receive(ID.unique(), _time, _name.text, _isCheck, value);
      bool ret = await dataProvider.addReceive(r);
      if (ret) {
        Notify.show(context, NotiType.success, 'Thêm dữ liệu thành công!');
      } else {
        Notify.show(context, NotiType.error, 'Thêm dữ liệu không thành công!');
      }
      return ret;
    } else {
      Receive r = Receive(widget.data!.id, _time, _name.text, _isCheck, value);
      bool ret = await dataProvider.updateReceive(r);
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
                  controller: _name,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      hintText: 'Nhập tên',
                      hintStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.withOpacity(0.3)
                      ),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _value,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      hintText: 'Nhập số tiền',
                      hintStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.withOpacity(0.3)
                      ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    Row(
                      children: [
                        Checkbox(value: _isCheck, onChanged: (bool? value) {setState(() {_isCheck = value!;});}),
                        const Text('Đã thu', style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    )
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
