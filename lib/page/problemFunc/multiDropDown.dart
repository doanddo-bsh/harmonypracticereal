import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Multi Select widget
// This widget is reusable
class MultiSelect extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  const MultiSelect({Key? key
    , required this.items
    , required this.selectedItems
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  List<String> _selectedItems = [] ;

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // 전체 선택
  void _selectAll() {
    setState(() {
      _selectedItems = List.from(widget.items); // 모든 아이템을 선택된 리스트에 추가
    });
  }

  // 전체 해제
  void _deselectAll() {
    setState(() {
      _selectedItems.clear(); // 선택된 아이템 리스트를 비움
      _selectedItems.add("3화음");
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {

    if (_selectedItems.isEmpty) {
      // Show alert if no item is selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            title: const Text('선택해주세요',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xff3a3a3a)
            ),),
            content: const Text('문제를 위해 화성을 한개 이상 선택해주세요',
              style: TextStyle(
                color: Color(0xff797979),
                fontSize: 13.5
              ),),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child : const Text('확인',
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: Color(0xff2f2f2f),
                      fontSize: 15
                  ),),
              ),
            ],
            actionsPadding: EdgeInsets.fromLTRB(
                3.w, 3.h, 10.w, 5.h),
          );
        },
      );
    } else {
      Navigator.pop(context);
    }
  }

// this function is called when the Submit button is tapped
  void _submit() {
    // Navigator.pop(context, _selectedItems);
    if (_selectedItems.isEmpty) {
      // Show alert if no item is selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            title: const Text('선택해주세요',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3a3a3a)
              ),),
            content: const Text('문제를 위해 화성을 한개 이상 선택해주세요',
              style: TextStyle(
                  color: Color(0xff797979),
                  fontSize: 13.5
              ),),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child : const Text('확인',
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                      color: Color(0xff2f2f2f),
                      fontSize: 15
                  ),),
              ),
            ],
            actionsPadding: EdgeInsets.fromLTRB(
                3.w, 3.h, 10.w, 5.h),
          );
        },
      );
    } else {
      Navigator.pop(context, _selectedItems);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedItems = widget.selectedItems;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        '화성 종류',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xff424242),
        ),
      ),
      content: Column(
        // mainAxisSize: MainAxisSize.min, // 최소 크기로 만들기
        children: [
          Row( // 전체 선택과 전체 해제 버튼 배치
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: _selectAll,
                child: const Text('전체 선택', style: TextStyle(color: Colors.green)),
              ),
              TextButton(
                onPressed: _deselectAll,
                child: const Text('전체 해제', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          Expanded(
            child: Scrollbar(
              thumbVisibility:true,
              child: SingleChildScrollView(
                child: ListBody(
                  children: widget.items
                      .map((item) => CheckboxListTile(
                    activeColor: const Color(0xff969696),
                    checkColor: Colors.white,
                    value: _selectedItems.contains(item),
                    title: Text(item,style: const TextStyle(
                        fontSize: 15.5,
                        color: Color(0xff646464),
                        fontWeight: FontWeight.bold
                    ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text(
            '취소',
            style: TextStyle(color: Color(0xffd04444),
            fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white, // Background color
            foregroundColor: Colors.black54,
            elevation: 0,// text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
          ),
          child: const Text('확인',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),),
        ),
      ],
      actionsPadding: EdgeInsets.fromLTRB(
          3.w, 3.h, 10.w, 5.h),
    );
  }
}