import 'package:flutter/material.dart';
import 'package:gym/widgets/appbar.dart';
import '../services/day_services.dart';

class editdayname extends StatelessWidget {
  final int day_id;
  final String currentName;
  const editdayname({
    super.key,
    required this.day_id,
    required this.currentName,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: currentName,
    );
    return AppbarWidget(
      Title: "Rename day",
      ScafoldWidget: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "enter the name of the day:",
              ),
              style: TextStyle(color: Colors.white),
            ),
            Center(
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final newName = controller.text.trim();
                      if (newName.isNotEmpty) {
                        await DayServices().updateDayName(day_id, newName);
                        Navigator.pop(context, newName);
                      }
                    },
                    child: Text("change"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
