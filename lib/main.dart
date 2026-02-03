import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import màn hình theo tuần
import 'week1/week1_screen.dart';
import 'week2/week2_screen.dart';
import 'week3/week3_screen.dart';
import 'week3/week3_payment.dart';
import 'week3/week3_library_management.dart';
import 'week4/week4_ui_first_app.dart';
import 'week4/week4_list_ui_component.dart';
import 'week5/week5_lazy_column.dart';
import 'week5/week5_navigation_oop.dart';
import 'week5/week5_data_flow_navigation.dart';
import 'week6/week6_google.dart';
import 'week7/week7-callApi.dart';
import 'week8/week8_screen_smart_task.dart';
import 'week9/views/task_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBjoeGBuEqU4bMfP_XDQKUjgLV3wqgW3Hs", // Copy từ Firebase Console
      authDomain: "flutter-exercise-81b3c.firebaseapp.com",
      projectId: "flutter-exercise-81b3c",
      storageBucket: "flutter-exercise-81b3c.firebasestorage.app",
      messagingSenderId: "818434110540",
      appId: "1:818434110540:web:7ef6c4d01ef625c2a030e9",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      // home:  Week1Screen(), //tuan 1
      // home:  Week2Screen(), //tuan 2
      // home: Practice3Screen(), 
      // home: EmailValidationScreen(), // tuan 3
      // home: const PaymentScreen(), //tuan 3
      // home: const LibraryManagementScreen(), //tuan 3
      //  home: const UiFirstApp(), //tuan 4
      //  home: const ListUiComponent(), //tuan 4
      // home: const Lazy_column(), //tuan 5
      // home: const NavigationOop(), //tuan 5
      // home: const DataFlowNavigation(), //tuan 5
      // home:  FirebasePracticeScreen(), //tuan 6
      // home:  CallApi(), //tuan 7
      //  home:  SmartTaskScreen(), //tuan 8
      home: const TaskListPage(), //tuan 9
    );
  }
}
