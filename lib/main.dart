// Copyright 2021 The Author. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/macro_state.dart';
import 'widgets/input_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MacroState(),
      child: MaterialApp(
        title: 'Macro Tracker',
        home: Scaffold(
          appBar: AppBar(title: const Text('A simple Macro Tracker'), actions: []),
          body: const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: InputInfo(),
          ),
        ),
      ),
    );
  }
}
