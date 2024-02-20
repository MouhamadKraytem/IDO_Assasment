import 'package:flutter/material.dart';
import 'ToDoItem.dart';
import 'package:ido/Item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
class ToDoItemList extends StatefulWidget {
  late final List<Item> list;
  late final List<int>? color;
  ToDoItemList({Key ?key , required this.list , required this.color}) : super(key: key);

  @override
  _ToDoItemListState createState() {
    return _ToDoItemListState();
  }
}

class _ToDoItemListState extends State<ToDoItemList> {


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
    if (!widget.list.isEmpty) {
      return Expanded(
        flex: 0,
        child: SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    width: 220,
                    height: 350,
                    child: ListView.builder(
                      itemCount: widget.list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Draggable(
                          data: widget.list[index],
                          child: ToDoItem(
                              id: widget.list[index].id, isDraggable: false),
                          feedback: ToDoItem(
                              id: widget.list[index].id, isDraggable: true),
                          childWhenDragging: Opacity(
                            opacity: 0.5,
                            child: ToDoItem(
                                id: widget.list[index].id, isDraggable: false),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ));


    } else {
      return SizedBox();;
    }
  }
}