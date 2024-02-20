import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ido/LoginPage.dart';
import 'package:ido/generated/assets.dart';
import 'ToDoStatus.dart';
import 'Item.dart';
import 'ToDoBanner.dart';
import 'ToDoListItem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ToDoList extends StatefulWidget {
  ToDoList({Key? key}) : super(key: key);

  @override
  _ToDoListState createState() {
    return _ToDoListState();
  }
}

class _ToDoListState extends State<ToDoList> {
  int selectedValue = 1;
  int selectedStatus = 1;
  TextEditingController _titleSearch = TextEditingController();

  late String img = "assets/Bitmap.png";

  int countProfile = 0;
  bool isBottomVisible = true;
  bool isProfileImg = false;
  List<Item> done = [];
  List<Item> doing = [];
  List<Item> todo = [];
  List<int> colorItem = [];

  void filterItems(List<Item> item) {
    for (int i = 0; i < item.length; i++) {
      if (item[i].statusId == 1) {
        done.add(item[i]);
      } else if (item[i].statusId == 2) {
        doing.add(item[i]);
      } else {
        todo.add(item[i]);
      }
    }
    done = done.reversed.toList();
    todo = todo.reversed.toList();
    doing = doing.reversed.toList();
  }

  Future <void> loadItems() async {
    int i =  int.parse(await token.getString("id"));
    String url = "https://localhost:7225/ItemApi/getItemsByUserId/$i";

    var response =
        await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        String res = response.body;

        for (var row in convert.jsonDecode(res)) {
          print(row);
          var s = Item(
              row['id'],
              row['title'],
              row['category'],
              row['status'],
              DateTime.parse(row['date']),
              row['importance'],
              row['userId'],
              row['estimated'],
              row['estimatedText']
          );

          items.add(s);
          print("locad suceess");
        }
        filterItems(items);
        print(items);
      });
    } else {
      print("error");
    }
  }


  void newItem() async {
    int userId = int.parse(await token.getString("id"));
    String url = "https://localhost:7225/ItemApi/users/$userId/createItem";

    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      setState(() {
        String res = response.body;
        print(res);
        doing.clear();
        todo.clear();
        done.clear();

        items.clear();
        loadItems();

        print("insert success");
        print(items);
      });
    } else {
      print(response.body);
      print("error");
    }
  }



  void open() {
    setState(() {
      isBottomVisible = true;
    });
  }

  void close() {
    setState(() {
      isBottomVisible = false;
    });
  }

  void openProfile() {
    setState(() {
      isProfileImg = true;
    });
  }

  void closeProfile() {
    setState(() {
      isProfileImg = false;
    });
  }

  String email = "";

  void getToken() async {
    email = await token.getString("email");
    img = await token.getString("img");
  }

  void getItemsIdByPrefix(String prefix) async {
    int userId = int.parse(await token.getString("id"));
    String apiUrl = "https://localhost:7225/ItemApi/users/$userId/getItemsIdsByPrefix";

    try {
      final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({'prefix': prefix}),
    );

      if (response.statusCode == 200) {
        List<dynamic> data = convert.jsonDecode(response.body);
        setState(() {
          List<int> itemIds = data.map((item) => item as int).toList();

          print(itemIds);

          if (itemIds.length > 0) {
            for (int i = 0; i < items.length; i++) {
              bool isMatched = false;

              for (int j = 0; j < itemIds.length; j++) {
                if (items[i].id == itemIds[j]) {
                  print(items[i].id);
                  items[i].color = Colors.white;
                  isMatched = true;
                  break;
                }
              }
              if (!isMatched) {
                items[i].color = Color(0xFF212529);
              }
            }
          }
        });
      } else if (response.statusCode == 400) {
        setState(() {
          for (int i = 0; i < items.length; i++) {
            items[i].color = Color(0xFF212529);
          }
        });

        print("Bad request: ${response.body}");
      } else if (response.statusCode == 404) {
        setState(() {
          for (int i = 0; i < items.length; i++) {
            items[i].color = Color(0xFF212529);
          }
        });
        print("No items found: ${response.body}");
      } else {
        print("Error fetching items: ${response.body}");
      }
    } catch (e) {
      print("Exception during item fetch: $e");
    }
  }


  updateItemStatus(Item item, int newStatus) async {
    int itemId = item.id;
    if (item.statusId == newStatus) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Same status")));
      return;
    }
    String apiUrl =
        "https://localhost:7225/ItemApi/updateItemStatus/$itemId?newStatus=$newStatus";

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode({'newStatus': newStatus}),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        setState(() {
          doing.clear();
          todo.clear();
          done.clear();

          items.clear();
          loadItems();
        });
        print("Item status updated successfully");
      } else if (response.statusCode == 404) {
        print("Item not found");
      } else {
        print("Error updating item status: ${response.body}");
      }
    } catch (e) {
      print("Exception during item status update: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadItems();
    getToken();
    // print(items[0].id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToDoStatus s1 = ToDoStatus(1, "Done", "assets/DoneIcon.svg");
    ToDoStatus s2 = ToDoStatus(2, "Doing", "assets/DoingIcon.svg");
    ToDoStatus s3 = ToDoStatus(3, "ToDo", "assets/ToDoIcon.svg");

    return Scaffold(
        appBar: AppBar(
          bottom: isBottomVisible
              ? PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: Container(
                    color: Color(0xFF6E4C85),
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '"Anything that can go wrong, will go wrong!"',
                          style: TextStyle(color: Colors.white),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            elevation: 0,
                          ),
                          onPressed: () {
                            setState(() {
                              close();
                            });
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          child: Icon(Icons.clear ,color: Colors.black,),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF262626),
          leading: Container(
            child: Image.asset("assets/Logo.png", height: 40),
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
          ),
          actions: [
            Row(
              children: [
                SizedBox(
                  width: 200,
                  child: Container(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: _titleSearch,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          prefixIcon: SvgPicture.asset(
                            'assets/Search.svg',
                            width: 20,
                          ),
                          prefixIconConstraints: BoxConstraints(
                            maxWidth: double.infinity,
                          ),
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        onEditingComplete: () {
                          getItemsIdByPrefix(_titleSearch.text);
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  onPressed: () {
                    newItem();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset('assets/Circle.svg', width: 30),
                      Positioned(
                        top: 5,
                        left: 5,
                        child: SvgPicture.asset('assets/add.svg', width: 20),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    if (countProfile % 2 == 0) {
                      countProfile++;
                      openProfile();
                    } else {
                      countProfile++;
                      closeProfile();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    // Set the background color to transparent
                    elevation:
                        0, // Set the elevation to 0 to remove the button shadow
                  ),
                  child: CircleAvatar(
                      radius: 15, backgroundImage: AssetImage(img)),
                )
              ],
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                height: 730,
                color: Color(0xFF5B5E60),
                child: Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DragTarget(
                          builder: (BuildContext context,
                              List<Object?> candidateData,
                              List<dynamic> rejectedData) {
                            return Column(
                              children: [
                                ToDoBanner(c: s3),
                                ToDoItemList(
                                  list: done,
                                  color: colorItem,
                                ),
                              ],
                            );
                          },
                          onAccept: (Item data) {
                            updateItemStatus(data, 1);
                            print(data.statusId);
                          },
                        ),
                        DragTarget(
                          builder: (BuildContext context,
                              List<Object?> candidateData,
                              List<dynamic> rejectedData) {
                            return Column(
                              children: [
                                ToDoBanner(c: s2),
                                ToDoItemList(list: doing, color: colorItem),
                              ],
                            );
                          },
                          onAccept: (Item data) {
                            updateItemStatus(data, 2);
                            print(data.statusId);
                          },
                        ),
                        DragTarget(
                          builder: (BuildContext context,
                              List<Object?> candidateData,
                              List<dynamic> rejectedData) {
                            return Column(
                              children: [
                                ToDoBanner(c: s1),
                                ToDoItemList(list: todo, color: colorItem),
                              ],
                            );
                          },
                          onAccept: (Item data) {
                            updateItemStatus(data, 3);
                            print(data.statusId);
                          },
                        )
                      ],
                    ),
                    Expanded(child: Container(color: Color(0xFF5B5E60))),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, elevation: 0),
                  onPressed: () {
                    open();
                  },
                  child: SvgPicture.asset(
                    Assets.assetsShowQuote,
                    width: 30,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: isProfileImg
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                        width: 300,
                        height: 100,
                        color: Color(0xFF232323),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CircleAvatar(
                                  radius: 30, backgroundImage: AssetImage(img)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    email,
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        token.remove("email");
                                        Navigator.of(context).pop();
                                      },
                                      child: Row(
                                        children: [
                                          Text("Logout",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue)),
                                          IconTheme(
                                            data: IconThemeData(
                                              color: Colors.blue,
                                              size: 12.0,
                                            ),
                                            child: Icon(Icons.logout),
                                          ),
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.transparent,
                                          elevation: 0))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ));
  }
}
