import 'package:depi_project/core/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_project/features/home/presnetation/view/home_screen.dart';
import 'package:depi_project/features/home/cubit/home_cubit.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => HomeCubit(ApiService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    ),
  );
}
