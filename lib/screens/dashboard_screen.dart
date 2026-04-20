import 'package:flutter/material.dart';
import 'add_income_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PocketFlow Dashboard"),
      ),

      body: const Center(
        child: Text(
          "Dashboard พร้อมใช้งาน",
          style: TextStyle(fontSize: 18),
        ),
      ),

      // 👇 ปุ่ม + กลางจอ
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading:
                          const Icon(Icons.arrow_downward, color: Colors.green),
                      title: const Text("เพิ่มรายรับ"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddIncomeScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.arrow_upward, color: Colors.red),
                      title: const Text("เพิ่มรายจ่าย (ยังไม่ทำ)"),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
