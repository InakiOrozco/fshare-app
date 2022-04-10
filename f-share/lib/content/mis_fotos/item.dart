import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/my_content_bloc.dart';

class ItemCargado extends StatefulWidget {
  final Map<String, dynamic> nonPublicFData;
  ItemCargado({Key? key, required this.nonPublicFData}) : super(key: key);

  @override
  State<ItemCargado> createState() => _ItemCargadoState();
}

class _ItemCargadoState extends State<ItemCargado> {
  bool _defaultSwitchValue = false;
  var tCont = TextEditingController();
  var iCont = TextEditingController();

  @override
  void initState() {
    _defaultSwitchValue = widget.nonPublicFData["public"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .7,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                "${widget.nonPublicFData["picture"]}",
                fit: BoxFit.cover,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text("Edit:"),
                          content: Column(
                            children: [
                              TextField(
                                controller: tCont
                                  ..text = "${widget.nonPublicFData["title"]}",
                              ),
                              TextField(
                                controller: iCont
                                  ..text =
                                      "${widget.nonPublicFData["picture"]}",
                              ),
                              TextButton(
                                  onPressed: () {
                                    Map<String, dynamic> fshareUpdate =
                                        widget.nonPublicFData;
                                    fshareUpdate["picture"] = iCont.text;
                                    fshareUpdate["public"] =
                                        _defaultSwitchValue;
                                    fshareUpdate["title"] = tCont.text;
                                    BlocProvider.of<MyContentBloc>(context).add(
                                        OnEditDataEvent(
                                            dataToEdit: fshareUpdate));

                                    Navigator.pop(context, '');
                                  },
                                  child: Text("Submit changes"))
                            ],
                          ),
                        ));
              },
              child: const Text('Edit'),
            ),
            SwitchListTile(
              title: Text("${widget.nonPublicFData["title"]}"),
              subtitle: Text(
                  "${widget.nonPublicFData["publishedAt"].toDate().toString().substring(0, 10)}"),
              value: _defaultSwitchValue,
              onChanged: (newVal) {
                setState(() {
                  _defaultSwitchValue = newVal;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
