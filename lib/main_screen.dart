import 'package:flutter/material.dart';
import 'package:smit/resource/colors.dart';
import 'package:smit/resource/text.dart';
import 'package:smit/ui/total/total_cost.dart';

import 'homepage.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final List<String> items = ["દવા","ક્રુતિમ ખાતર","મજુર","ટ્રેક્ટર","ઢોર ખાખર","કુલ હિસાબ"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        centerTitle: false,
        title: const CommonText.extraBold("Chovatiya",size: 18,),
       ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,crossAxisSpacing: 10,mainAxisSpacing: 10
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  // if(index==0){
                  //   Navigator.push(context, MaterialPageRoute(builder: (context) =>  BillDavaList(),));
                  // }
                  if(index == 5){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  const TotalCost()));
                  }
                  else{
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  HomePage(title: items[index],ind: index),));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColor.darkBoxBg,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: CommonText.semiBold(items[index].toString(),size: 22,),
                  ),
                ),
              );
            },
        ),
      ),
    );
  }
}
