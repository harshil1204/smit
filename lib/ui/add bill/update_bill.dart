import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smit/resource/colors.dart';
import 'package:smit/resource/text.dart';

class UpdateDetails extends StatefulWidget {
  var data;
   UpdateDetails({super.key,this.data});

  @override
  State<UpdateDetails> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {

  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressNameController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _advancedRentController = TextEditingController();
  final TextEditingController _totalRentController = TextEditingController();
  final TextEditingController _pendingRentController = TextEditingController();
  DateTime? picked;

  void updateBillTo(String addressName,
      String items,
      String name,
      String advancedRent,
      String totalRent,
      String dateTime) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('Bill').doc(widget.data.id.toString()).update({
        'date': dateTime,
        'month':picked?.month,
        'year':picked?.year,
        'name':name,
        'address':addressName,
        'items':items,
        'advanced':advancedRent,
        'totalRent':totalRent,
        'tempaRent':0,
        'operatorCost':0,
        'extraCost':0,
      });

      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage(),),(route) => false,);
    } catch (e) {
      if (kDebugMode) {
        print('Error adding category: $e');
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
  DateFormat format = DateFormat("dd-MM-yyyy");

  @override
  void initState() {
     picked=format.parse(widget.data['date']);
    _dateTimeController.text = widget.data['date'];
    _nameController.text = widget.data['name'];
    _addressNameController.text = widget.data['address'];
    _itemController.text = widget.data['items'];
    _advancedRentController.text = widget.data['advanced'];
    _totalRentController.text = widget.data['totalRent'];
    // _pendingRentController.text = widget.data['pendingRent'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const CommonText.semiBold("સુધારો",size: 18),
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
                    labelStyle: TextStyle(
                        color: AppColor.primary
                    ),
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
                    labelText: 'customer Name',
                    labelStyle: TextStyle(
                        color: AppColor.primary
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: _addressNameController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(
                        color: AppColor.primary
                    ),
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
                //       labelText: 'Pending Rent',
                //       border: OutlineInputBorder(),
                //       prefixText: "₹ "
                //   ),
                // ),
                const SizedBox(height: 60,),
                ElevatedButton(
                    onPressed: (){
                      String addressName = _addressNameController.text.trim();
                      String items = _itemController.text.trim();
                      String name = _nameController.text.trim();
                      String advancedRent = _advancedRentController.text.trim();
                      String totalRent = _totalRentController.text.trim();
                      String pendingRent = _pendingRentController.text.trim();
                      String dateTime = _dateTimeController.text.trim();
                      if(addressName.isNotEmpty &&
                          items.isNotEmpty &&
                          name.isNotEmpty &&
                          advancedRent.isNotEmpty&&
                          totalRent.isNotEmpty &&
                          // pendingRent.isNotEmpty &&
                          dateTime.isNotEmpty)
                      {
                        updateBillTo(addressName, items,name, advancedRent, totalRent, dateTime);
                        _dateTimeController.clear();
                        _addressNameController.clear();
                        _nameController.clear();
                        _itemController.clear();
                        _advancedRentController.clear();
                        _totalRentController.clear();
                        _pendingRentController.clear();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('data updated successfully.')));
                      }
                    },
                    child: const SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: Center(
                        child: CommonText.semiBold("Update bill",color: AppColor.white,size: 18),
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
