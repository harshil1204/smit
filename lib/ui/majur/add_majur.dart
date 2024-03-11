import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smit/resource/colors.dart';
import 'package:smit/resource/text.dart';

class AddMajur extends StatefulWidget {
  const AddMajur({super.key});

  @override
  State<AddMajur> createState() => _AddMajurState();
}

class _AddMajurState extends State<AddMajur> {

  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _totalMajurController = TextEditingController();
  final TextEditingController _majuriController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  DateTime? picked;
  String? imageUrl;

  void addBillToFirestore(
      String majuri,
      String totalMajur,
      String desc,
      String dateTime) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection("majur").add({
        // 'id':widget.catId,
        'date': dateTime,
        'month':picked!.month,
        'year':picked!.year,
        'majuri':majuri,
        'totalMajuri':totalMajur,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            children: [
              const SizedBox(height: 30,),
              TextField(
                controller: _dateTimeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Choose Date',
                  border: OutlineInputBorder(),
                ),
                onTap: (){
                  _selectDate(context);
                },
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _majuriController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'majuri',
                    border: OutlineInputBorder(),
                    prefixText: "₹ "
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _totalMajurController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'total majur',
                    border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: 'description',
                    border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 60,),
              ElevatedButton(
                  onPressed: (){
                    FocusScope.of(context).focusedChild?.unfocus();
                    String majuri = _majuriController.text.trim();
                    String totalMajuri = _totalMajurController.text.trim();
                    String desc = _descController.text.trim();
                    String dateTime = _dateTimeController.text.trim();
                    if(
                    majuri.isNotEmpty && totalMajuri.isNotEmpty &&
                        dateTime.isNotEmpty)
                    {
                      addBillToFirestore(majuri,totalMajuri, desc, dateTime);
                      _dateTimeController.clear();
                      _totalMajurController.clear();
                      _majuriController.clear();
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
