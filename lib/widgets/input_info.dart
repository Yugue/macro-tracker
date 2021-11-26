// Copyright 2021 The Author. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/gender.dart';
import '../models/policies.dart';

class InputInfo extends StatefulWidget {
  const InputInfo({Key? key}) : super(key: key);

  @override
  _InputInfoState createState() => _InputInfoState();

  static const Map<Gender, String> genderStr = <Gender, String>{
    Gender.male: 'Male',
    Gender.female: 'Female',
  };
}

class _InputInfoState extends State<InputInfo> {
  late int _weight;
  Gender? _gender;
  final List<bool> _plan = <bool>[false, false];
  double? _proteinGoal;

  double calculateProt() {
    return _weight *
        (_gender == Gender.male ? maleProtPoundRatio : femaleProtPoundRatio) *
        (_plan[0] ? bulkingProtFactor : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            setState(() {
              _proteinGoal = calculateProt();
            });
          },
        ),
        if (_proteinGoal != null) SelectableText(_proteinGoal.toString()),
      ],
    );
  }
}
