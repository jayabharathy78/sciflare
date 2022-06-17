import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sciflare/helper/local_database_dao.dart';
import 'package:sciflare/student_obj.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: StudentScreen(),
    );
  }
}

Future<List<StudentObj>>? getStudentFuture;

class StudentScreen extends StatelessWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureListView(),
    );
  }
}


class FutureListView extends StatefulWidget {
  const FutureListView({Key? key}) : super(key: key);

  @override
  State<FutureListView> createState() => _FutureListViewState();
}


class _FutureListViewState extends State<FutureListView> {
  var dao = LocalDatabaseDao();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      dao.getStudentFromLocal().then((value){
        if(value.isEmpty){
          getStudentFuture = getStudentsFromServer();
        }else{
          getStudentFuture = getStudentsFromLocal();
        }
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: getStudentFuture,
        builder: (context, AsyncSnapshot snapshot) {
          print(snapshot);
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            var _data = snapshot.data;
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return StudentTile(studentObj: _data[index]);
                });
          }
        }
    );
  }

  Future<List<StudentObj>> getStudentsFromLocal() async {
    print("Load from local");
    return dao.getStudentFromLocal();
  }

  Future<List<StudentObj>> getStudentsFromServer() async{
    print("Load from server");

    var response = await http
        .get(Uri.parse("https://crudcrud.com/api/78d9e0edf72a4d2eb7a577fa61c1e729/jayabarathy"), headers: {"Accept": "application/json"});
    List res = json.decode(response.body);
    // print(res);
    if (response.statusCode == 200) {
      print("status 200");
    // return json.decode(response.body);
      var data = res.map((job) => StudentObj.fromJson(job)).toList();
      dao.insertStudentList(data);
    // return dao.getStudentFromLocal();
      return data;
    } else {
    throw Exception('Failed to load student');
    }
  }
}

class StudentTile extends StatelessWidget {
  const StudentTile({Key? key, required this.studentObj,}) : super(key: key);

  final StudentObj studentObj;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(studentObj.name ?? ""),
              Text(studentObj.gender ?? "")
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(studentObj.email ?? ""),
              Text(studentObj.mobile ?? "")
            ],
          ),
        ],
      ),
    );
  }
}


class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.products,
  }) : super(key: key);

  final StudentObj products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width*0.7,
              child: Text(
                products.name ?? "",
                style: TextStyle(color: Colors.black, fontSize: 18),
                maxLines: 2,
              ),
            ),
            SizedBox(height: 10),
            Text("\$${products.gender}",style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.green,fontSize: 20),),

          ],
        )
      ],
    );
  }
}