import 'package:aialuno/models/classroom_model.dart';
import 'package:aialuno/models/exame_model.dart';
import 'package:aialuno/models/firestore_model.dart';
import 'package:aialuno/models/question_model.dart';
import 'package:aialuno/models/simulation_model.dart';
import 'package:aialuno/models/situation_model.dart';
import 'package:aialuno/models/user_model.dart';
import 'package:intl/intl.dart';

class TaskModel extends FirestoreModel {
  static final String collection = "task";
  UserModel teacherUserRef;
  ClassroomModel classroomRef;
  ExameModel exameRef;
  QuestionModel questionRef;
  SituationModel situationRef;
  UserModel studentUserRef;
  //dados do exame
  dynamic start;
  dynamic end;
  int scoreExame;
  //dados da questao
  int attempt;
  int time;
  int error;
  int scoreQuestion;
  // gestão da tarefa
  dynamic started;
  dynamic lastSendAnswer;
  dynamic attempted;
  //isOpen=true quando criada
  //isOpen=false Se end < now. Se responderAte < now. Se tentou < tentativa
  bool isOpen;
  Map<String, Input> simulationInput = Map<String, Input>();
  Map<String, Output> simulationOutput = Map<String, Output>();

  TaskModel(
    String id, {
    this.teacherUserRef,
    this.classroomRef,
    this.exameRef,
    this.questionRef,
    this.situationRef,
    this.studentUserRef,
    this.start,
    this.end,
    this.scoreExame,
    this.attempt,
    this.time,
    this.error,
    this.scoreQuestion,
    this.started,
    this.lastSendAnswer,
    this.attempted,
    this.isOpen,
    this.simulationInput,
    this.simulationOutput,
  }) : super(id);

