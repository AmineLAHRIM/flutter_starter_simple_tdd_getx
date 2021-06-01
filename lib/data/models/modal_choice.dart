import 'package:equatable/equatable.dart';

class ModalChoice extends Equatable {
  int? id;
  String? name;

  ModalChoice({this.id, this.name});

  @override
  // TODO: implement props
  List<Object?> get props => [id, name];

  @override
  // TODO: implement stringify
  bool get stringify => true;
}
