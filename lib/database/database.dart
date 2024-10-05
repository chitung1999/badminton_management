import 'package:appwrite/appwrite.dart';
import '../common/config_app.dart';

Client client = Client();
Databases databases = Databases(client);

class DataInvest {
  String date = '';
  String name = '';
  bool status = true;
  int price = 0;

  DataInvest(String d, String n, bool s, int p) {
    date = d;
    name = n;
    status = s;
    price = p;
  }
}

class DataExpense {
  String date = '';
  String item = '';
  int price = 0;

  DataExpense(String d, String i, int p) {
    date = d;
    item = i;
    price = p;
  }
}

class DataModel {
  List<DataInvest> invest = [];
  List<DataExpense> expense = [];
  int totalInvest = 0;
  int totalExpense = 0;

  DataModel(List<DataInvest> i, List<DataExpense> e, int ti, int te) {
    invest = i;
    expense = e;
    totalInvest = ti;
    totalExpense = te;
  }
}

class Account {
  String user = 'admin';
  String pw = '1';
}

final database = DataBase();

class DataBase {
  DataBase._internal();
  factory DataBase() {
    return _instance;
  }
  static final DataBase _instance = DataBase._internal();

  Account account = Account();
  String strInvestData = '';
  String strExpenseData = '';
  Map<String, DataModel> data = {};

  void initData() {
    Map<String, DataModel> tempData = {};
    DataModel allData = DataModel([],[],0,0);
    List<List<String>> list = string2List(strInvestData);
    for(var item in list) {
      allData.invest.insert(0, DataInvest(item[0], item[1], (item[2] == '1'), int.tryParse(item[3])!));
      allData.totalInvest += int.tryParse(item[3])!;

      if(tempData.keys.contains(item[0].substring(3))) {
        tempData[item[0].substring(3)]!.invest.insert(0, DataInvest(item[0], item[1], (item[2] == '1'), int.tryParse(item[3])!));
        tempData[item[0].substring(3)]!.totalInvest += int.tryParse(item[3])!;
      } else {
        tempData[item[0].substring(3)] = DataModel([DataInvest(item[0], item[1], (item[2] == '1'), int.tryParse(item[3])!)], [], int.tryParse(item[3])!, 0);
      }
    }

    list = string2List(strExpenseData);
    for(var item in list) {
      allData.expense.insert(0, DataExpense(item[0], item[1], int.tryParse(item[2])!));
      allData.totalExpense += int.tryParse(item[2])!;

      if(tempData.keys.contains(item[0].substring(3))) {
        tempData[item[0].substring(3)]!.expense.insert(0, DataExpense(item[0], item[1], int.tryParse(item[2])!));
        tempData[item[0].substring(3)]!.totalExpense += int.tryParse(item[2])!;
      } else {
        tempData[item[0].substring(3)] = DataModel([], [DataExpense(item[0], item[1], int.tryParse(item[2])!)], 0, int.tryParse(item[2])!);
      }
    }

    List<String> keys = tempData.keys.toList();
    keys.sort((a, b) => b.substring(0,2).compareTo(a.substring(0,2)));
    keys.sort((a, b) => b.substring(3).compareTo(a.substring(3)));

    data['Tất cả'] = allData;
    for(String key in keys) {data[key] = tempData[key]!;}
  }

