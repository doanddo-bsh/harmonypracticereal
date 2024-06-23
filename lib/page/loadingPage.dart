import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'firstPageProblemTypeList.dart';
import 'settingPage/initialize_screen.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 1500),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) {
              return InitializeScreen(
                  targetWidget:const FirstProblemTypeList()
              );
            }
        ),
      ),
    );
  }

  // ChangeNotifierProvider<Counter>(
  // create: (_) => Counter(),
  // child: problemPage[index]
  // );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffceec5),
      body: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height/2-85,
              left: MediaQuery.of(context).size.width/2-5 ,
              child: Image.asset('assets/note11.png',
                fit: BoxFit.contain,
                height: 80.h,
                width: 80.w,),
            ),
            Center(
              child: Container(
                alignment: Alignment.center,
                child: Lottie.asset('assets/animation/Animation - 1700747597611'
                    '.json'),
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height/2+45,
                left: MediaQuery.of(context).size.width/2-38,
                child: const Text('화 성 박 사',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xff373f2c),
                  ),
                )
            ),
            Positioned(
                top: MediaQuery.of(context).size.height-70.h,
                left: 0,
                right: 0,
                child: const Text("© Copyright 2024, seohwa lee",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                    color: Color(0xff373f2c),
                  ),
                  textAlign: TextAlign.center,
                )
            ),
          ]
      ),
    );

  }
}