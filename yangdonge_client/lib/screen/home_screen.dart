import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  final String title = "양동이";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("data"),
          ],
        ),
      ),
    );
  }
}
