import 'package:cloud_firestore/cloud_firestore.dart';

class EntryModel {
  String? uid;
  String? date;
  String? title;
  String? text;

  EntryModel({this.uid, this.date, this.title, this.text});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'title': title,
      'text': text,
    };
  }

  EntryModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        date = doc.data()!["date"],
        title = doc.data()!["title"],
        text = doc.data()!["text"];
 

  EntryModel copyWith({
    String? uid,
    String? date,
    String? title,
    String? text,
  }) {
    return EntryModel(
      uid: uid ?? this.uid,
      date: date ?? this.date,
      title: title ?? this.title,
      text: text ?? this.text
    );
  }
}
