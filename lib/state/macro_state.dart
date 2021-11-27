// Copyright 2021 The Author. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../models/macros.dart';

class MacroState extends ChangeNotifier {
  Map<Macros, double>? macrosGoal;

  void updateMacro(Macros field, double value) {
    macrosGoal?[field] = value;

    print(macrosGoal?[field]);
    notifyListeners();
  }
}
