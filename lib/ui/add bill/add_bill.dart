import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smit/resource/colors.dart';

import 'package:smit/resource/text.dart';

int? invoiceID;

class AddBill extends StatefulWidget {
  const AddBill({super.key});

  @override
  State<AddBill> createState() => _AddBillState();
}

class _AddBillState extends State<AddBill> {
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateTimeStartController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _dateTimeEndController = TextEditingController();
  final TextEditingController _totalRentController = TextEditingController();
  final TextEditingController _dateTotalController = TextEditingController();

  DateTime? picked;
  TimeOfDay? startPicked;
  TimeOfDay? endPicked;
  List multipleSelected = [];
  List checkListItems = [
    {
      "id": 0,
      "value": false,
      "title": "dati",
    },
    {
      "id": 1,
      "value": false,
      "title": "rap",
    },
    {
      "id": 2,
      "value": false,
      "title": "madh",
    },
    {
      "id": 3,
      "value": false,
      "title": "fero",
    },
  ];
  TimeOfDay selectedTime = TimeOfDay.now();
  late Duration timeDifference;

  void addBillToFirestore(String items, String name, String totalRent, String startTime, String endTime, String totalTime,String dateTime) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    invoiceID = invoiceID ?? 0 + 1;
    try {
      await firestore.collection('tractor').add({
        // 'id':widget.catId,
        'date': dateTime,
        'name': name,
        'month': picked!.month,
        'year': picked!.year,
        'work': multipleSelected,
        'start': startTime,
        'end': endTime,
        "workingHours": totalTime,
        "price": totalRent,
        'time': DateTime.now(),
      });

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
    } catch (e) {
      if (kDebugMode) {
        print('Error adding bill: $e');
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    picked = await showDatePicker(
      context: context,
      initialDate: (picked == null) ? DateTime.now() : picked as DateTime,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    // startOfDay = DateTime(picked!.year, picked!.month, picked!.day);
    // endOfDay = startOfDay!.add(const Duration(days: 1));
    if (picked != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked!);
      _dateTimeController.text = formattedDate!.toString();
    }
    setState(() {});
  }

  Future<void> _selectDateStart(BuildContext context) async {
    startPicked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (startPicked != null) {
      _dateTimeStartController.text = "${startPicked!.hour.toString()} : ${startPicked!.minute.toString()}";
    }
    setState(() {});
  }

  Future<void> _selectDateEnd(BuildContext context) async {
    endPicked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (endPicked != null) {
      _dateTimeEndController.text = "${endPicked!.hour.toString()} : ${endPicked!.minute.toString()}";
    }
    setState(() {});
  }

  void calculateTimeDifference() {
    timeDifference = Duration.zero;
    if (startPicked != null && endPicked != null) {
      final DateTime startDateTime = DateTime(2022, 1, 1, startPicked!.hour, startPicked!.minute);
      final DateTime endDateTime = DateTime(2022, 1, 1, endPicked!.hour, endPicked!.minute);

      timeDifference = endDateTime.difference(startDateTime);

      setState(() {
        _dateTotalController.text = timeDifference.toString().split('.')[0];
      });
      print('Time Difference: $timeDifference');
    }
  }

  @override
  void initState() {
    getInvoiceId();
    _dateTimeController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText.semiBold("Add Bill", size: 18),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: _dateTimeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Choose order Date',
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  _selectDate(context);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Customer name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _dateTimeStartController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Choose start Date',
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  _selectDateStart(context);
                  // calculateTimeDifference();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _dateTimeEndController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Choose end Date',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  await _selectDateEnd(context);
                  calculateTimeDifference();
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _dateTotalController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'total time',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const CommonText.bold(
                "Choose work : ",
                color: AppColor.primary,
                size: 20,
              ),
              Column(
                children: List.generate(
                  checkListItems.length,
                  (index) => CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      checkListItems[index]["title"],
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    value: checkListItems[index]["value"],
                    onChanged: (value) {
                      setState(() {
                        checkListItems[index]["value"] = value;
                        if (multipleSelected.contains(checkListItems[index]['title'])) {
                          multipleSelected.remove(checkListItems[index]['title']);
                        } else {
                          multipleSelected.add(checkListItems[index]['title']);
                        }
                        _itemController.text = multipleSelected.toString();
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                maxLines: 4,
                controller: _itemController,
                decoration: const InputDecoration(
                  labelText: 'Item Names',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _totalRentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Total Rent', border: OutlineInputBorder(), prefixText: "₹ "),
              ),
              const SizedBox(
                height: 60,
              ),
              ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).focusedChild?.unfocus();
                    String name = _nameController.text.trim();
                    String items = _itemController.text.trim();
                    String totalRent = _totalRentController.text.trim();
                    String startTime = startPicked!.format(context);
                    String endTime = endPicked!.format(context);
                    String dateTime = _dateTimeController.text.trim();
                    String totalTime = _dateTotalController.text.trim();
                    print(startTime);
                    if (items.isNotEmpty && totalRent.isNotEmpty && endTime.isNotEmpty && startTime.isNotEmpty && totalTime.isNotEmpty && dateTime.isNotEmpty) {
                      addBillToFirestore(items, name, totalRent,startTime, endTime,totalTime, dateTime);
                      calculateTimeDifference();
                      _dateTimeController.clear();
                      _nameController.clear();
                      _itemController.clear();
                      _dateTimeEndController.clear();
                      _dateTimeStartController.clear();
                      _dateTotalController.clear();
                      _totalRentController.clear();
                      multipleSelected.clear();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('data added successfully.')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('please fill the boxes')));
                    }
                  },
                  child: const SizedBox(
                    height: 30,
                    width: double.infinity,
                    child: Center(
                      child: CommonText.semiBold(
                        "Add bill",
                        color: AppColor.white,
                        size: 18,
                      ),
                    ),
                  )),
              const SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> getInvoiceId() async {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final invoice = await firebaseFirestore.collection('invoice').get();
  invoiceID = invoice.docs.first['invoiceId'];
  print(invoice.docs.first['invoiceId']);
}
