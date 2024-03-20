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
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _totalRentController = TextEditingController();
  final TextEditingController _dropTimeController = TextEditingController();
  final TextEditingController _dropPriceController = TextEditingController();

  DateTime? picked;
  List<String> items = [];
  String? selectedValue;
  List<String> workInfo = [];

  void addBillToFirestore(String items, String name, String totalRent, String dateTime) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    invoiceID = invoiceID ?? 0 + 1;
    try {
      await firestore.collection('tractor').add({
        // 'id':widget.catId,
        'date': dateTime,
        'name': name,
        'month': picked!.month,
        'year': picked!.year,
        'items':items,
        'price': totalRent,
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

  @override
  void initState() {
    getInvoiceId();
    // selectedValue=" ";
    items.addAll(['દાતી','રાપ','માધ','ફેરો','ભાર']);
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
        reverse: true,
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
                  labelText: 'તારીખ',
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
                  labelText: 'નામ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const CommonText.bold(
                "કામ પસંદ કરો : ",
                color: AppColor.primary,
                size: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                              builder: (context, setState) {
                              return AlertDialog(
                               title: Column(
                                 children: [
                                   const CommonText.bold("વિગતો ઉમેરો",size: 24,color:AppColor.primary),
                                   const SizedBox(height: 30,),
                                   SizedBox(
                                     width: double.infinity,
                                     height: 48,
                                     child: DropdownButton<String>(
                                     value: selectedValue,
                                       hint: const Text(
                                         "પસંદ કરો",
                                         style: TextStyle(
                                             color: Colors.black,
                                             fontSize: 16,
                                             fontWeight: FontWeight.w600),
                                       ),

                                         items: items.map((String e) {
                                           return DropdownMenuItem<String>(
                                                value: e,
                                               child:CommonText.semiBold(e,color: AppColor.primary,),
                                           );
                                         }).toList(),
                                         onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              selectedValue = value!;
                                            });
                                          }
                                         },
                                       // selectedItemBuilder: (BuildContext ctx) {
                                       //   return items.map((String item) {
                                       //     return DropdownMenuItem(value: item, child: CommonText.regular(item, size: 15, color: AppColor.black,));
                                       //   }).toList();
                                       // },
                                     ),
                                   ),
                                   TextField(
                                     controller: _dropTimeController,
                                     decoration: const InputDecoration(
                                       labelText: 'સમય',
                                       border: OutlineInputBorder(),
                                     ),
                                   ),
                                   const SizedBox(height: 10,),
                                   TextField(
                                     controller: _dropPriceController,
                                     keyboardType: TextInputType.number,
                                     decoration: const InputDecoration(
                                       labelText: 'ભાડું',
                                       border: OutlineInputBorder(),
                                     ),
                                   ),
                                   // const SizedBox(height: 10,),
                                   // TextField(
                                   //   controller: _timeRapController,
                                   //   decoration: InputDecoration(
                                   //     prefixIcon: Checkbox(
                                   //       value: isRap,
                                   //       onChanged: (value) {
                                   //         setState(() {
                                   //           isRap = value!;
                                   //         });
                                   //       },
                                   //     ),
                                   //     labelText: 'Rap',
                                   //     border: const OutlineInputBorder(),
                                   //   ),
                                   // ),
                                   // const SizedBox(height: 10,),
                                   // TextField(
                                   //   controller: _timeMadhController,
                                   //   decoration: InputDecoration(
                                   //     prefixIcon: Checkbox(
                                   //       value: isMadh,
                                   //       onChanged: (value) {
                                   //         setState(() {
                                   //           isMadh = value!;
                                   //         });
                                   //       },
                                   //     ),
                                   //     labelText: 'madh',
                                   //     border: const OutlineInputBorder(),
                                   //   ),
                                   // ),
                                   // const SizedBox(height: 10,),
                                   // TextField(
                                   //   controller: _timeBharController,
                                   //   decoration: InputDecoration(
                                   //     prefixIcon: Checkbox(
                                   //       value: isBhar,
                                   //       onChanged: (value) {
                                   //         setState(() {
                                   //           isBhar = value!;
                                   //         });
                                   //       },
                                   //     ),
                                   //     labelText: 'bhar',
                                   //     border: const OutlineInputBorder(),
                                   //   ),
                                   // ),
                                 ],
                               ),
                                actions: [
                                  ElevatedButton(onPressed: (){
                                    Navigator.pop(context);
                                    selectedValue = null;
                                    _dropTimeController.clear();
                                    _dropPriceController.clear();
                                  }, child: const CommonText.bold("રદ કરો",size: 18)),
                                  ElevatedButton(
                                      onPressed: (){
                                    _itemController.text = "$selectedValue = ${_dropTimeController.text} સમય = ${_dropPriceController.text} ભાડુ";
                                    workInfo.add(_itemController.text);
                                    _itemController.text = workInfo.map((e) => e).toString();
                                    _dropTimeController.clear();
                                    _dropPriceController.clear();
                                    Navigator.pop(context);
                                   }, child: const CommonText.bold("ઉમેરો",size: 18)),
                                ],
                              );
                            }
                          );
                        },
                    );
                  },
                  child: const CommonText.bold("ઉમેરો")),
              const SizedBox(
                height: 10,
              ),
              TextField(
                maxLines: 4,
                readOnly: true,
                controller: _itemController,
                decoration: const InputDecoration(
                  labelText: 'આઇટમ નામો',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _totalRentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'કુલ ભાડું', border: OutlineInputBorder(), prefixText: "₹ "),
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
                    String dateTime = _dateTimeController.text.trim();

                    if (items.isNotEmpty && totalRent.isNotEmpty && dateTime.isNotEmpty && name.isNotEmpty) {
                      addBillToFirestore(items, name, totalRent, dateTime);
                      _dateTimeController.clear();
                      _nameController.clear();
                      _itemController.clear();
                      _totalRentController.clear();
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
                        "બિલ ઉમેરો",
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
