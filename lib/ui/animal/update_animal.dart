import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smit/resource/colors.dart';
import 'package:smit/resource/text.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class updateAnimal extends StatefulWidget {
  var data;
  updateAnimal({super.key,required this.data});

  @override
  State<updateAnimal> createState() => _updateAnimalState();
}

class _updateAnimalState extends State<updateAnimal> {

  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _medicalController = TextEditingController();
  final TextEditingController _docNameController = TextEditingController();
  final TextEditingController _docFeeController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  DateTime? picked;

  void updateBillToFirestore(
      String docName,
      String docFee,
      String desc,
      String medical,
      String dateTime) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection("animal").doc(widget.data.id.toString()).update({
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

  void deleteBillToFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection("animal").doc(widget.data.id.toString()).delete();
      print('Product deleted successfully');
      Navigator.pop(context);
    } catch (e) {
      if (kDebugMode) {
        print('Error adding bill: $e');
      }
    }

  }
  String generateReferralCode(String userId) {
    // Use SHA-256 hash to generate a consistent hash value for the user ID
    List<int> data = utf8.encode(userId);
    Digest sha256Result = sha256.convert(data);
    String hash = sha256Result.toString();

    // Take the first 6 characters from the hash as the referral code
    return hash.substring(0, 6);
  }

  DateFormat format = DateFormat("dd-MM-yyyy");
  @override
  void initState() {
    picked=format.parse(widget.data['date']);
    _dateTimeController.text = widget.data['date'];
    _docFeeController.text = widget.data['docFee'];
    _docNameController.text = widget.data['docName'];
    _medicalController.text = widget.data['medical'];
    _descController.text = widget.data['description'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText.semiBold("તારીખ",size: 18),
        actions: [
          IconButton(
              onPressed: (){
                deleteBillToFirestore();
              },
              icon: const Icon(Icons.delete)
          )
        ],
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
                      updateBillToFirestore(docName,docFee, desc,medical, dateTime);
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
                      child: CommonText.semiBold("સુધારો",color: AppColor.white,size: 18,),
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
