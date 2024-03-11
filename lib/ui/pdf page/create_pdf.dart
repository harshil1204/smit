
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words_english/number_to_words_english.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

var formatter = NumberFormat('#,##,000');
 late var ttf;
class CreatePdfPage extends StatefulWidget {
  var data;
  CreatePdfPage({Key? key,this.data}) : super(key: key);

  @override
  _CreatePdfPageState createState() => _CreatePdfPageState();
}

class _CreatePdfPageState extends State<CreatePdfPage> {
  final pdf = pw.Document();


  Future<void> setGuj()async{
    final ByteData data11 = await rootBundle.load('assets/fonts/NotoSansGujarati-Regular.ttf');
    ttf = pw.Font.ttf(data11.buffer.asByteData());
  }

  @override
  void didChangeDependencies() async{

    super.didChangeDependencies();
  }
  @override
  void initState() {
    setGuj();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PdfPreview(
        pdfFileName: "chovatiya.pdf",
        onShared: (context){
          if (kDebugMode) {
            print('shared');
          }
        },
        build: (format) => generateCenteredTextWithOriginal(widget.data),
      )
    );
  }
}

pw.TextStyle boldText = pw.TextStyle(
  color: PdfColors.black,
  fontWeight: pw.FontWeight.bold,
  fontSize: 14,
  font: ttf,
);
pw.TextStyle boldTextTitle = pw.TextStyle(
  color: PdfColors.white,
  fontWeight: pw.FontWeight.bold,
  fontSize: 14,
  font: ttf,
);

pw.TextStyle simpleText =  pw.TextStyle(
  color: PdfColors.black,
  fontSize: 14,
  font: ttf,
);

pw.Widget buildTitles(var data){
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 7,vertical: 3),
    child: pw.Text(data, style: boldTextTitle),
  );
}

pw.Widget buildItems(var data,int value){
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 7,vertical: 2),
    child: pw.Text(data, style: simpleText),
  );
}

Future<Uint8List> generateCenteredTextWithOriginal(var data) async {

  final pdf = pw.Document();
  // final totalAmount = int.parse(data['totalRent'])-int.parse(data['advanced']);
  DateTime currentDate = DateTime.now();
  final image = pw.MemoryImage
    ((await rootBundle.load('assets/images/newPoster.jpeg')).buffer.asUint8List());
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Spacer(),
            pw.Container(
              width: double.infinity,
              color: PdfColor.fromHex("#043C7A"),
              child: pw.Text(
                  "Tax Invoice",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 28,
                  font: ttf,
                  fontWeight: pw.FontWeight.bold
              )
              ),
            ),
            pw.SizedBox(height: 80),
            // pw.SizedBox(height: 65),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('From :', style: boldText),
                    pw.SizedBox(height: 10),
                    pw.Text('chovatiya', style: simpleText),
                    pw.Container(
                      width: 200,
                      child: pw.Text('Gundala gir, 395006', style: simpleText),
                    ),
                  ],
                ),
                // pw.Column(
                //   mainAxisAlignment: pw.MainAxisAlignment.start,
                //   // crossAxisAlignment: pw.CrossAxisAlignment.start,
                //   children: [
                //     pw.Container(
                //       height: 60,
                //       width: 140,
                //       color: PdfColors.black,
                //       child: pw.Image(image, fit: pw.BoxFit.fill),
                //     ),
                //     // pw.SizedBox(width: 40),
                //   ],
                // ),
              ],
            ),
            pw.SizedBox(height: 25),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('To :', style: boldText),
                    pw.SizedBox(height: 10),
                    pw.Text(data['name'], style: simpleText),
                    pw.Text('india', style: simpleText),
                    // pw.Text(data['address'], style: const pw.TextStyle(
                    //   color: PdfColors.black,
                    //   fontSize: 12,
                    // )),
                  ],
                ),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Invoice :', style: boldText),
                        pw.Text('Date of Issue :', style: boldText),
                        pw.Text('Order Date :', style: boldText),
                      ],
                    ),
                    pw.SizedBox(width: 20),
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("1", style: simpleText),
                        pw.Text('${currentDate.day}-${currentDate.month}-${currentDate.year}', style: simpleText),
                        pw.Text(data['date'], style: simpleText),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 50),
            pw.Table(
              columnWidths: {
                0:const pw.FixedColumnWidth(80),
                1:const pw.FixedColumnWidth(120),
                2:const pw.FixedColumnWidth(120),
                5:const pw.FixedColumnWidth(40),
              },
                border: pw.TableBorder.all(color: PdfColor.fromHex("#043C7A")),
                tableWidth: pw.TableWidth.max,
              children:<pw.TableRow> [
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex("#043C7A")
                  ),
                  children: [
                    buildTitles('Date'),
                    buildTitles('Items'),
                    // buildTitles('Address'),
                    buildTitles('Amount'),
                  ]
                ),
                pw.TableRow(
                 verticalAlignment: pw.TableCellVerticalAlignment.full,
                  children: [
                    buildItems(data['date'],0),
                    buildItems(data['work'].toString(),0),
                    // buildItems(data['address'],0),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 7,vertical: 2),
                  child: pw.Text(formatter.format(int.parse(data['price'])), style: simpleText),
                      )
                  ]
                )
              ]
            ),
            pw.SizedBox(height: 30),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Container(),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Sub total :', style: boldText),
                        // pw.Text('Received :', style: boldText),
                      ],
                    ),
                    pw.SizedBox(width: 40),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(formatter.format(int.parse(data['price'])), style: simpleText),
                        // pw.Text(formatter.format(int.parse(data['price'])), style: simpleText),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // pw.SizedBox(height: 5),
            pw.Divider(
              thickness: 1,
              color: PdfColors.black,
              indent: 330,
            ),
            // pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(),
                    pw.Text('Balance :', style: boldText),
                    pw.SizedBox(width: 48),
                    pw.Text(formatter.format(int.parse(data['price'].toString())), style: simpleText),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 25),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Table(
                    border: pw.TableBorder.all(color: PdfColor.fromHex("#043C7A")),
                    tableWidth: pw.TableWidth.max,
                  children: [
                    pw.TableRow(
                        decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex("#043C7A")
                        ),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 12),
                            child: pw.Text("Invoice Amount In words",style: boldTextTitle),
                          )
                        ]
                    ),
                    pw.TableRow(
                        children: [
                          pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 6),
                              child: pw.Center(child: pw.Text("${NumberToWordsEnglish.convert(int.parse(data['price'].toString()))} only",style: simpleText))
                          ),
                        ]
                    ),
                  ]
                ),
              ]
            ),
            pw.Spacer(),
            pw.Divider(
              thickness: 1,
              color: PdfColors.black,
            ),
            pw.Spacer(),
            // pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.bottomCenter,
              child: pw.Text(
                'Thanks ${data['name'].split(' ')[0]} for you order!',
                style: pw.TextStyle(
                  fontSize: 19,
                  font: ttf,
                  color: PdfColor.fromHex("#043C7A")
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
  return pdf.save();
}