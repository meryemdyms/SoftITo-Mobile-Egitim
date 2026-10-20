import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/di/app_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppProviders(child: CarRentalApp()));
}
