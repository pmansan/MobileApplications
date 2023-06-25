import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddTravelDialog extends StatefulWidget {
  final Function(Travel) addTravelCallback;

  AddTravelDialog({required this.addTravelCallback});

  @override
  _AddTravelDialogState createState() => _AddTravelDialogState();
}

class Travel {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  Travel({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });
}

class _AddTravelDialogState extends State<AddTravelDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String? imagePath;
  XFile? _pickedfile;

  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();

  void _showDatePicker(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
          _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _selectedEndDate = picked;
          _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a new travel'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _titleController,
            onChanged: (value) {},
            decoration: const InputDecoration(
              hintText: 'Enter the name of the travel',
              labelText: 'Title',
            ),
          ),
          TextField(
            controller: _descriptionController,
            onChanged: (value) {},
            decoration: const InputDecoration(
              hintText: 'Enter a description of the travel',
              labelText: 'Description',
            ),
          ),
          ListTile(
            title: const Text('Start Date'),
            subtitle: TextFormField(
              controller: _startDateController,
              enabled: false,
            ),
            onTap: () => _showDatePicker(context, true),
          ),
          ListTile(
            title: const Text('End Date'),
            subtitle: TextFormField(
              controller: _endDateController,
              enabled: false,
            ),
            onTap: () => _showDatePicker(context, false),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(Colors.grey.shade200),
            ),
            child: Icon(
              Icons.camera_alt_outlined,
              color: Colors.grey[500],
            ),
            // const Text('Load image cover'),
            ////////////////////////////////////////// IMAGE PICKER
            onPressed: () async {
              final ImagePicker _picker = ImagePicker();
              _pickedfile =
                  await _picker.pickImage(source: ImageSource.gallery);
              imagePath = _pickedfile!.path;

              // _pickedfile.readAsBytes().then((value){})
            },
            ////////////////////////////////////////// IMAGE PICKER
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel',
           style: TextStyle(
                    color: Color(0xfb3a78b1),
                  )),
        ),
        ElevatedButton(
          onPressed: () {
            final String title = _titleController.text;
            final String description = _descriptionController.text;

            final Travel travel = Travel(
              title: title,
              description: description,
              startDate: _selectedStartDate,
              endDate: _selectedEndDate,
            );

            widget.addTravelCallback(travel);

            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
