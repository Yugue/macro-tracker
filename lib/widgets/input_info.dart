// Copyright 2021 The Author. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/gender.dart';
import '../models/macros.dart';
import '../models/policies.dart';
import '../state/macro_state.dart';

class InputInfo extends StatefulWidget {
  const InputInfo({Key? key}) : super(key: key);

  @override
  _InputInfoState createState() => _InputInfoState();

  static const Map<Gender, String> genderStr = <Gender, String>{
    Gender.male: 'Male',
    Gender.female: 'Female',
  };
  static const Map<Macros, String> macroStr = <Macros, String>{
    Macros.protein: 'Protein',
    Macros.carb: 'Carbohydrate',
    Macros.fat: 'Fat',
  };
}

class _InputInfoState extends State<InputInfo> {
  late int _weight;
  Gender? _gender;
  final List<bool> _plan = <bool>[false, false];
  double? _proteinGoal;
  double? _carbGoal;
  double? _fatGoal;

  double calculateProt() {
    return _weight *
        (_gender == Gender.male ? maleProtPoundRatio : femaleProtPoundRatio) *
        (_plan[0] ? bulkingProtFactor : notBulkingProtFactor);
  }

  double calculateCarb() {
    return _weight *
        (_gender == Gender.male ? maleProtPoundRatio : femaleProtPoundRatio) *
        (_plan[0] ? bulkingProtFactor : notBulkingProtFactor);
  }

  double calculateFat() {
    return _weight *
        (_gender == Gender.male ? maleProtPoundRatio : femaleProtPoundRatio) *
        (_plan[0] ? bulkingProtFactor : notBulkingProtFactor);
  }

  @override
  Widget build(BuildContext context) {
    final Map<Macros, double>? macrosGoal = context.watch<MacroState>().macrosGoal;

    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(labelText: "Enter your weight (lbs)"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            onChanged: (String data) {
              setState(() {
                _weight = int.parse(data);
              });
            },
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              Text(
                'Enter your gender',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey[700]),
              ),
              const SizedBox(width: 40.0),
              DropdownButton<Gender>(
                hint: Text('-', style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey[700])),
                // value: releaseData[substepName],
                icon: const Icon(Icons.arrow_downward),
                items: Gender.values.map<DropdownMenuItem<Gender>>((Gender gender) {
                  return DropdownMenuItem<Gender>(
                    value: gender,
                    child: Text(InputInfo.genderStr[gender]!),
                  );
                }).toList(),
                onChanged: (Gender? newValue) {
                  setState(() {
                    _gender = newValue!;
                  });
                },
                value: _gender,
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          ToggleButtons(
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Bulking'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Cutting'),
              ),
            ],
            onPressed: (int index) {
              setState(() {
                _plan[index] = !_plan[index];
              });
            },
            isSelected: _plan,
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            child: const Text('Calculate'),
            onPressed: () {
              context.read<MacroState>().updateMacro(Macros.protein, calculateProt());
              context.read<MacroState>().updateMacro(Macros.carb, calculateCarb());
              context.read<MacroState>().updateMacro(Macros.fat, calculateFat());
              // setState(() {
              //   _proteinGoal = calculateProt();
              // });
              // setState(() {
              //   _carbGoal = calculateCarb();
              // });
              // setState(() {
              //   _fatGoal = calculateFat();
              // });
            },
          ),
          const SizedBox(height: 40.0),
          Table(
            children: <TableRow>[
              for (MapEntry macroElement in InputInfo.macroStr.entries)
                TableRow(children: <Widget>[
                  Center(child: Text('${macroElement.value}:')),
                  Center(
                    child: SelectableText(macrosGoal?[macroElement.key].toString() ?? 'unknown'),
                  ),
                ])
            ],
          )
        ],
      ),
    );
  }
}
