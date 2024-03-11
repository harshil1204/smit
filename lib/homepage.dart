import 'package:flutter/material.dart';
import 'package:smit/resource/colors.dart';
import 'package:smit/resource/text.dart';
import 'package:smit/ui/add%20bill/bill_list.dart';
import 'package:smit/ui/animal/animal_list.dart';
import 'package:smit/ui/dava/dava_list.dart';
import 'package:smit/ui/khatar/khatar_list.dart';
import 'package:smit/ui/majur/majur_list.dart';

class HomePage extends StatefulWidget {
  final String title;
  final int ind;
  const HomePage({super.key,required this.title,required this.ind});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> month=["01-01","01-02","01-03","01-04","01-05","01-06","01-07","01-08","01-09","01-10","01-11","01-12"];
  DateTime currentYear = DateTime.now();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.ind);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CommonText.extraBold("${widget.title}  ( ${currentYear.year} )",size: 18,),
        actions: [
          IconButton(
              onPressed: () async{
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Select Year"),
                      content: SizedBox( // Need to use container to add size constraint.
                        width: 300,
                        height: 300,
                        child: YearPicker(
                          firstDate: DateTime(DateTime.now().year - 10, 1),
                          lastDate: DateTime(DateTime.now().year + 10, 1),
                          initialDate: DateTime.now(),
                          selectedDate: currentYear,
                          onChanged: (DateTime dateTime) {
                            setState(() {
                              currentYear = dateTime;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.date_range)
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
        child:
        ListView.builder(
            itemCount: 12,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  if(widget.ind == 0){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        BillDavaList(
                          ind:widget.ind,
                          title:widget.title,
                          name:month[index].toString(),
                          month:index+1,
                          year: int.parse(currentYear.year.toString()),)));
                  }
                  else if(widget.ind == 1){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        BillKhatarList(
                          ind:widget.ind,
                          title:widget.title,
                          name:month[index].toString(),
                          month:index+1,
                          year: int.parse(currentYear.year.toString()),)));
                  }
                  else if(widget.ind == 2){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        BillMajurList(
                          ind:widget.ind,
                          title:widget.title,
                          name:month[index].toString(),
                          month:index+1,
                          year: int.parse(currentYear.year.toString()),)));
                  }
                  else if(widget.ind == 4){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        BillAnimalList(
                          ind:widget.ind,
                          title:widget.title,
                          name:month[index].toString(),
                          month:index+1,
                          year: int.parse(currentYear.year.toString()),)));
                  }
                  else if(widget.ind == 3){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        BillList(
                          // ind:widget.ind,
                          title:widget.title,
                          name:month[index].toString(),
                          month:index+1,
                          year: int.parse(currentYear.year.toString()),)));
                  }

                },
                child: Container(
                  height: 80,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  decoration: BoxDecoration(
                      color: AppColor.darkBoxBg,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: CommonText.semiBold("${month[index].toString()}-${currentYear.year}",color: AppColor.black,size: 18,),
                  ),
                ),
              );
            },
        ),
      ),
    );
  }
}

