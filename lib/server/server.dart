import 'package:appwrite/appwrite.dart';
import 'package:badminton_management/provider/data_provider.dart';
import 'package:badminton_management/server/account.dart';
import 'package:badminton_management/server/encryption.dart';

final server = AppwriteService();

class AppwriteService {
  late Client client;
  late Databases databases;
  late Encryption encryption;

  AppwriteService._internal();

  factory AppwriteService() {
    return _instance;
  }

  static final AppwriteService _instance = AppwriteService._internal();

  Future<bool> initialize() async {
    try {
      client = Client();
      encryption = Encryption();
      client.setEndpoint(encryption.decryptedService(ID_APPWRITE.ENDPOINT))
          .setProject(encryption.decryptedService(ID_APPWRITE.PROJECTID))
          .setSelfSigned(status: true);
      databases = Databases(client);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getAllReceives(List<Receive> receives) async {
    try {
      int limit = 25;
      int offset = 0;

      while (true) {
        final response = await databases.listDocuments(
            databaseId: encryption.decryptedService(ID_APPWRITE.DATABASEID),
            collectionId: encryption.decryptedService(ID_APPWRITE.RECEIVEID),
            queries: [
              Query.limit(limit),
              Query.offset(offset)
            ]
        );

        if (response.documents.isEmpty) {
          break;
        }

        for (var doc in response.documents) {
          receives.add(Receive.fromMap(doc.data));
        }

        offset += limit;
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getAllExpenses(List<Expense> expenses) async {
    try {
      int limit = 25;
      int offset = 0;

      while (true) {
        final response = await databases.listDocuments(
            databaseId: encryption.decryptedService(ID_APPWRITE.DATABASEID),
            collectionId: encryption.decryptedService(ID_APPWRITE.EXPENSEID),
            queries: [
              Query.limit(limit),
              Query.offset(offset)
            ]
        );

        if (response.documents.isEmpty) {
          break;
        }

        for (var doc in response.documents) {
          expenses.add(Expense.fromMap(doc.data));
        }

        offset += limit;
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getAccount() async {
    try {
      var response = await databases.listDocuments(
        databaseId: encryption.decryptedService(ID_APPWRITE.DATABASEID),
        collectionId: encryption.decryptedService(ID_APPWRITE.ACCOUNTID),
      );

      var mapData = response.documents[0].toMap()['data'];
      account.setAccount(mapData['username'], mapData['password']);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addReceive(Receive receive) async {
    try {
      await databases.createDocument(
        databaseId: encryption.decryptedService(ID_APPWRITE.DATABASEID),
        collectionId: encryption.decryptedService(ID_APPWRITE.RECEIVEID),
        documentId: receive.id,
        data: receive.toJson()
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteReceive(String id) async {
    try {
      await databases.deleteDocument(
          databaseId: encryption.decryptedService(ID_APPWRITE.DATABASEID),
          collectionId: encryption.decryptedService(ID_APPWRITE.RECEIVEID),
          documentId: id,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateReceive(Receive receive) async {
    try {
      await databases.updateDocument(
          databaseId: encryption.decryptedService(ID_APPWRITE.DATABASEID),
          collectionId: encryption.decryptedService(ID_APPWRITE.RECEIVEID),
          documentId: receive.id,
          data: receive.toJson()
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addExpense(Expense expense) async {
    try {
      await databases.createDocument(
          databaseId: encryption.decryptedService(ID_APPWRITE.DATABASEID),
          collectionId: encryption.decryptedService(ID_APPWRITE.EXPENSEID),
          documentId: expense.id,
          data: expense.toJson()
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteExpense(String id) async {
    try {
      await databases.deleteDocument(
        databaseId: encryption.decryptedService(ID_APPWRITE.DATABASEID),
        collectionId: encryption.decryptedService(ID_APPWRITE.EXPENSEID),
        documentId: id,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateExpense(Expense expense) async {
    try {
      await databases.updateDocument(
          databaseId: encryption.decryptedService(ID_APPWRITE.DATABASEID),
          collectionId: encryption.decryptedService(ID_APPWRITE.EXPENSEID),
          documentId: expense.id,
          data: expense.toJson()
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}