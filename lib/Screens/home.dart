import 'package:attendance_manager/Models/Subject.dart';
import 'package:attendance_manager/Screens/info.dart';
import 'package:attendance_manager/Services/AuthManager.dart';
import 'package:attendance_manager/Services/CRUD.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  FirebaseUser user;
  var subjects;
  var allSubjects;
  final auth = FirebaseAuth.instance;

  initializeData() async {
    user = await getCurrentUser();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        leading: Icon(Icons.home),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Info(allSubjects)));
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await signOutGoogle(context);
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: initializeData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return attendance();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => addSubjectDialog(),
      ),
    );
  }

  addSubjectDialog() {
    String subjectName;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'Enter subject name'),
              onChanged: (value) => (subjectName = value),
            ),
            title: Text('Add subject'),
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await createSubject(subjectName, user.email);
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget attendance() {
    return StreamBuilder(
        stream: getSubjects(user.email),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            allSubjects = snapshot.data.documents[0].data['subjects'];

            if (allSubjects.length == 0) {
              return Center(
                child: Text("Click '+' icon to add subjects"),
              );
            }
            return ListView.separated(
                separatorBuilder: (context, index) =>
                    Divider(height: 1.0, color: Colors.grey),
                itemBuilder: (context, index) {
                  Subject subject = Subject.fromJson(allSubjects[index]);
                  int total = subject.present + subject.absent;

                  double percent =
                      (total != 0) ? ((subject.present * 100 / total)) : 0;
                  percent = double.parse(percent.toStringAsFixed(2));

                  var color = (percent < 75.0) ? Colors.red : Colors.black;
                  return ListTile(
                    title: Text(
                      '${subject.name}: $percent%',
                      style: TextStyle(color: color),
                    ),
                    subtitle: Text('Attendance: ${subject.present}/$total',
                        style: TextStyle(color: color)),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 35,
                          ),
                          onPressed: () async {
                            await updateAttendance(
                                user.email, index, 'present', allSubjects);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.red,
                            size: 35,
                          ),
                          onPressed: () async {
                            await updateAttendance(
                                user.email, index, 'absent', allSubjects);
                          },
                        )
                      ],
                    ),
                    onLongPress: () async {
                      await deleteSubject(user.email, index, allSubjects);
                    },
                  );
                },
                itemCount: allSubjects.length);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
