import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smit/resource/colors.dart';
import 'package:smit/resource/text.dart';

class UpdateDava extends StatefulWidget {
  var data;
  UpdateDava({super.key,required this.data});

  @override
  State<UpdateDava> createState() => _UpdateDavaState();
}

class _UpdateDavaState extends State<UpdateDava> {
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
      print(imageUrl);
    } else {
      if (kDebugMode) {
        print('No Image Path Received');
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

  void updateBillToFirestore(
      String price,
      String dateTime) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection("Dava").doc(widget.data.id.toString()).update({
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

  void deleteBillToFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection("Dava").doc(widget.data.id.toString()).delete();
      await FirebaseStorage.instance.refFromURL(widget.data['url']).delete().then((value) => print("delete"));
      print('Product deleted successfully');
      Navigator.pop(context);
    } catch (e) {
      if (kDebugMode) {
        print('Error adding bill: $e');
      }
    }

  }

  DateFormat format = DateFormat("dd-MM-yyyy");
  @override
  void initState() {
    imageUrl = widget.data['url'];
    picked=format.parse(widget.data['date']);
    _dateTimeController.text = widget.data['date'];
    _priceController.text = widget.data['price'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText.semiBold("સુધારો",size: 18),
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
              InkWell(
                onTap: (){
                  uploadImage();
                },
                child: Container(
                    height: 200,
                    width: double.infinity - 20,
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.all(15),
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
                    child: (imageUrl == null || imageUrl == "")
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
                      updateBillToFirestore(price, dateTime);
                      _dateTimeController.clear();
                      _priceController.clear();
                      setState(() {
                      imageUrl="";
                      });
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
                      child: CommonText.semiBold("તારીખ",color: AppColor.white,size: 18,),
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
