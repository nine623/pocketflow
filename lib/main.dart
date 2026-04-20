import 'package:flutter/material.dart';
import 'database/category_db.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestPage(),
    );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  Future<void> _insert(BuildContext context) async {
    try {
      await CategoryDB.instance.insertCategory({
        'name': 'รถยนต์',
        'parentId': null,
        'iconPath': null,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เพิ่ม category สำเร็จ')),
      );

      print('เพิ่ม category แล้ว');
    } catch (e) {
      print('ERROR: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ERROR: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('TEST CATEGORY'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _insert(context), // 🔥 ตรงนี้สำคัญ
          child: const Text('เพิ่ม รถยนต์'),
        ),
      ),
    );
  }
}
