import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smit/resource/colors.dart';
import 'package:smit/resource/text.dart';
import 'package:smit/ui/add%20bill/update_bill.dart';

import 'package:smit/ui/pdf%20page/create_pdf.dart';

class PdfPage extends StatefulWidget {
  var data;
   PdfPage({super.key,this.data});

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {

  void deleteBill(String catId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('Bill').doc(catId).delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('data deleted successfully.')));
      // Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => HomePage(),),(route) => false,); // Close the dialog after deletion
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const CommonText.semiBold("details page",size: 18,),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateDetails(data: widget.data),));
              },
              icon: const Icon(Icons.edit,)
          ),
          IconButton(
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actionsAlignment: MainAxisAlignment.center,
                        title: const CommonText.semiBold("Do you really want to delete ?",size:17,color: AppColor.primary,),
                        actions: [
                          ElevatedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const CommonText.semiBold("cancel",size: 15,)),
                          ElevatedButton(
                              onPressed: (){
                                deleteBill(widget.data.id.toString());
                              },
                              child: const CommonText.semiBold("delete",size: 15,))
                        ],
                      );
                    },);

                },
              icon: const Icon(Icons.delete,)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                      border: Border.all(
                          color: AppColor.primary,
                          width: 1
                      ),
                    color: AppColor.primary
                  ),
                  child: const CommonText.extraBold("Invoice Details",size: 24,color: AppColor.white,),
                ),
                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColor.primary,
                      width: 1
                    )
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(child: CommonText.extraBold("Date :",size: 18,color: AppColor.black,)),
                          Expanded(child: CommonText.extraBold(widget.data['date'].toString(),size: 18,color: AppColor.black,)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(color: AppColor.primary),
                      ),
                      Row(
                        children: [
                          const Expanded(child: CommonText.extraBold("Name :",size: 18,color: AppColor.black,)),
                          Expanded(child: CommonText.extraBold(widget.data['name'].toString(),size: 18,color: AppColor.black,)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(color: AppColor.primary),
                      ),
                      Row(
                        children: [
                          const Expanded(child: CommonText.extraBold("Address :",size: 18,color: AppColor.black,)),
                          Expanded(child: CommonText.extraBold(widget.data['address'].toString(),size: 18,color: AppColor.black,)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(color: AppColor.primary),
                      ),
                      Row(
                        children: [
                          const Expanded(child: CommonText.extraBold("Items :",size: 18,color: AppColor.black,)),
                          Expanded(child: CommonText.extraBold(widget.data['items'].toString(),size: 18,color: AppColor.black,)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(color: AppColor.primary),
                      ),
                      Row(
                        children: [
                          const Expanded(child: CommonText.extraBold("Total :",size: 18,color: AppColor.black,)),
                          Expanded(child: CommonText.extraBold("₹ ${widget.data['totalRent'].toString()}",size: 18,color: AppColor.black,)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(color: AppColor.primary),
                      ),
                      Row(
                        children: [
                          const Expanded(child: CommonText.extraBold("Advanced :",size: 18,color: AppColor.black,)),
                          Expanded(child: CommonText.extraBold("₹ ${widget.data['advanced'].toString()}",size: 18,color: AppColor.black,)),
                        ],
                      ),
                      // const Padding(
                      //   padding: EdgeInsets.symmetric(vertical: 12.0),
                      //   child: Divider(color: AppColor.primary),
                      // ),
                      // Row(
                      //   children: [
                      //     const Expanded(child: CommonText.extraBold("Pending :",size: 18,color: AppColor.black,)),
                      //     Expanded(child: CommonText.extraBold("₹ ${widget.data['pendingRent'].toString()}",size: 18,color: AppColor.black,)),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePdfPage(data:widget.data),));
        },
        elevation: 10,
        tooltip: "pdf",
        child: const Icon(Icons.picture_as_pdf_outlined,),
      ),
    );
  }
}
