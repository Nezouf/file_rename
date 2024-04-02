import 'package:file_rename/bloc/option_cubit.dart';
import 'package:file_rename/models/film_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilmTile extends StatefulWidget {
  const FilmTile({super.key, required this.filmFile});

  final FilmFile filmFile;

  @override
  FilmTileState createState() => FilmTileState();
}

class FilmTileState extends State<FilmTile> {
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 400,
            child: TextFormField(
                initialValue: widget.filmFile.filmName,
                onChanged: (value) {
                  widget.filmFile.filmName = value;
                }),
          ),
          const SizedBox(width: 20),
          Column(
            children: [
              SizedBox(
                width: 800,
                child: Wrap(
                  children: [
                    for (var actor in widget.filmFile.actorList)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Chip(
                            label: Text(actor),
                            onDeleted: () {
                              setState(() {
                                widget.filmFile.actorList.remove(actor);
                              });
                            }),
                      )
                  ],
                ),
              ),
              SizedBox(
                width: 200,
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    final optionList = context
                        .read<OptionCubit>()
                        .getOptionList(OptionType.actor);
                    return optionList.where((String option) {
                      return option
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    }).toList();
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController fieldTextEditingController,
                      FocusNode fieldFocusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      onSubmitted: (String value) {
                        setState(() {
                          print('Submitted $value');
                          widget.filmFile.actorList.add(value);
                        });
                        onFieldSubmitted();
                        fieldTextEditingController.text = '';
                        fieldFocusNode.requestFocus();
                      },
                    );
                  },
                  onSelected: (String value) {
                    setState(() {
                      print('onSelected $value');
                      widget.filmFile.actorList.last = value;
                    });
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
