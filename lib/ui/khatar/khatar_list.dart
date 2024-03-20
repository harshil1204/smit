import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smit/resource/colors.dart';
import 'package:smit/resource/text.dart';
import 'package:smit/ui/khatar/add_khatar.dart';
import 'package:smit/ui/khatar/update_khatar.dart';

class BillKhatarList extends StatefulWidget {
  String? name;
  String? title;
  int? month;
  int? year;
  int? ind;
  BillKhatarList({super.key,this.name,this.month,this.year,this.title,this.ind});

  @override
  State<BillKhatarList> createState() => _BillKhatarListState();
}

class _BillKhatarListState extends State<BillKhatarList> {
  int total = 0;
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
            .collection("Khatar")
            .where('month',isEqualTo: widget.month)
            .where('year',isEqualTo: widget.year)
            .orderBy('time',descending: true).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            total=0;
            snapshot.data!.docs.forEach((element) {
              total= total + int.parse(element['price'].toString());
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
                    child: CommonText.bold("કુલ : ${total.toString()}",size: 18,color:AppColor.primary),
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
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateKhatar(data:data),));
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
                                customRow(data['price'],"ખર્ચ : "),
                                //const Divider(color: AppColor.black,thickness: 0.2),
                                CachedNetworkImage(imageUrl: data['url'].toString(),width: 300,height: 200,fit: BoxFit.cover,)
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
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  const AddKhatar(),));
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