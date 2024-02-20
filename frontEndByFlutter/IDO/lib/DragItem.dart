import 'package:flutter/material.dart';
import 'Item.dart';
import 'package:intl/intl.dart';

class DragItem extends StatelessWidget {
  Item i;
  DragItem({Key? key , required this.i}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 15;
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF212529),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      padding: EdgeInsets.all(10),
      width: 210,
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
                      width: 130,
                      height: 20,
                      child: Text(
                        i.title,
                        style: TextStyle(color: Colors.white, fontSize: size , decoration: TextDecoration.none),
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("category",
                      style: TextStyle(color: Colors.white, fontSize: size , decoration: TextDecoration.none)),
                  SizedBox(
                    width: 40,
                  ),
                  SizedBox(
                      width: 40,
                      height: 20,
                      child: Text(
                        i.category,
                        style: TextStyle(color: Colors.white, fontSize: size , decoration: TextDecoration.none),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("DueDate",
                      style: TextStyle(color: Colors.white, fontSize: size , decoration: TextDecoration.none)),
                  SizedBox(
                    width: 20,
                  ),
                  Text(DateFormat('dd/MM/yyyy').format(i.dueDate!),
                      style: TextStyle(color: Colors.white, fontSize: size , decoration: TextDecoration.none))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Estimated",
                      style: TextStyle(color: Colors.white, fontSize: size , decoration: TextDecoration.none)),
                  SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    width: 70,
                    height: 20,
                    child: Text(
                      i.estimatedText ?? "NONE",
                      style: TextStyle(color: Colors.white, fontSize: size , decoration: TextDecoration.none),
                    ),
                  ),

                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text("importance",
                    style: TextStyle(color: Colors.white, fontSize: size , decoration: TextDecoration.none)),
                SizedBox(
                  width: 15,
                ),

              ]),
            ],
          )),
        ],
      ),
    );
    ;
  }
}
