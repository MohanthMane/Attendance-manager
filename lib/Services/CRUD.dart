import 'package:attendance_manager/Models/Subject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

createSubject(String subjectName, String email) async {
  Subject subject = Subject(subjectName, 0, 0);

  var ref = Firestore.instance.collection('users').document(email);
  await ref.updateData({
    'subjects': FieldValue.arrayUnion([subject.toJson()])
  });
}

getSubjects(String email) {
  var stream = Firestore.instance
      .collection('/users')
      .where('email', isEqualTo: email)
      .snapshots();

  return stream;
}

updateAttendance(docId, index, type, subjects) async {
  DocumentReference ref =
      Firestore.instance.collection('users').document(docId);
  subjects[index][type] += 1;

  await ref.updateData({'subjects': subjects});
}

deleteSubject(docId, index, subjects) async {
  DocumentReference ref =
      Firestore.instance.collection('users').document(docId);
  subjects.removeAt(index);

  await ref.updateData({'subjects': subjects});
}
