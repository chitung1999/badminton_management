import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:badminton_management/server/server.dart';


class Receive {
  String id = '';
  DateTime date = DateTime.now();
  String name = '';
  bool status = false;
  int value = 0;

  Receive(String i, DateTime d, String n, bool s, int v) {
    id = i;
    date = d;
    name = n;
    status = s;
    value = v;
  }


  factory Receive.fromMap(Map<String, dynamic> map) {
    return Receive(map['\$id'], DateTime.parse(map['date']), map['name'], map['status'], map['value']);
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'name': name,
      'status': status,
      'value': value,
    };
  }
}

class Expense {
  String id = '';
  DateTime date = DateTime.now();
  String item = '';
  int price = 0;

  Expense(String i, DateTime d, String it, int p) {
    id = i;
    date = d;
    item = it;
    price = p;
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(map['\$id'], DateTime.parse(map['date']), map['item'], map['price']);
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'item': item,
      'price': price,
    };
  }
}

class DataProvider with ChangeNotifier {
  final List<Receive> _receives = [];
  final List<Expense> _expense = [];

  Future<bool> initialize() async {
    _receives.clear();
    _expense.clear();

    bool ret = await server.initialize();
    if (!ret) return ret;

    ret = await server.getAllReceives(_receives);
    if (!ret) return ret;

    ret = await server.getAllExpenses(_expense);
    if (!ret) return ret;

    ret = await server.getAccount();
    if (!ret) return ret;

    notifyListeners();
    return true;
  }

  Future<bool> addReceive(Receive r) async {
    bool ret = await server.addReceive(r);
    if (ret) {
      int index = 0;
      for (var item in _receives) {
        if(r.date.isAfter(item.date)) {
          break;
        }
        index++;
      }
      _receives.insert(index, r);

      notifyListeners();
    }

    return ret;
  }

  Future<bool> deleteReceive(String id) async {
    if (id.isEmpty) {return false;}
    bool ret = await server.deleteReceive(id);
    if (ret) {
      _receives.removeWhere((item) => item.id == id);
      notifyListeners();
    }

    return ret;
  }

  Future<bool> updateReceive(Receive r) async {
    bool ret = await server.updateReceive(r);
    if (ret) {
      for(int i = 0; i < _receives.length; i++) {
        if(_receives[i].id == r.id) {
          _receives[i] = r;
          break;
        }
      }
      notifyListeners();
    }

    return ret;
  }

  List<Receive> getReceives(DateTime? time) {
    List<Receive> data = [];

    if (time == null) {
      data = _receives;
    } else {
      for (var item in _receives) {
        if (item.date.month == time.month && item.date.year == time.year) {
          data.add(item);
        }
      }
    }

    return data;
  }

  Future<bool> addExpense(Expense e) async {
    bool ret = await server.addExpense(e);
    if (ret) {
      int index = 0;
      for (var item in _expense) {
        if(e.date.isAfter(item.date)) {
          break;
        }
        index++;
      }
      _expense.insert(index, e);

      notifyListeners();
    }

    return ret;
  }

  List<Expense> getExpenses(DateTime? time) {
    List<Expense> data = [];

    if (time == null) {
      data = _expense;
    } else {
      for (var item in _expense) {
        if (item.date.month == time.month && item.date.year == time.year) {
          data.add(item);
        }
      }
    }

    return data;
  }

  Future<bool> deleteExpense(String id) async {
    if (id.isEmpty) {return false;}
    bool ret = await server.deleteExpense(id);
    if (ret) {
      _expense.removeWhere((item) => item.id == id);
      notifyListeners();
    }

    return ret;
  }

  Future<bool> updateExpense(Expense e) async {
    bool ret = await server.updateExpense(e);
    if (ret) {
      for(int i = 0; i < _expense.length; i++) {
        if(_expense[i].id == e.id) {
          _expense[i] = e;
          break;
        }
      }
      notifyListeners();
    }

    return ret;
  }

  Map<String, int> getReceiveGraph(DateTime? time) {
    Map<String, int> data = {};
    if (time == null) {
      int totalReceive = 0;
      int totalExpense = 0;
      for(var item in _receives) {
        totalReceive += item.value;
      }
      for(var item in _expense) {
        totalExpense += item.price;
      }
      data['Tiền thu'] = totalReceive;
      data['Tiền chi'] = totalExpense;
      data['Còn lại'] = totalReceive - totalExpense;
    } else {
      int totalReceive = 0;
      int totalExpense = 0;
      int remain = 0;

      for(var item in _receives) {
        if(item.date.isBefore(time))
          {
            remain += item.value;
          }
        else if (item.date.year == time.year && item.date.month == time.month)
          {
            totalReceive += item.value;
          }
      }

      for(var item in _expense) {
        if(item.date.isBefore(time))
        {
          remain -= item.price;
        }
        else if (item.date.year == time.year && item.date.month == time.month)
        {
          totalExpense += item.price;
        }
      }
      data['Tiền thu'] = totalReceive;
      data['Tiền chi'] = totalExpense;
      data['Dư tháng trước'] = remain;
      data['Còn lại'] = totalReceive + remain - totalExpense;
    }

    return data;
  }

  Map<String, int> getExpenseGraph(DateTime? time) {
    Map<String, int> data = {};
    int court = 0;
    int shuttlecock = 0;
    int drink = 0;
    int other = 0;

    if (time == null) {
      for(var item in _expense) {
        if (item.item == 'Sân') {court += item.price;}
        else if (item.item == 'Cầu') {shuttlecock += item.price;}
        else if (item.item == 'Nước') {drink += item.price;}
        else {other += item.price;}
      }
    } else {
      for(var item in _expense) {
        if (time.month == item.date.month && time.year == item.date.year) {
          if (item.item == 'Sân') {court += item.price;}
          else if (item.item == 'Cầu') {shuttlecock += item.price;}
          else if (item.item == 'Nước') {drink += item.price;}
          else {other += item.price;}
        }
      }
    }

    data['Tiền Sân'] = court;
    data['Tiền Cầu'] = shuttlecock;
    data['Tiền Nước'] = drink;
    data['Khác'] = other;

    return data;
  }

  List<String> getListTime() {
    List<String> strTime = ['Tất cả'];
    List<DateTime> time = [];

    for(var item in _receives) {
      time.add(item.date);
    }

    for(var item in _expense) {
      time.add(item.date);
    }

    time.sort((a, b) => b.compareTo(a));

    for(var item in time) {
      String str = DateFormat('MM/yyyy').format(item);
      if (!strTime.contains(str)) {
        strTime.add(DateFormat('MM/yyyy').format(item));
      }
    }

    return strTime;
  }
}
