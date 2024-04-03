import 'package:flutter/material.dart';
import 'initialization_helper.dart';

class InitializeScreen extends StatefulWidget {
  Widget targetWidget ;

  InitializeScreen({required this.targetWidget});

  @override
  State<InitializeScreen> createState() => _InitializeScreenState();
}

class _InitializeScreenState extends State<InitializeScreen> {
  final _initializationHelper = InitializationHelper();

  @override
  void initState() {
    super.initState();

    // print('############ InitializeScreen initState');

    _initialize();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );

  Future<void> _initialize() async {
    final navigator = Navigator.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializationHelper.initialize();
      // navigator.pushReplacement(
      //   MaterialPageRoute(builder: (context) => widget.targetWidget),
      // );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            settings: const RouteSettings(name: "/FirstProblemTypeList"),
            builder: (BuildContext context) {
              return widget.targetWidget;
            }
        ),
      );
    });
  }
}
