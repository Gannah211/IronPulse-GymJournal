import 'package:flutter/material.dart';

class newCountWidget extends StatelessWidget {
  final Future<void> Function() onAdd;
  final Future<void> Function() onRemove;

  const newCountWidget({
    super.key,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      // padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 42, 41, 41),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: const Color.fromARGB(255, 42, 41, 41),

        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFF1C1018),
              child: IconButton(
                icon: const Icon(Icons.add),
                color: Colors.white,
                onPressed: onAdd,
              ),
            ),
            SizedBox(width: 10),

            Expanded(
              child: TextFormField(
                style: TextStyle(
                  color: Color.fromARGB(255, 200, 195, 195),
                  fontSize: 16,
                ),
                initialValue: "10",
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Reps',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepOrange,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 200, 195, 195),
                  ),
                ),
                keyboardType: TextInputType.number,
                // onChanged: (value) {},
              ),
            ),
            SizedBox(width: 8),

            Expanded(
              child: TextFormField(
                style: TextStyle(color: Color.fromARGB(255, 200, 195, 195)),
                initialValue: "20",
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'kg',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelStyle: TextStyle(
                    color: const Color.fromARGB(255, 200, 195, 195),
                  ),
                ),
                keyboardType: TextInputType.number,
                // onChanged: (value) {},
              ),
            ),
            SizedBox(width: 8),

            CircleAvatar(
              backgroundColor: Color(0xFF1C1018),
              child: IconButton(
                icon: const Icon(Icons.delete_outline),
                // iconSize: 35,
                color: Colors.white,
                onPressed: onRemove,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
