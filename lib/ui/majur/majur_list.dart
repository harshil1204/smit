import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smit/resource/colors.dart';
import 'package:smit/resource/text.dart';
import 'package:smit/ui/majur/add_majur.dart';
import 'package:smit/ui/majur/update_majur.dart';

class BillMajurList extends StatefulWidget {
  String? name;
  String? title;
  int? month;
  int? year;
  int? ind;
  BillMajurList({super.key,this.name,this.month,this.year,this.title,this.ind});

  @override
  State<BillMajurList> createState() => _BillMajurListState();
}

class _BillMajurListState extends State<BillMajurList> {
  int total = 0;
  int allTotal = 0;
  @override
  Widget build(BuildContext context) {
    print(widget.ind);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CommonText.extraBold("${widget.name}-${widget.year}".toString(),size: 18,),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("majur")
            .where('month',isEqualTo: widget.month)
            .where('year',isEqualTo: widget.year)
            .orderBy('time',descending: true).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            total=0;
            allTotal= 0;
            snapshot.data!.docs.forEach((element) {
              allTotal= allTotal + int.parse(element['majuri'].toString()) * int.parse(element['totalMajuri'].toString());
            });
            return Column(
              children: [
                const SizedBox(height: 10),
                Card(
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  elevation: 0,
                  child: Container(
                    width: double.infinity,
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColor.darkBoxBg,
                    ),
                    child: CommonText.bold("કુલ : ${allTotal.toString()}",size: 18,color:AppColor.primary),
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data=snapshot.data!.docs[index];
                      total=int.parse( data['totalMajuri'].toString()) * int.parse(data['majuri'].toString());
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => updateMajur(data:data),));
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
                                customRow(data['date'],"તારીખ : "),
                                // const Divider(color: AppColor.black,thickness: 0.2),
                                customRow("₹ ${data['majuri']}","મજુરી : "),
                                //const Divider(color: AppColor.black,thickness: 0.2),
                                customRow(data['totalMajuri'],"કુલ મજુર : "),
                                customRow("₹ ${total}","કુલ : "),
                                customRow(data['description'],"વધુ મહિતી: "),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
          // if(widget.ind == 0) {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  const AddMajur(),));
          // }
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