import 'package:flutter/material.dart';
import 'package:aialuno/models/user_model.dart';

class StudentListDS extends StatefulWidget {
  final List<UserModel> studentList;

  const StudentListDS({
    Key key,
    this.studentList,
  }) : super(key: key);

  @override
  _StudentListDSState createState() => _StudentListDSState();
}

class _StudentListDSState extends State<StudentListDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estudantes (${widget.studentList.length})'),
        actions: [
          // LogoutButton(),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.studentList.length,
        itemBuilder: (context, index) {
          final student = widget.studentList[index];
          return Card(
            child: ListTile(
              title: Text('${student.name}'),
              subtitle: Text('${student.toString()}'),
            ),
          );
        },
      ),
    );
  }
}
