import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/firestore_repository.dart';
import 'bloc/pagination_bloc.dart';
import 'ui/pagination_list.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaginationBloc(repository: FirestoreRepository()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PaginationList(),
      ),
    );
  }
}

