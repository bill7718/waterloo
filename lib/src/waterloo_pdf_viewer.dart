

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';


///
/// To use add this to the <head> in the index.html file
///
/// `<script src="//cdnjs.cloudflare.com/ajax/libs/pdf.js/2.4.456/pdf.min.js"></script>
/// <script type="text/javascript">
///  pdfjsLib.GlobalWorkerOptions.workerSrc = "//cdnjs.cloudflare.com/ajax/libs/pdf.js/2.4.456/pdf.worker.min.js";
/// </script>`
///
///
/// Example use
///
///
///
class WaterlooPDFViewer extends StatelessWidget {
  final WaterlooPDFController pdf;

  const WaterlooPDFViewer(this.pdf, { Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return PdfView(
      controller: pdf,
      documentLoader: const Center(child: CircularProgressIndicator()),
      pageLoader: const Center(child: CircularProgressIndicator()),
    );
  }
}

class WaterlooPDFController extends PdfController {

  final Uint8List data;


  WaterlooPDFController(this.data) : super( document: PdfDocument.openData(data));
}


/*
Example use

return FutureBuilder<ByteData>(
        future: rootBundle.load('assets/test.pdf'),
        builder: (context, snapshot) {
          var data = <int>[];
          if (snapshot.hasData) {
            var i = 0;
            while (i < (snapshot.data?.lengthInBytes ?? 0)) {
              data.add(snapshot.data?.getInt8(i) ?? 0);
              i++;
            }
            return WaterlooPDFViewer(WaterlooPDFController(Uint8List.fromList(data)));
          } else {
            return Container();
          }
        });

 */
