import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/beta/waterloo_text_button.dart';
import 'package:file_picker/file_picker.dart';

///
///
///  <style>
///     input[type=file] {
///     width: 0px;
///     }
///   </style>
///
///
class WaterlooFileUploader extends StatelessWidget {
  static const String defaultButtonText = 'Select File';
  static const String defaultBeforeUploadText = '';
  static const String defaultOnUploadText = 'Upload';

  final String buttonText;
  final String beforeUploadText;
  final String onUploadText;
  final Function callback;
  final Function exceptionHandler;

  const WaterlooFileUploader(
      {Key? key,
      this.buttonText = defaultButtonText,
      this.beforeUploadText = defaultBeforeUploadText,
      this.onUploadText = defaultOnUploadText,
        required this.exceptionHandler,
      required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WaterlooFileListener fileData = WaterlooFileListener();

    return ChangeNotifierProvider<WaterlooFileListener>.value(
        value: fileData,
        child: Consumer<WaterlooFileListener>(
          builder: (context, data, _) {
            if (data.fileName.isEmpty) {
              return Column(
                children: [
                  Text(beforeUploadText),
                  WaterlooTextButton(
                      text: buttonText,
                      exceptionHandler: exceptionHandler,
                      onPressed: () {
                        var f = FilePicker.platform.pickFiles(withData: true);
                        f.then((result) {
                          fileData.setFileData(
                              result?.files.first.name ?? '', result?.files.first.bytes ?? Uint8List(0));
                          callback(fileData);
                        });
                      })
                ],
              );
            } else {
              return Column(
                children: [
                  Text(onUploadText),
                  WaterlooTextButton(
                      text: buttonText,
                      exceptionHandler: exceptionHandler,
                      onPressed: () {
                        var f = FilePicker.platform.pickFiles(withData: true);
                        f.then((result) {
                          fileData.setFileData(
                              result?.files.first.name ?? '', result?.files.first.bytes ?? Uint8List(0));
                          callback(fileData);
                        });
                      })
                ],
              );
            }
          },
        ));
  }
}

class WaterlooFileData {
  String? _fileName;
  Uint8List? _data;

  WaterlooFileData(this._fileName, this._data);

  String get fileName => _fileName ?? '';
  Uint8List get data => _data ?? Uint8List(0);

  int get length=>_data?.lengthInBytes ?? 0;
}

class WaterlooFileListener extends WaterlooFileData with ChangeNotifier {
  WaterlooFileListener({String? fileName, Uint8List? data}) : super(fileName, data);

  setFileData(String fileName, Uint8List data) {
    _fileName = fileName;
    _data = data;
    notifyListeners();
  }
}
