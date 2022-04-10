import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'my_content_event.dart';
part 'my_content_state.dart';

class MyContentBloc extends Bloc<MyContentEvent, MyContentState> {
  MyContentBloc() : super(MyContentInitial()) {
    on<MyContentEvent>(_getMyDisabledContent);
    on<OnEditDataEvent>(_EditContent);
  }

  FutureOr<void> _getMyDisabledContent(event, emit) async {
    emit(MyContentLoadingState());
    try {
      // query para traer el documento con el id del usuario autenticado
      var queryUser = await FirebaseFirestore.instance
          .collection("user")
          .doc("${FirebaseAuth.instance.currentUser!.uid}");

      // query para sacar la data del documento
      var docsRef = await queryUser.get();

      var listIds = docsRef.data()?["fotosListId"];

      // query para sacar documentos de fshare
      var queryFotos =
          await FirebaseFirestore.instance.collection("fshare").get();

      // query de Dart filtrando la info utilizando como referencia la lista de ids de docs del usuario actual
      var myContentList =
          queryFotos.docs.where((doc) => listIds.contains(doc.id)).map((doc) {
        var obj = doc.data().cast<String, dynamic>();
        obj["id"] = doc.id;
        return obj;
      }).toList();

      // lista de documentos filtrados del usuario con sus datos de fotos en espera
      emit(MyContentSuccessState(myData: myContentList));
    } catch (e) {
      print("Error al obtener items en espera: $e");
      emit(MyContentErrorState());
      emit(MyContentEmptyState());
    }
  }

  FutureOr<void> _EditContent(event, emit) async {
    print("Se está ejecutando _EditContent");
    emit(MyContentUploadState());
    bool updated = await _uploadEditedData(event.dataToEdit);
  }

  Future<bool> _uploadEditedData(dataToEdit) async {
    print("Se está ejecutando _uploadEditedData");
    var reference = await FirebaseFirestore.instance.collection("fshare");
    try {
      reference
          .doc(dataToEdit["id"])
          .update(dataToEdit)
          .then((value) => print("Data updated"))
          .catchError((error) => (print("Error updating: $error")));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