  Future<bool> initialize() async {
    try {
      client.setEndpoint('https://cloud.appwrite.io/v1').setProject('66e83387001de56d99c2').setSelfSigned(status: true);

      Map<String, dynamic> mapData = {};

      // Get account
      var response = await databases.listDocuments(
        databaseId: '66e83bbc003c1c92aac3',
        collectionId: '66eabb2200226e4f2b7d',
      );
      if(response.documents.isEmpty) {
        return false;
      }

      mapData = response.documents[0].toMap()['data'];
      account.user = mapData['username'];
      account.pw = mapData['password'];

      // Get invest
      response = await databases.listDocuments(
        databaseId: '66e83bbc003c1c92aac3',
        collectionId: '66e83bf6003129c48887',
      );

      for(int i = 0; i < response.documents.length; i++) {
        if (i == response.documents.length - 1) {
          strInvestData = response.documents[i].toMap()['data']['data'];
        }
      }

      // Get expense
      response = await databases.listDocuments(
        databaseId: '66e83bbc003c1c92aac3',
        collectionId: '66eabcc70034f14bca74',
      );
      for(int i = 0; i < response.documents.length; i++) {
        if (i == response.documents.length - 1) {
          strExpenseData = response.documents[i].toMap()['data']['data'];
        }
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
    initData();
    return true;
  }

  Map<String, int> getDataGeneral(String month) {
    int invest = data[month]!.totalInvest;
    int remain = 0;
    int expense = data[month]!.totalExpense;
    if(month == 'Tất cả') {
      return {
        'Thu': invest,
        'Chi': expense,
        'Còn lại': invest - expense,
      };
    } else {
      List<String> keys = data.keys.toList().reversed.toList();
      for(String key in keys) {
        if(key == month) {
          break;
        }
        remain = remain + data[key]!.totalInvest - data[key]!.totalExpense;
      }
      return {
        'Thu': invest,
        'Còn dư': remain,
        'Chi': expense,
        'Còn lại': invest + remain - expense,
      };
    }
  }

  Map<String, int> getDataDetail(String month) {
    Map<String, int> resutl = {
      'Sân': 0,
      'Cầu': 0,
      'Nước': 0,
      'Khác': 0,
    };

    for(var item in data[month]!.expense) {
      switch (item.item) {
        case 'Sân':
          resutl['Sân'] = resutl['Sân']! + item.price;
          break;
        case 'Cầu':
          resutl['Cầu'] = resutl['Cầu']! + item.price;
          break;
        case 'Nước':
          resutl['Nước'] = resutl['Nước']! + item.price;
          break;
        default:
          resutl['Khác'] = resutl['Khác']! + item.price;
          break;
      }
    }
    return resutl;
  }

  Future<StatusApp> saveInvest(String str) async {
    if(str.isEmpty) {
      return StatusApp.success;
    }

    // Check data
    var regex = RegExp(r'[^a-zA-Z0-9àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ/,\n ]');
    if(regex.hasMatch(str)) {
      return StatusApp.containSpecialChar;
    }

    List<List<String>> investData = [];
    try {
      investData = str.trim().split('\n').map((line) {
        List<String> parts = line.split(',')
            .map((part) => part.trim())
            .toList();
        return parts;})
          .toList();
    } catch(e) {
      return StatusApp.error;
    }

    for(var item in investData) {
      if(item.length != 4) {
        return StatusApp.wrongNumberElement;
      }

      regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
      if(!regex.hasMatch(item[0])) {
        return StatusApp.wrongDate;
      }

      if(item[1].isEmpty) {
        return StatusApp.nameEmpty;
      }

      if(item[2] != '0' && item[2] != '1') {
        return StatusApp.wrongStatus;
      }

      if(int.tryParse(item[3]) == null) {
        return StatusApp.wrongPrice;
      }
    }

    List<List<String>> list = string2List(str);

    //Sort data
    list.sort((a, b) => formatDate(a[0]).compareTo(formatDate(b[0])));
    str = '';
    for(var item in list) {
      str += ('${item[0]}, ${item[1]}, ${item[2]}, ${item[3]}\n');
    }

    try {
      var response = await databases.listDocuments(
        databaseId: '66e83bbc003c1c92aac3',
        collectionId: '66e83bf6003129c48887',
        queries: [
          Query.orderAsc('\$createdAt'),
        ],
      );

      if (response.total >= 10) {
        String id = response.documents.first.$id;
        await databases.deleteDocument(
          databaseId: '66e83bbc003c1c92aac3',
          collectionId: '66e83bf6003129c48887',
          documentId: id,
        );
      }

      await databases.createDocument(
        databaseId: '66e83bbc003c1c92aac3',
        collectionId: '66e83bf6003129c48887',
        documentId: 'unique()',
        data: {
          'time': DateTime.now().toString(),
          'data': str,
        },
      );
    } catch (e) {
      print('Error: $e');
      return StatusApp.failConnection;
    }

    return StatusApp.success;
  }

  Future<StatusApp> saveExpense(String str) async {
    if(str.isEmpty) {
      return StatusApp.success;
    }

    // Check data
    var regex = RegExp(r'[^a-zA-Z0-9àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ/,\n ]');
    if(regex.hasMatch(str)) {
      return StatusApp.containSpecialChar;
    }

    List<List<String>> expenseData = [];
    try {
      expenseData = str.trim().split('\n').map((line) {
        List<String> parts = line.split(',')
            .map((part) => part.trim())
            .toList();
        return parts;})
          .toList();
    } catch(e) {
      return StatusApp.error;
    }

    for(var item in expenseData) {
      if(item.length != 3) {
        return StatusApp.wrongNumberElement;
      }

      regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
      if(!regex.hasMatch(item[0])) {
        return StatusApp.wrongDate;
      }

      if(item[1].isEmpty) {
        return StatusApp.itemEmpty;
      }

      if(int.tryParse(item[2]) == null) {
        return StatusApp.wrongPrice;
      }
    }

    List<List<String>> list = string2List(str);

    //Sort data
    list.sort((a, b) => formatDate(a[0]).compareTo(formatDate(b[0])));
    str = '';
    for(var item in list) {
      str += ('${item[0]}, ${item[1]}, ${item[2]}\n');
    }

    try {
      var response = await databases.listDocuments(
        databaseId: '66e83bbc003c1c92aac3',
        collectionId: '66eabcc70034f14bca74',
        queries: [
          Query.orderAsc('\$createdAt'),
        ],
      );

      if (response.total >= 10) {
        String id = response.documents.first.$id;
        await databases.deleteDocument(
          databaseId: '66e83bbc003c1c92aac3',
          collectionId: '66eabcc70034f14bca74',
          documentId: id,
        );
      }

      await databases.createDocument(
        databaseId: '66e83bbc003c1c92aac3',
        collectionId: '66eabcc70034f14bca74',
        documentId: 'unique()',
        data: {
          'time': DateTime.now().toString(),
          'data': str,
        },
      );
    } catch (e) {
      print('Error: $e');
      return StatusApp.failConnection;
    }

    return StatusApp.success;
  }

  String formatDate(String str) {
    List<String> parts = str.split('/');
    return '${parts[2]}${parts[1]}${parts[0]}';
  }

  List<List<String>> string2List(String str) {
    List<List<String>> list = [];

    list = str.trim().split('\n').map((line) {
      List<String> parts = line.split(',')
          .map((part) => part.trim())
          .toList();
      return parts;
    }).toList();
    if(list[0][0].isEmpty) {
      list.clear();
    }
    return list;
  }

  void getListMonth() {
    // for(var value in _investData.keys) {
    //   if(!listMonth.contains(value)) {
    //     listMonth.add(value);
    //   }
    // }
    // for(var value in _expenseData.keys) {
    //   if(!listMonth.contains(value)) {
    //     listMonth.add(value);
    //   }
    // }
    //
    // listMonth.sort((a, b) => b.substring(0,2).compareTo(a.substring(0,2)));
    // listMonth.sort((a, b) => b.substring(3).compareTo(a.substring(3)));
    // listMonth.insert(0, 'Tất cả');
  }
}