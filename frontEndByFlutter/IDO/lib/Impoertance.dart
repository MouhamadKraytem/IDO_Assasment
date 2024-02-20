import 'package:flutter/material.dart';
import 'Item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Importance extends StatefulWidget {
  final int i;
  int itemId;
  bool isDraggable = false;

  Importance(
      {Key? key,
      required this.i,
      required this.itemId,
      required this.isDraggable})
      : super(key: key);

  @override
  _ImportanceState createState() {
    return _ImportanceState();
  }
}

class _ImportanceState extends State<Importance> {
  int selectedValue = 2;
  late Color c;
  late String imp = 'Low';

  updateItemImportance(int itemId, int newImportance) async {
    String apiUrl =
        "https://localhost:7225/ItemApi/updateItemImportance/$itemId?newImportance=$newImportance";

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: convert
            .jsonEncode({'itemId': itemId, 'newImportance': newImportance}),
      );
      if (response.statusCode == 204 || response.statusCode == 200) {
        print("Item updated successfully");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Item updated successfully")));
      } else if (response.statusCode == 404) {
        print("Item not found");
      } else {
        print("Error updating item: ${response.body}");
      }
    } catch (e) {
      print("Exception during item update: $e");
    }
  }

  void getColor() {
    if (widget.i == 3) {
      selectedValue = 3;
      c = Color(0xFFDC3545);

      imp = 'High';
    } else if (widget.i == 2) {
      selectedValue = 2;
      c = Color(0xFFFE913E);
      imp = 'Meduim';
    } else {
      selectedValue = 1;
      c = Color(0xFF39AC95);

      imp = 'Low';
    }
  }

  void updateColor(int value) {
    if (value == 3) {
      c = Color(0xFFDC3545);
    } else if (value == 2) {
      c = Color(0xFFFE913E);
    } else {
      c = Color(0xFF39AC95);
    }
  }

  @override
  void initState() {
    super.initState();
    getColor();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (widget.isDraggable)
        ? Builder(
          builder: (context) {
            return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: c,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: SizedBox(
                      width: 48, // Set your desired width
                      height: 20, // Set your desired height

                      child: DropdownButton<int>(
                          underline: Text(""),
                          value: selectedValue,
                          onChanged: (int? newValue) {
                            print('New value selected: $newValue');
                            if (newValue != null) {
                              setState(() {
                                selectedValue = newValue;

                                updateColor(selectedValue);
                                updateItemImportance(widget.itemId, selectedValue);
                              });
                            }
                          },
                          alignment: Alignment.topCenter,
                          iconSize: 0,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          dropdownColor: Colors.grey[800],
                          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                          items: [
                            DropdownMenuItem<int>(
                              child: Text("Low"),
                              value: 1,
                            ),
                            DropdownMenuItem<int>(
                              child: Text("Medium"),
                              value: 2,
                            ),
                            DropdownMenuItem<int>(
                              child: Text("High"),
                              value: 3,
                            ),
                          ]),

                      // Center(
                      //     child: Text(
                      //       imp,
                      //       style: TextStyle(
                      //         color:Colors.white ,
                      //         fontSize: 5,
                      //       ),
                      //     )
                    )),
              );
          }
        )
        : SizedBox();
  }
}
//
// DropdownButton<int>(
// value: selectedValue,
// onChanged: (int? newValue) {
// print('New value selected: $newValue');
// if (newValue != null) {
// setState(() {
// selectedValue = newValue;
// });
// }
// },
// style: TextStyle(
// color: Colors.white,
// fontSize: 16.0,
// ),
// dropdownColor: Colors.grey[800],
// icon: Icon(Icons.arrow_drop_down, color: Colors.white),
// items: [
// DropdownMenuItem<int>(child: Text("Done"),value: 1,),
// DropdownMenuItem<int>(child: Text("Doing"),value: 2,),
// DropdownMenuItem<int>(child: Text("ToDo"),value: 3,),
// ]
// ),
