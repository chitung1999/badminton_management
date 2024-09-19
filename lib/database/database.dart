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

class Account {
  String user = 'admin';
  String pw = '1';
}

final dataModel = DataModel();

class DataModel {
  // init singleton class
  DataModel._internal();
  factory DataModel() {
    return _instance;
  }
  static final DataModel _instance = DataModel._internal();

  // declare data
  Account account = Account();
  String strInvest = '';
  String strExpense = '';
  List<DataInvest> _investData = [];
  List<DataExpense> _expenseData = [];

  List<String> keyGraph = [];
  Map<String, int> graph = {};
  List<String> time = [];
  List<DataInvest> invest = [];
  List<DataExpense> expense = [];

  void addValueGraph(String key, int value) {
    graph[key] = graph[key]! + value;
  }

  void resetGraph() {
    for (String key in keyGraph) {
      graph[key] = 0;
    }
  }

  void filterInvest(String str) {
    invest.clear();

    for (var item in _investData) {
      if(str == time[0] || item.date.contains(str)) {
        invest.add(item);
      }
    }
  }

  void filterExpense(String str) {
    expense.clear();

    for (var item in _expenseData) {
      if(str == time[0] || item.date.contains(str)) {
        expense.add(item);
      }
    }
  }

  void filterGraph(String str) {
    resetGraph();

    for (var item in _investData) {
      if(str == time[0] || item.date.contains(str)) {
        addValueGraph(keyGraph[0], item.price);
        if (item.status) {
          addValueGraph(keyGraph[1], item.price);
        }
      }
    }

    for (var item in _expenseData) {
      if(str == time[0] || item.date.contains(str)) {
      addValueGraph(keyGraph[2], item.price);
      if(item.item == 'Sân') {
        addValueGraph(keyGraph[4], item.price);
      } else if(item.item == 'Cầu') {
        addValueGraph(keyGraph[5], item.price);
      } else if(item.item == 'Nước') {
        addValueGraph(keyGraph[6], item.price);
      } else {
        addValueGraph(keyGraph[7], item.price);
      }
      }
    }

    graph[keyGraph[3]] = graph[keyGraph[0]]! - graph[keyGraph[2]]!;
  }

  void initData() {
    List<List<String>> list = string2List(strInvest);
    for(var item in list) {
      _investData.insert(0, DataInvest(item[0], item[1], (item[2] == '1'), int.tryParse(item[3])!));
    }
    list = string2List(strExpense);
    for(var item in list) {
      _expenseData.insert(0, DataExpense(item[0], item[1], int.tryParse(item[2])!));
    }

    time.add('Tất cả');
    for (var item in _investData) {
      String str = item.date.substring(3);
      if(!time.contains(str)) {
        time.add(str);
      }
    }
    for (var item in _expenseData) {
      String str = item.date.substring(3);
      if(!time.contains(str)) {
        time.add(str);
      }
    }
    time.sort((b, a) => a.split('').reversed.join('').compareTo(b.split('').reversed.join('')));

    keyGraph = ['Dự kiến thu', 'Đã thu', 'Đã chi', 'Dự kiến còn lại', 'Sân', 'Cầu', 'Nước', 'Khác'];
    filterGraph(time[0]);
    filterInvest(time[0]);
    filterExpense(time[0]);
  }

  Future<bool> loadData() async {
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
          strInvest = response.documents[i].toMap()['data']['data'];
        }
      }

      // Get expense
      response = await databases.listDocuments(
        databaseId: '66e83bbc003c1c92aac3',
        collectionId: '66eabcc70034f14bca74',
      );
      for(int i = 0; i < response.documents.length; i++) {
        if (i == response.documents.length - 1) {
          strExpense = response.documents[i].toMap()['data']['data'];
        }
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
    initData();
    return true;
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
}