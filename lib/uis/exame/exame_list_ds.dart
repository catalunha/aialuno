import 'package:aialuno/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:aialuno/models/classroom_model.dart';
import 'package:aialuno/models/exame_model.dart';

class ExameListDS extends StatefulWidget {
  final ClassroomModel classroomRef;
  final List<ExameModel> exameList;
  final List<TaskModel> taskList;
  final Function(String) onTaskList;
  // final Function(String) onTaskListOpen;
  const ExameListDS({
    Key key,
    this.exameList,
    this.onTaskList,
    // this.onTaskListOpen,
    this.classroomRef,
    this.taskList,
  }) : super(key: key);

  @override
  _ExameListDSState createState() => _ExameListDSState();
}

class _ExameListDSState extends State<ExameListDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '/${widget.classroomRef.name}: com ${widget.exameList.length} exame(s).'),
        actions: [
          // LogoutButton(),
        ],
      ),
      body: ListView(
        children: buildItens(context),
      ),
      // body: Column(
      //   children: [
      //     Expanded(
      //       child: ReorderableListView(
      //         scrollDirection: Axis.vertical,
      //         children: buildItens(),
      //         onReorder: _onReorder,
      //       ),
      //     ),
      //   ],
      // ),
      // body: Center(
      //   child: Container(
      //     width: 600,
      //     child: ListView.builder(
      //       itemCount: widget.exameList.length,
      //       itemBuilder: (context, index) {
      //         final exame = widget.exameList[index];
      //         return Card(
      //           child: Row(
      //             // alignment: WrapAlignment.spaceEvenly,
      //             children: [
      //               Expanded(
      //                 flex: 6,
      //                 child: ListTile(
      //                   title: Text('${exame.name}'),
      //                   subtitle: Text('${exame.toString()}'),
      //                 ),
      //               ),
      //               Expanded(
      //                   flex: 2,
      //                   child: Column(children: [
      //                     IconButton(
      //                       tooltip: 'Editar esta avaliação',
      //                       icon: Icon(Icons.edit),
      //                       onPressed: () async {
      //                         widget.onEditExameCurrent(exame.id);
      //                       },
      //                     ),
      //                     IconButton(
      //                       tooltip: 'Lista de questões',
      //                       icon: Icon(Icons.format_list_numbered),
      //                       onPressed: () async {
      //                         widget.onQuestionList(exame.id);
      //                       },
      //                     ),
      //                     // IconButton(
      //                     //   tooltip: 'Lista de estudantes',
      //                     //   icon: Icon(Icons.person),
      //                     //   onPressed: () async {
      //                     //     widget.onStudentList(exame.id);
      //                     //   },
      //                     // ),
      //                   ])),
      //             ],
      //           ),
      //         );
      //       },
      //     ),
      //   ),
      // ),
    );
  }

  List<Widget> buildItens(BuildContext context) {
    List<Widget> list = [];

    for (var exame in widget.exameList) {
      int index = widget.taskList
          .indexWhere((task) => task.isOpen && task.exameRef.id == exame.id);
      list.add(
        Card(
          child: ListTile(
            selected: index >= 0 ? true : false,
            title: Text('${exame.name}'),
            subtitle: Text('${exame.toString()}'),
            trailing: IconButton(
              tooltip: 'Tarefas para desenvolvimento',
              icon: Icon(Icons.assignment),
              onPressed: () async {
                widget.onTaskList(exame.id);
              },
            ),
          ),
        ),
        // Row(
        //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   // crossAxisAlignment: CrossAxisAlignment.center,
        //   // alignment: WrapAlignment.spaceEvenly,
        //   children: [
        //     Expanded(
        //       flex: 6,
        //       child: ListTile(
        //         selected: index >= 0 ? true : false,
        //         title: Text('${exame.name}'),
        //         subtitle: Text('${exame.toString()}'),
        //       ),
        //     ),
        //     Expanded(
        //         flex: 2,
        //         child: Column(children: [
        //           // IconButton(
        //           //   tooltip: 'Histórico de tarefas',
        //           //   icon: Icon(Icons.folder_open),
        //           //   onPressed: () async {
        //           //     widget.onTaskList(exame.id);
        //           //   },
        //           // ),
        //           IconButton(
        //             tooltip: 'Tarefas para desenvolvimento',
        //             icon: Icon(Icons.assignment),
        //             onPressed: () async {
        //               widget.onTaskListOpen(exame.id);
        //             },
        //           ),
        //         ])),
        //   ],
        // ),
      );
    }
    return list;
  }
  // List<Widget> buildItens(BuildContext context) {
  //   List<Widget> list = [];

  //   for (var exame in widget.exameList) {
  //     int index = widget.taskList
  //         .indexWhere((task) => task.exameRef.id == exame.id && task.isOpen);
  //     list.add(
  //       Card(
  //         key: ValueKey(exame),
  //         child: Container(
  //           // width: 600,
  //           // height: 200,
  //           child: Row(
  //             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             // crossAxisAlignment: CrossAxisAlignment.center,
  //             // alignment: WrapAlignment.spaceEvenly,
  //             children: [
  //               Expanded(
  //                 flex: 6,
  //                 child: ListTile(
  //                   selected: index >= 0 ? true : false,
  //                   title: Text('${exame.name}'),
  //                   subtitle: Text('${exame.toString()}'),
  //                 ),
  //               ),
  //               Expanded(
  //                   flex: 2,
  //                   child: Column(children: [
  //                     // IconButton(
  //                     //   tooltip: 'Histórico de tarefas',
  //                     //   icon: Icon(Icons.folder_open),
  //                     //   onPressed: () async {
  //                     //     widget.onTaskList(exame.id);
  //                     //   },
  //                     // ),
  //                     IconButton(
  //                       tooltip: 'Tarefas para desenvolvimento',
  //                       icon: Icon(Icons.assignment),
  //                       onPressed: () async {
  //                         widget.onTaskListOpen(exame.id);
  //                       },
  //                     ),
  //                   ])),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //   return list;
  // }
}
