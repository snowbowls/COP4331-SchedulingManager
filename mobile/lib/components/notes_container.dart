import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/global_data.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/components/rounded_button.dart';

class NotesCard extends StatelessWidget {
  final String email;
  final String firstName;
  final String lastName;
  final String name;

  const NotesCard({
    required this.email,
    required this.name,
    this.firstName = '',
    this.lastName = '',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _NotesTitle(
          name: this.name,
      ),
      titlePadding: EdgeInsets.zero,
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return _NotesBody(
            email: this.email,
            // jobNotesKey: widget.key!,
          );
        },
      ),
      contentPadding: EdgeInsets.zero,
      // actions: <Widget>[
      //   _JobNotesActions(jobId: this.jobId),
      // ],
      backgroundColor: CustomColors.grey,
      clipBehavior: Clip.hardEdge,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class _NotesTitle extends StatelessWidget {
  final String name;

  _NotesTitle({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: CustomColors.orange,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'Notes by ' + this.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomColors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesBody extends StatefulWidget {
  final String email;

  _NotesBody({
    required this.email,
  });

  @override
  _NotesBodyState createState() => _NotesBodyState();
}

class _NotesBodyState extends State<_NotesBody> {
  List<Widget> _notes = [];

  @override
  void initState() {
    super.initState();
    _searchNotes(
      {
        'email': widget.email,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _notes,
    );
  }

  void _addNote(Map _payload) {
    if (_payload['firstName'] == null ||
        _payload['lastName'] == null ||
        _payload['note'] == null ||
        _payload['title'] == null ||
        _payload['date'] == null) return;
    setState(
      () {
        _notes.add(
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${_payload['title']}',
                        style: TextStyle(
                          color: CustomColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _payload['date'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: CustomColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  _payload['note'],
                  style: TextStyle(
                    color: CustomColors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Map sample1 = {
    'firstName': 'Cameron',
    'lastName': 'Nichols',
    'date': '2021-07-03',
    'note': 'This is a short note.'
  };

  Map sample2 = {
    'firstName': 'John',
    'lastName': 'Doe',
    'date': '2021-08-29',
    'note': 'This is a longer example note that had nothing to do with anything. '
        'Life is meaningless if you really think about it. '
        'But you have to create your own meaning and use that as your guidance',
  };

  void _searchNotes(Map _payload) async {
    print('searchNotes!');
    String dir = '/searchIndividualNotes';
    String ret = await API.getJson(dir, _payload);
    print(ret);
    var jsonObj = json.decode(ret);
    print(jsonObj);
    if (ret.isEmpty) {
      print('oh no :(');
    } else {
      setState(
        () {
          print('searchNotes successful!');
          for (var note in jsonObj['notes']) {
            _addNote(note);
          }
        },
      );
    }
  }
}
