import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smit/resource/colors.dart';
import 'package:smit/resource/text.dart';

class AddAnimal extends StatefulWidget {
  const AddAnimal({super.key});

  @override
  State<AddAnimal> createState() => _AddAnimalState();
}

class _AddAnimalState extends State<AddAnimal> {

  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _medicalController = TextEditingController();
  final TextEditingController _docNameController = TextEditingController();
  final TextEditingController _docFeeController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  DateTime? picked;

  void addBillToFirestore(
      String docName,
      String docFee,
      String desc,
      String medical,
      String dateTime) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection("animal").add({
        // 'id':widget.catId,
        'date': dateTime,
        'month':picked!.month,
        'year':picked!.year,
        'docName':docName,
        'docFee':docFee,
        'medical':medical,
        'description':desc,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText.semiBold("Add Bill",size: 18),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            children: [
              const SizedBox(height: 30,),
              TextField(
                controller: _dateTimeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'તારીખ',
                  border: OutlineInputBorder(),
                ),
                onTap: (){
                  _selectDate(context);
                },
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _docNameController,
                decoration: const InputDecoration(
                    labelText: 'ડૉક્ટરનું નામ',
                    border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _docFeeController,
                decoration: const InputDecoration(
                  labelText: 'ડૉક્ટર ખર્ચ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _medicalController,
                decoration: const InputDecoration(
                  labelText: 'તબીબી ખર્ચ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'વધુ મહિતી',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 60,),
              ElevatedButton(
                  onPressed: (){
                    FocusScope.of(context).focusedChild?.unfocus();
                    String docName = _docNameController.text.trim();
                    String docFee = _docFeeController.text.trim();
                    String medical = _medicalController.text.trim();
                    String desc = _descController.text.trim();
                    String dateTime = _dateTimeController.text.trim();
                    if(
                    docName.isNotEmpty && docFee.isNotEmpty && medical.isNotEmpty &&
                        dateTime.isNotEmpty)
                    {
                      addBillToFirestore(docName,docFee, desc,medical, dateTime);
                      _dateTimeController.clear();
                      _medicalController.clear();
                      _docFeeController.clear();
                      _docNameController.clear();
                      _descController.clear();
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
