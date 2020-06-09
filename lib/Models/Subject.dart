import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';

class Subject {
  String name;
  int present;
  int absent;

  Subject(this.name, this.present, this.absent);

  Subject.fromSnapshot(DataSnapshot snapshot)
      : name = snapshot.value["name"],
        present = snapshot.value["present"],
        absent = snapshot.value["absent"];

  Subject.fromJson(LinkedHashMap<dynamic, dynamic> data)
      : name = data["name"],
        present = data["present"],
        absent = data["absent"];

  toJson() {
    return {"name": name.toUpperCase(), "present": present, "absent": absent};
  }
}
