import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ido/DragItem.dart';
import 'package:ido/Item.dart';
import 'Impoertance.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:ido/ToDoListItem.dart';

class ToDoItem extends StatefulWidget {
  int id;
  bool isDraggable = false;

  ToDoItem({required this.id, required this.isDraggable, Key? key})
      : super(key: key);

  @override
  _ToDoItemState createState() {
    return _ToDoItemState();
  }
}

class _ToDoItemState extends State<ToDoItem> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();

  TextEditingController _dateController = TextEditingController();
  TextEditingController _estimatedText = TextEditingController();

  int counter = 0;
  int categoryCounter = 0;

  Item getItem(int id) {
    Item res = items[0];
    for (int j = 0; j < items.length; j++) {
      if (items[j].id == id) {
        res = items[j];
      }
    }
    return res;
  }

  updateItemCategory(int itemId, String newCategory) async {
    String apiUrl =
        "https://localhost:7225/ItemApi/updateItemCategory/$itemId?newCategory=$newCategory";

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode({'newCategory': newCategory}),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        print("Item category updated successfully");
      } else if (response.statusCode == 404) {
        print("Item not found");
      } else {
        print("Error updating item category: ${response.body}");
      }
    } catch (e) {
      print("Exception during item category update: $e");
    }
  }

  updateItemTitle(int itemId, String newTitle) async {
    String apiUrl =
        "https://localhost:7225/ItemApi/updateItemTitle/$itemId?newTitle=$newTitle";

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode({'newCategory': newTitle}),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        print("Item category updated successfully");
      } else if (response.statusCode == 404) {
        print("Item not found");
      } else {
        print("Error updating item category: ${response.body}");
      }
    } catch (e) {
      print("Exception during item category update: $e");
    }
  }

  updateItemEstimated(int itemId, String newEsti) async {
    String apiUrl =
        "https://localhost:7225/ItemApi/updateItemEstimated/$itemId?newEstimatedText=$newEsti";

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode({'newEstimatedText': newEsti}),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        setState(() {
          Item i = getItem(itemId);
          i.estimatedText = newEsti;
        });
        print("Item category updated successfully");
      } else if (response.statusCode == 404) {
        print("Item not found");
      } else {
        print("Error updating item category: ${response.body}");
      }
    } catch (e) {
      print("Exception during item category update: $e");
    }
  }

  void updateItemDate(int itemId, DateTime newDate) async {
    String url = 'https://localhost:7225/ItemApi/updateItemDate/$itemId';
    print(newDate.toIso8601String());
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode({'newD': newDate.toIso8601String()}),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        setState(() {
          Item i = getItem(itemId);
          i.dueDate = newDate;
        });
        print('Item date updated successfully.');
      } else {
        print('Failed to update item date. Status code: ${response.body}');
      }
    } catch (e) {
      print('Error updating item date: $e');
    }
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Item i = getItem(widget.id);
    Color c = i.color;
    _estimatedText.text = i.estimatedText;
    return (!widget.isDraggable)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF212529),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: c, // Set your desired border color
                    width: 1.0,
                  ),
                ),
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                width: 250,
                height: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 20,
                              child: TextField(
                                controller: _titleController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: i.title,
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none,
                                ),
                                onEditingComplete: () {
                                  updateItemTitle(
                                      widget.id, _titleController.text);
                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("category",
                                style: TextStyle(color: Colors.white)),
                            SizedBox(
                              width: 40,
                            ),
                            SizedBox(
                              width: 80,
                              height: 20,
                              child: TextField(
                                controller: _categoryController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: i.categoryId,
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none,
                                ),
                                onEditingComplete: () {
                                  updateItemCategory(
                                      widget.id, _categoryController.text);
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("DueDate",
                                style: TextStyle(color: Colors.white)),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 100,
                              height: 20,
                              child: TextField(
                                controller: _dateController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: (i.dueDate == null)
                                      ? 'NONE'
                                      : DateFormat('dd/MM/yyyy')
                                          .format(i.dueDate!),
                                  // Optional hint text for the user
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none,
                                ),
                                onTap: () async {
                                  DateTime? selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: i.dueDate,
                                    // Use the initial date from your data
                                    firstDate: DateTime(2000),
                                    // Define the range of selectable dates
                                    lastDate: DateTime(2101),
                                  );

                                  if (selectedDate != null &&
                                      selectedDate != i.dueDate) {
                                    setState(() {
                                      i.dueDate =
                                          selectedDate; // Update the dueDate in your data model

                                      _dateController.text =
                                          DateFormat('dd/MM/yyyy')
                                              .format(selectedDate);
                                      updateItemDate(i.id , selectedDate);
                                    });
                                  }
                                },
                              ),
                            )

                            //
                            //
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Estimated",
                                style: TextStyle(color: Colors.white)),
                            SizedBox(
                              width: 37,
                            ),
                            SizedBox(
                              width: 80,
                              height: 20,
                              child: TextField(
                                controller: _estimatedText,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: _estimatedText.text,
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none,
                                ),
                                onEditingComplete: () {
                                  updateItemEstimated(
                                      widget.id, _estimatedText.text);
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("importance",
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(
                                width: 37,
                              ),
                              Importance(
                                i: i.importance,
                                itemId: i.id,
                                isDraggable: true,
                              ),
                            ]),
                      ],
                    )),
                  ],
                ),
              ),
            ],
          )
        : DragItem(i: i);
  }
}
