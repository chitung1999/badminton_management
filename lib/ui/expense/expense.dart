import 'package:badminton_management/common/add_button.dart';
import 'package:badminton_management/common/item_table.dart';
import 'package:badminton_management/provider/account_provider.dart';
import 'package:badminton_management/provider/data_provider.dart';
import 'package:badminton_management/provider/filter_provider.dart';
import 'package:badminton_management/ui/expense/edit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  _ExpenseState createState() => _ExpenseState();
}

class _ExpenseState extends State<ExpenseScreen> {
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
                  builder: (BuildContext context) {return const EditExpense();}
              );
            }
          ),
          ItemTable(
              titles: const ['Thời gian', 'Dịch vụ', 'Giá'],
              bgColor: Colors.blueGrey[100]!, textColor: Colors.blueGrey[800]!, isHeader: true
          ),
          Consumer3<DataProvider, FilterProvider, AccountProvider>(
            builder: (context, data, time, ac, chill) {
              final List<Expense> expense = data.getExpenses(time.getTime());
              return Column(
                children: [
                  for(int i = 0; i < expense.length; i++)
                    ItemTable(
                      titles: [DateFormat('dd/MM/yyyy').format(expense[i].date), expense[i].item, expense[i].price.toString()],
                      textColor: Colors.blueGrey[800]!,
                      onDoubleClick: () {
                        if (ac.getAccount()) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {return EditExpense(data: expense[i]);}
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