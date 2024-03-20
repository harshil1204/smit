import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smit/resource/colors.dart';
import 'package:smit/resource/text.dart';
import 'dart:io';

class AddDavaKhatar extends StatefulWidget {
  const AddDavaKhatar({super.key});

  @override
  State<AddDavaKhatar> createState() => _AddDavaKhatarState();
}

class _AddDavaKhatarState extends State<AddDavaKhatar> {

  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  DateTime? picked;
  String? imageUrl;

  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    DateTime now =  DateTime.now();
    // var datestamp = DateFormat("yyyyMMdd'T'HHmmss");
    // String currentdate = datestamp.format(now);

    //Select Image
    final image = await _imagePicker.pickImage(source: ImageSource.gallery,imageQuality: 60);
    if (image != null){
      //Upload to Firebase
      var snapshot = await _firebaseStorage.ref()
          .child('images/$now.jpg')
          .putFile(File(image.path));
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
    } else {
      if (kDebugMode) {
        print('No Image Path Received');
      }
    }
  }

  void addBillToFirestore(
      String price,
      String dateTime) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection("Dava").add({
        // 'id':widget.catId,
        'date': dateTime,
        'month':picked!.month,
        'year':picked!.year,
        'price':price,
        'url':imageUrl,
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
              InkWell(
                onTap: (){
                  uploadImage();
                },
                child: Container(
                    height: 200,
                    width: double.infinity - 20,
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.all(15),
                    // padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      border: Border.all(color: Colors.white),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(2, 2),
                          spreadRadius: 3,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: (imageUrl == null)
                        ? const Icon(Icons.photo)
                        : Image.network(imageUrl.toString(),height: 50,fit: BoxFit.fill,)
                ),
              ),
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
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'ખર્ચ',
                    border: OutlineInputBorder(),
                    prefixText: "₹ "
                ),
              ),
              const SizedBox(height: 60,),
              ElevatedButton(
                  onPressed: (){
                    FocusScope.of(context).focusedChild?.unfocus();
                    String price = _priceController.text.trim();
                    String dateTime = _dateTimeController.text.trim();
                    if(
                        price.isNotEmpty &&
                        dateTime.isNotEmpty)
                    {
                      addBillToFirestore(price, dateTime);
                      _dateTimeController.clear();
                      _priceController.clear();
                      imageUrl="";
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
