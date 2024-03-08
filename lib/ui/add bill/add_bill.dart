import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smit/resource/colors.dart';

import 'package:smit/resource/text.dart';


int? invoiceID;

class AddBill extends StatefulWidget {
  final String title;
  const AddBill({super.key,required this.title});

  @override
  State<AddBill> createState() => _AddBillState();
}

class _AddBillState extends State<AddBill> {

  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressNameController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _advancedRentController = TextEditingController();
  final TextEditingController _totalRentController = TextEditingController();
  final TextEditingController _pendingRentController = TextEditingController();

  DateTime? picked;

  void addBillToFirestore(String addressName,
  String items,
  String advancedRent,
  String name,
      String totalRent,
      String dateTime) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
      invoiceID=invoiceID ?? 0 + 1;
    try {
      await firestore.collection('Bill').add({
        // 'id':widget.catId,
        'date': dateTime,
        'name':name,
        'month':picked!.month,
        'year':picked!.year,
        'address':addressName,
        'items':items,
        'advanced':advancedRent,
        'totalRent':totalRent,
        'tempaRent':0,
        'operatorCost':0,
        'extraCost':0,
        'invoiceId':invoiceID,
        'time': DateTime.now(),
      });

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
    } catch (e) {
      if (kDebugMode) {
        print('Error adding bill: $e');
      }
    }

    try {
      await firestore.collection('invoice').doc("bmuy2cffDqd9ZqAJSVdf").set({
        'invoiceId':invoiceID,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding invoice ID: $e');
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    picked = await showDatePicker(
      context: context,
      initialDate:(picked==null)
                      ?DateTime.now()
                      : picked as DateTime,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    // startOfDay = DateTime(picked!.year, picked!.month, picked!.day);
    // endOfDay = startOfDay!.add(const Duration(days: 1));
    if(picked !=null){
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked!);
      _dateTimeController.text=formattedDate!.toString();
    }
    setState(() {
    });
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
        title: const CommonText.semiBold("Add Bill",size: 18),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            children: [
              const SizedBox(height: 30,),
              TextField(
                controller: _dateTimeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Choose order Date',
                  border: OutlineInputBorder(),
                ),
                onTap: (){
                  _selectDate(context);
                },
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Customer name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _addressNameController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                maxLines: 4,
                controller: _itemController,
                decoration: const InputDecoration(
                  labelText: 'Item Names',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _totalRentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total Rent',
                  border: OutlineInputBorder(),
                  prefixText: "₹ "
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _advancedRentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Advanced Rent',
                  border: OutlineInputBorder(),
                    prefixText: "₹ "
                ),
              ),
              // const SizedBox(height: 10,),
              // TextField(
              //   controller: _pendingRentController,
              //   keyboardType: TextInputType.number,
              //   decoration: const InputDecoration(
              //     labelText: 'Pending Rent',
              //     border: OutlineInputBorder(),
              //       prefixText: "₹ "
              //   ),
              // ),
              const SizedBox(height: 60,),
              ElevatedButton(
                  onPressed: (){
                    FocusScope.of(context).focusedChild?.unfocus();
                    String addressName = _addressNameController.text.trim();
                    String name = _nameController.text.trim();
                    String items = _itemController.text.trim();
                    String advancedRent = _advancedRentController.text.trim();
                    String totalRent = _totalRentController.text.trim();
                    String dateTime = _dateTimeController.text.trim();
                    if(addressName.isNotEmpty &&
                        items.isNotEmpty &&
                        advancedRent.isNotEmpty&&
                        totalRent.isNotEmpty &&
                        // pendingRent.isNotEmpty &&
                        dateTime.isNotEmpty)
                    {
                      addBillToFirestore(addressName, items, advancedRent, name, totalRent, dateTime);
                      _dateTimeController.clear();
                      _nameController.clear();
                      _addressNameController.clear();
                      _itemController.clear();
                      _advancedRentController.clear();
                      _totalRentController.clear();
                      _pendingRentController.clear();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('data added successfully.')));
                    }
                    else{
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('please fill the boxes')));
                    }
                  },
                  child: const SizedBox(
                    height: 30,
                    width: double.infinity,
                    child: Center(
                      child: CommonText.semiBold("Add bill",color: AppColor.white,size: 18,),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}


Future<void> getInvoiceId()async{
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final invoice = await firebaseFirestore.collection('invoice').get();
  invoiceID=invoice.docs.first['invoiceId'];
  print(invoice.docs.first['invoiceId']);
}