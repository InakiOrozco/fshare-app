part of 'my_content_bloc.dart';

abstract class MyContentEvent extends Equatable {
  const MyContentEvent();

  @override
  List<Object> get props => [];
}

class GetAllMyFotosEvent extends MyContentEvent {}

class OnEditDataEvent extends MyContentEvent {
  final Map<String, dynamic> dataToEdit;

  OnEditDataEvent({required this.dataToEdit});
  @override
  List<Object> get props => [dataToEdit];
}
