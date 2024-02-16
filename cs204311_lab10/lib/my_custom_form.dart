import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  /// A global key that uniquely identifies the Form widget and allows
  /// validation of the form.
  final _formKey = GlobalKey<FormState>();

  String district = '';
  String tambon = '';

  List<String> _districtList = [];
  List<List<dynamic>> _tambonList = [];

  Future<void> loadCsv() async {
    final input = await rootBundle.loadString('assets/tambon_chiangmai.csv');
    final data = const CsvToListConverter().convert(input);
    _districtList = processDistrict(data);
    _tambonList = processTambon(data);
  }

  List<String> processDistrict(List<List<dynamic>> data) {
    List<String> districtListProcess = [];
    final districtRaw = data.map((e) => e[1]);
    districtRaw.forEach((element) {
      if(!districtListProcess.contains(element)){
        districtListProcess.add(element);
      }
    });
    return districtListProcess.sublist(1);
  }

  List<List<dynamic>> processTambon(List<List<dynamic>> data) {
    final tambonRaw = data.map((e) => e);
    return tambonRaw.toList().sublist(1);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCsv();
  }
  /// Builds the widget tree for the `MyCustomForm` widget.
  ///
  /// This method is responsible for creating the widget tree that represents
  /// the `MyCustomForm` widget. It returns a `Form` widget that contains two
  /// `Autocomplete` widgets for district and tambon selection.
  ///
  /// The `Autocomplete` widgets use the `districtOptionsBuilder` and
  /// `tambonOptionsBuilder` methods to build their list of options, and the
  /// `onDistrictSelected` and `onTambonSelected` methods to handle the
  /// selection of an option.
  ///
  /// Returns a `Form` widget that represents the `MyCustomForm` widget.
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text('Enter District:'),
          Autocomplete(
            optionsBuilder: districtOptionsBuilder,
            onSelected: onDistrictSelected,
          ),
          const Text('Enter Tambon:'),
          Autocomplete(
            optionsBuilder: tambonOptionsBuilder,
            onSelected: onTambonSelected,
          ),
        ],
      ),
    );
  }

  /// Builds the options for the district autocomplete field.
  ///
  /// This method takes a [TextEditingValue] as input, which represents the
  /// current text in the autocomplete field. It uses this value to filter the
  /// district data and return a list of options that contain the input text.
  ///
  /// If the input text is empty, this method returns an empty iterable.
  Iterable<Object> districtOptionsBuilder(TextEditingValue textEditingValue) {
    if (textEditingValue.text == '') {
      return const Iterable<String>.empty();
    }
    return _districtList.where((String option) {
      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
    });
  }

  /// Updates the `district` variable with the selected option.
  ///
  /// This method is called when a district is selected in the autocomplete
  /// field.
  void onDistrictSelected(Object option) {
    setState(() {
      district = option.toString();
    });
  }

  /// Builds the options for the tambon autocomplete field.
  ///
  /// This method takes a [TextEditingValue] as input, which represents the
  /// current text in the autocomplete field. It uses this value and [district]
  /// to filter the tambon data and return a list of options that contain the
  /// input text.
  ///
  /// If the input text is empty, this method returns an empty iterable.
  Iterable<Object> tambonOptionsBuilder(TextEditingValue textEditingValue) {
    if (textEditingValue.text == '') {
      return const Iterable<String>.empty();
    }

    final findDistrict = _tambonList.where((element) => element[1].toString().toLowerCase().contains(district.toLowerCase()));

    return findDistrict.where((element) => element.toString().toLowerCase().contains(textEditingValue.text.toLowerCase())).map((e) => e[0]);
  }

  /// Updates the `tambon` variable with the selected option.
  ///
  /// This method is called when a tambon is selected in the autocomplete field.
  void onTambonSelected(Object option) {
    setState(() {
      tambon = option.toString();
    });
  }
}
