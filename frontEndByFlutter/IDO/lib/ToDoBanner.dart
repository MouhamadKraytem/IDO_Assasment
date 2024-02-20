import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'ToDoStatus.dart' as Status;

class ToDoBanner extends StatefulWidget {
  Status.ToDoStatus c;
  ToDoBanner({required this.c,Key ?key}) : super(key: key);

  @override
  _ToDoBannerState createState() {
    return _ToDoBannerState();
  }
}

class _ToDoBannerState extends State<ToDoBanner> {


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
    return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(

                margin: EdgeInsets.all(5),
                width: 210,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xFF232323),
                ),

                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    SvgPicture.asset(widget.c.img),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      widget.c.status,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          );
        }
  }
