import 'package:flutter/material.dart';

class InProgress extends StatefulWidget {
  const InProgress(
      {
        super.key,
        required this.func
      }
      );

  final Future<bool> func;

  @override
  _InProgressState createState() => _InProgressState();
}

class _InProgressState extends State<InProgress> {
  late Future<bool> _futureResult;

  @override
  void initState() {
    _futureResult = widget.func;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool> (
      future: _futureResult,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator()
          ));
        }
        else {
          bool? ret = snapshot.data ?? false;
          Navigator.pop(context, ret);
          return const SizedBox();
        }
      },
    );
  }
}