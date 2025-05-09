import 'package:badminton_management/common/text_button.dart';
import 'package:badminton_management/provider/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddButtonApp extends StatefulWidget {
  const AddButtonApp(
      {
        super.key,
        required this.onPressed
      }
      );

  final Function() onPressed;

  @override
  _AddButtonAppState createState() => _AddButtonAppState();
}

class _AddButtonAppState extends State<AddButtonApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider> (
      builder: (context, ac, chill) {
        return ac.getAccount() ? Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButtonApp(
                    title: '+',
                    width: 150,
                    height: 50,
                    outlineColor: Colors.blueGrey,
                    textColor: Colors.blueGrey[800]!,
                    onPressed: widget.onPressed
                ),
              ],
            ),
            const SizedBox(height: 8,)
          ],
        ) : const SizedBox();
      }
    );
  }
}