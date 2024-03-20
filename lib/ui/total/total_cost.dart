import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smit/resource/colors.dart';
import 'package:smit/resource/text.dart';

class TotalCost extends StatefulWidget {
  const TotalCost({super.key});

  @override
  State<TotalCost> createState() => _TotalCostState();
}

class _TotalCostState extends State<TotalCost> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<dynamic> dava = [];
  List<dynamic> khatar = [];
  List<dynamic> majur = [];
  List<dynamic> animal = [];
  List<dynamic> tractor = [];

  DateTime currentYear = DateTime.now();
  bool isLoading = false;
  int totalDava = 0;
  int totalKhatar = 0;
  int totalMajur = 0;
  int totalAnimal = 0;
  int totalTractor = 0;

  @override
  void initState() {
    super.initState();
  }

  void setValues(){
    totalDava = 0;
    totalKhatar = 0;
    totalMajur = 0;
    totalAnimal = 0;
    totalTractor = 0;
  }

  @override
  void didChangeDependencies() async {
    await fetchCollectionData(currentYear.year);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonText.semiBold("Total  ( ${currentYear.year} )", size: 18),
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
                          onChanged: (DateTime dateTime) async{
                            setState(() {
                              currentYear = dateTime;
                            });
                            Navigator.pop(context);
                            setValues();
                            await fetchCollectionData(currentYear.year);
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
      body:isLoading == true ? const Center(
         child: CircularProgressIndicator(),
      ) : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Container(
                  height: 75,
                  decoration: BoxDecoration(color: AppColor.darkBoxBg, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CommonText.bold("કુલ દવા",size: 22,),
                      CommonText.bold("₹ $totalDava",size: 22,),
                    ],
                  ),
                )),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Container(
                  height: 75,
                  decoration: BoxDecoration(color: AppColor.darkBoxBg, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CommonText.bold("કુલ ખાતર",size: 22,),
                      CommonText.bold("₹ $totalKhatar",size: 22,),
                    ],
                  ),
                ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 75,
              width: double.infinity,
              decoration: BoxDecoration(color: AppColor.darkBoxBg, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CommonText.bold("કુલ દવા + કુલ ખાતર",size: 22,),
                  CommonText.bold("₹ ${totalDava + totalKhatar}",size: 22,),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            const Divider(color: AppColor.primary,thickness: 0.6,height: 1,),
            const SizedBox(height: 50,),
            Row(
              children: [
                Expanded(
                    child:  Container(
                      height: 75,
                      width: double.infinity,
                      decoration: BoxDecoration(color: AppColor.darkBoxBg, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CommonText.bold("કુલ મજુરી",size: 22,),
                          CommonText.bold("₹ $totalMajur",size: 22,),
                        ],
                      ),
                    ),),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child:  Container(
                      height: 75,
                      width: double.infinity,
                      decoration: BoxDecoration(color: AppColor.darkBoxBg, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CommonText.bold("કુલ ઢોર-ખાખર",size: 22,),
                          CommonText.bold("₹ $totalAnimal",size: 22,),
                        ],
                      ),
                    ),),
              ],
            ),
            const SizedBox(height: 20,),
            const Divider(color: AppColor.primary,thickness: 0.6,height: 1,),
            const SizedBox(height: 50,),

            Container(
              height: 75,
              width: double.infinity,
              decoration: BoxDecoration(color: AppColor.darkBoxBg, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CommonText.bold("કુલ ટ્રેક્ટર ભાડું",size: 22,),
                  CommonText.bold("₹ $totalTractor",size: 22,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchCollectionData(int year) async {
    setState(() {
      isLoading = true;
    });
    await _firestore.collection('Dava').where('year',isEqualTo: year).get().then(
      (value) {
        dava = value.docs;
        dava.forEach((element) {
          totalDava= totalDava + int.parse(element['price'].toString());
        });
      },
    );

    await _firestore.collection('Khatar').where('year',isEqualTo: year).get().then(
      (value) {
        khatar = value.docs;
        print(khatar.length);
        khatar.forEach((element) {
          totalKhatar= totalKhatar + int.parse(element['price'].toString());
        });
      },
    );

    await _firestore.collection('majur').where('year',isEqualTo: year).get().then(
      (value) {
        majur = value.docs;
        print(majur.length);
        majur.forEach((element) {
          totalMajur= totalMajur + (int.parse(element['majuri'].toString()) * int.parse(element['totalMajuri'].toString()));
        });
      },
    );

    await _firestore.collection('animal').where('year',isEqualTo: year).get().then(
      (value) {
        animal = value.docs;
        animal.forEach((element) {
          totalAnimal= totalAnimal + (int.parse(element['docFee'].toString()) + int.parse(element['medical'].toString()));
        });
      },
    );
    await _firestore.collection('tractor').where('year',isEqualTo: year).get().then(
      (value) {
        tractor = value.docs;
        tractor.forEach((element) {
          totalTractor= totalTractor + int.parse(element['price'].toString());
        });
      },
    );
    setState(() {
    isLoading = false;
    });
  }
}