  @override
  TaskModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('teacherUserRef') && map['teacherUserRef'] != null)
      teacherUserRef =
          UserModel(map['teacherUserRef']['id']).fromMap(map['teacherUserRef']);
    if (map.containsKey('classroomRef') && map['classroomRef'] != null)
      classroomRef = ClassroomModel(map['classroomRef']['id'])
          .fromMap(map['classroomRef']);
    if (map.containsKey('exameRef') && map['exameRef'] != null)
      exameRef = ExameModel(map['exameRef']['id']).fromMap(map['exameRef']);
    if (map.containsKey('questionRef') && map['questionRef'] != null)
      questionRef =
          QuestionModel(map['questionRef']['id']).fromMap(map['questionRef']);
    if (map.containsKey('situationRef') && map['situationRef'] != null)
      situationRef = SituationModel(map['situationRef']['id'])
          .fromMap(map['situationRef']);
    if (map.containsKey('studentUserRef') && map['studentUserRef'] != null)
      studentUserRef =
          UserModel(map['studentUserRef']['id']).fromMap(map['studentUserRef']);

    start = map.containsKey('start') && map['start'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['start'].millisecondsSinceEpoch)
        : null;
    end = map.containsKey('end') && map['end'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['end'].millisecondsSinceEpoch)
        : null;
    if (map.containsKey('scoreExame')) scoreExame = map['scoreExame'];
    if (map.containsKey('attempt')) attempt = map['attempt'];
    if (map.containsKey('time')) time = map['time'];
    if (map.containsKey('error')) error = map['error'];
    if (map.containsKey('scoreQuestion')) scoreQuestion = map['scoreQuestion'];
    started = map.containsKey('started') && map['started'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['started'].millisecondsSinceEpoch)
        : null;
    lastSendAnswer =
        map.containsKey('lastSendAnswer') && map['lastSendAnswer'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                map['lastSendAnswer'].millisecondsSinceEpoch)
            : null;
    if (map.containsKey('attempted')) attempted = map['attempted'];
    if (map.containsKey('isOpen')) isOpen = map['isOpen'];
    if (map["simulationInput"] is Map) {
      simulationInput = Map<String, Input>();
      for (var item in map["simulationInput"].entries) {
        simulationInput[item.key] = Input(item.key).fromMap(item.value);
      }
    }
    if (map["simulationOutput"] is Map) {
      simulationOutput = Map<String, Output>();
      for (var item in map["simulationOutput"].entries) {
        simulationOutput[item.key] = Output(item.key).fromMap(item.value);
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teacherUserRef != null) {
      data['teacherUserRef'] = this.teacherUserRef.toMapRef();
    }
    if (this.classroomRef != null) {
      data['classroomRef'] = this.classroomRef.toMapRef();
    }
    if (this.exameRef != null) {
      data['exameRef'] = this.exameRef.toMapRef();
    }
    if (this.questionRef != null) {
      data['questionRef'] = this.questionRef.toMapRef();
    }
    if (this.situationRef != null) {
      data['situationRef'] = this.situationRef.toMapRef();
    }
    if (this.studentUserRef != null) {
      data['studentUserRef'] = this.studentUserRef.toMapRef();
    }
    data['start'] = this.start;
    data['end'] = this.end;
    if (scoreExame != null) data['scoreExame'] = this.scoreExame;
    if (attempt != null) data['attempt'] = this.attempt;
    if (time != null) data['time'] = this.time;
    if (error != null) data['error'] = this.error;
    if (scoreQuestion != null) data['scoreQuestion'] = this.scoreQuestion;
    data['started'] = this.started;
    data['lastSendAnswer'] = this.lastSendAnswer;
    if (attempted != null) data['attempted'] = this.attempted;
    if (isOpen != null) data['isOpen'] = this.isOpen;

    if (simulationInput != null && simulationInput is Map) {
      data["simulationInput"] = Map<String, dynamic>();
      for (var item in simulationInput.entries) {
        data["simulationInput"][item.key] = item.value.toMap();
      }
    }
    if (simulationOutput != null && simulationOutput is Map) {
      data["simulationOutput"] = Map<String, dynamic>();
      for (var item in simulationOutput.entries) {
        data["simulationOutput"][item.key] = item.value.toMap();
      }
    }
    return data;
  }

  String quantidadeSingularPlural(
      dynamic quantidade, String singular, String plural) {
    if (quantidade == null) {
      return '0 $plural';
    } else if (quantidade == 1) {
      return '1 $singular';
    } else {
      return '$quantidade $plural';
    }
  }

  @override
  String toString() {
    String _return = '';
    _return = _return +
        'Situação: ${situationRef.name} (${situationRef.id.substring(0, 4)}).';
    _return = _return +
        '\nQuestão: ${questionRef.name} (${questionRef.id.substring(0, 4)}).';
    _return =
        _return + '\nExame: ${exameRef.name} (${exameRef.id.substring(0, 4)}).';
    _return = _return +
        '\nProfessor: ${teacherUserRef.name.split(' ')[0]} (${teacherUserRef.id.substring(0, 4)}).';
    _return = _return +
        '\nTurma: ${classroomRef.name} (${classroomRef.id.substring(0, 4)}).';
    _return = _return +
        '\nEstudante: ${studentUserRef.name.split(' ')[0]} (${studentUserRef.id.substring(0, 4)})';

    _return = _return +
        '\nInício: ${start != null ? DateFormat('dd-MM-yyyy kk:mm:ss').format(start) : ""}';
    _return = _return +
        '\nIniciou: ${started != null ? DateFormat('dd-MM-yyyy kk:mm:ss').format(started) : ""}';
    _return = _return +
        '\nÚltimo envio: ${lastSendAnswer != null ? DateFormat('dd-MM-yyyy kk:mm:ss').format(lastSendAnswer) : ""}';
    _return = _return +
        '\nFim: ${end != null ? DateFormat('dd-MM-yyyy kk:mm:ss').format(end) : ""}';
    _return = _return +
        '\nPeso do exame: $scoreExame. Peso da questão: $scoreQuestion.';
    // _return = _return + '\nscoreQuestion: $scoreQuestion';
    _return = _return + ' Tentativa: $attempted de $attempt.';
    // _return = _return + '\nattempted: $attempted';
    _return = _return + ' Tempo de resolução: $time h. Erro relativo: $error%.';
    // _return = _return + '\nerror: $error';
    _return = _return + '\nAberta: ${isOpen ? "Sim" : "Não"}';
    // _return = _return + '\nupdateIsOpen: $updateIsOpen';
    // _return = _return + '\nresponderAte: $responderAte';
    // _return = _return + '\ntempoPResponder: $tempoPResponder';

    _return = _return +
        '\n ** ${quantidadeSingularPlural(simulationInput?.length, "valor individual", "valores individuais")}:  ** ';
    // List<Input> _inputList = [];
    // if (simulationInput != null) {
    //   for (var item in simulationInput.entries) {
    //     _inputList.add(Input(item.key).fromMap(item.value.toMap()));
    //   }
    //   _inputList.sort((a, b) => a.name.compareTo(b.name));
    // }
    // for (var item in _inputList) {
    //   if (item.type == 'texto' || item.type == 'url') {
    //     _return = _return + '\n${item.name}=... [${item.type}]';
    //   } else {
    //     _return = _return + '\n${item.name}=${item.value} [${item.type}]';
    //   }
    // }
    //   _return = _return + '\n ** Saída: ${simulationOutput.length} ** ';
    // List<Output> _outputList = [];
    // if (simulationOutput != null) {
    //   for (var item in simulationOutput.entries) {
    //     _outputList.add(Output(item.key).fromMap(item.value.toMap()));
    //   }
    //   _outputList.sort((a, b) => a.name.compareTo(b.name));
    // }
    // for (var item in _outputList) {
    //   if (item.type == 'texto' || item.type == 'url') {
    //     _return = _return +
    //         '\n${item.name}=... [${item.type}=${item.value.length}c] ${item?.right != null ? item.right ? "Certo" : "Errado" : "Não corrigido"}';
    //   } else {
    //     _return = _return +
    //         '\n${item.name}=${item.value} [${item.type}] ${item?.right != null ? item.right ? "Certo" : "Errado" : "Não corrigido"}';
    //   }
    // }
    _return = _return +
        '\n ** ${quantidadeSingularPlural(simulationOutput?.length, "resposta", "respostas")}:  ** ';

    List<Output> _outputList = [];
    if (simulationOutput != null) {
      for (var item in simulationOutput.entries) {
        _outputList.add(Output(item.key).fromMap(item.value.toMap()));
      }
      _outputList.sort((a, b) => a.name.compareTo(b.name));
    }
    for (var item in _outputList) {
      if (item.type == 'texto' || item.type == 'url') {
        _return = _return +
            '\n${item.name}=... [${item.type}=${item?.answer == null ? "?" : item.answer.length}c] ${item?.right != null ? item.right ? "Confere" : "Não confere" : "Não corrigido"}';
      } else {
        _return = _return +
            '\n${item.name}=${item?.answer == null ? "?" : item.answer} [${item.type}] ${item?.right != null ? item.right ? "Confere" : "Não confere" : "Não corrigido"}';
      }
    }
    return _return;
  }

  bool get updateIsOpen {
    print('updateIsOpen...');
    if (this.isOpen && this.end.isBefore(DateTime.now())) {
      this.isOpen = false;
      print('==> Tarefa ${this.id}. isOpen=${this.isOpen}. Pois fim < now');
    }
    if (this.isOpen &&
        this.started != null &&
        // this.responderAte != null &&
        this.responderAte.isBefore(DateTime.now())) {
      this.isOpen = false;
      print(
          '==> Tarefa ${this.id}. isOpen=${this.isOpen}. Fechada pois responderAte < now');
    }
    if (this.isOpen &&
        this.attempted != null &&
        this.attempted >= this.attempt) {
      this.isOpen = false;
      print(
          '==> Tarefa ${this.id}. isOpen=${this.isOpen}. Fechada pois tentou < tentativa');
    }
    return this.isOpen;
  }

  /// Quando o usuario iniciou a tarefa e soma-se o tempo de resolução
  /// Started + time
  /// Exemplo:
  /// Start = 20201029 08:00:00
  /// Started = 20201030 14:00:00
  /// time  = 2
  /// responderAte = 20201030 16:00:00
  DateTime get responderAte {
    if (this.started != null) {
      return this.started.add(Duration(hours: this.time));
    } else {
      return null;
    }
  }

  // responderAte = Started+time
  // -------------------------------------------------
  // |Start
  //                                         |End
  //                       |Started    |responderAte
  // |now
  //                           [now    ]tempoPResponder
  dynamic get tempoPResponder {
    if (this.started == null) {
      return null;
    } else {
      if (this.end.isBefore(this.responderAte)) {
        return this.end.difference(DateTime.now());
      } else {
        return this.responderAte.difference(DateTime.now());
      }
    }
  }

  // void updateAll() {
  //   responderAte;
  //   tempoPResponder;
  //   updateIsOpen;
  // }
}
