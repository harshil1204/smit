import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smit/resource/colors.dart';
import 'package:smit/resource/text.dart';
import 'package:smit/ui/pdf%20page/detail_page.dart';

import 'add_bill.dart';

class BillList extends StatefulWidget {
  String? name;
  String? title;
  int? month;
  int? year;
  BillList({super.key,this.name,this.month,this.year,this.title});

  @override
  State<BillList> createState() => _BillListState();
}

class _BillListState extends State<BillList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CommonText.extraBold("${widget.name}-${widget.year}".toString(),size: 18,),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(widget.title!)
            .where('month',isEqualTo: widget.month)
            .where('year',isEqualTo: widget.year)
            .orderBy('time',descending: true).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data=snapshot.data!.docs[index];
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PdfPage(data:data),));
                  },
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.symmetric(horizontal: 7,vertical: 5),
                    elevation: 0,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColor.darkBoxBg,
                      ),
                      child: Column(
                        children: [
                          customRow(data['date'],"date : "),
                         // const Divider(color: AppColor.black,thickness: 0.2),
                          customRow(data['address'],"Address : "),
                          //const Divider(color: AppColor.black,thickness: 0.2),
                          customRow(data['items'],"Items : "),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          else{
            return const Center(
                child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
           // Navigator.push(context, MaterialPageRoute(builder: (context) =>  AddBill(),));
        },
        tooltip: "Add bill",
        elevation: 0.5,
        child: const Icon(Icons.add),
      ),
    );
  }
}
Widget customRow(var data,String name){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(child: CommonText.semiBold(name.toString(),color: AppColor.primary,size: 18,)),
        Expanded(child: CommonText.semiBold(data.toString(),color: AppColor.primary,size: 18,)),
      ],
    ),
  );
}