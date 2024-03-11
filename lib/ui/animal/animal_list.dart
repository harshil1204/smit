import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smit/resource/colors.dart';
import 'package:smit/resource/text.dart';
import 'package:smit/ui/animal/add_animal.dart';
import 'package:smit/ui/animal/update_animal.dart';
import 'package:smit/ui/majur/add_majur.dart';
import 'package:smit/ui/majur/update_majur.dart';

class BillAnimalList extends StatefulWidget {
  String? name;
  String? title;
  int? month;
  int? year;
  int? ind;
  BillAnimalList({super.key,this.name,this.month,this.year,this.title,this.ind});

  @override
  State<BillAnimalList> createState() => _BillAnimalListState();
}

class _BillAnimalListState extends State<BillAnimalList> {
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
            .collection("animal")
            .where('month',isEqualTo: widget.month)
            .where('year',isEqualTo: widget.year)
            .orderBy('time',descending: true).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            total=0;
            allTotal= 0;
            snapshot.data!.docs.forEach((element) {
              allTotal= allTotal + int.parse(element['docFee'].toString()) + int.parse(element['medical'].toString());
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
                    child: CommonText.bold("Total : ${allTotal.toString()}",size: 18,color:AppColor.primary),
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
                      total=int.parse( data['docFee'].toString()) + int.parse(data['medical'].toString());
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => updateAnimal(data:data),));
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
                                customRow(data['docName'],"Doctor Name : "),
                                customRow("₹ ${data['docFee']}","Doctor Fee : "),
                                customRow("₹ ${data['medical']}","Medical Cost : "),
                                customRow(data['description'],"description : "),
                                customRow("₹ ${total}","Total : "),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  const AddAnimal(),));
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