import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MarkdownViewer extends StatelessWidget {
  final String content;
  final double lineSeparation;

  const MarkdownViewer({Key? key, required this.content, this.lineSeparation = 5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    var lines = content.split('\n');

    var currentType = MarkdownType.normal;
    var margin = EdgeInsets.fromLTRB(0, lineSeparation / 2, 0, lineSeparation / 2);

    for (var line in lines) {
      var newMarkdownType = markdownType(line, currentType);

      switch (newMarkdownType) {
        case MarkdownType.divider:
          widgets.add(const Divider());
          break;

        case MarkdownType.heading1:
          widgets.add(Container(margin: margin, child: Text(line.substring(1).trim(), style: Theme.of(context).textTheme.headline1)));
          break;

        case MarkdownType.heading2:
          widgets.add(Container(margin: margin, child: Text(line.substring(2).trim(), style: Theme.of(context).textTheme.headline2)));
          break;

        case MarkdownType.heading3:
          widgets.add(Container(margin: margin, child: Text(line.substring(3).trim(), style: Theme.of(context).textTheme.headline3)));
          break;

        case MarkdownType.heading4:
          widgets.add(Container(margin: margin, child: Text(line.substring(4).trim(), style: Theme.of(context).textTheme.headline4)));
          break;

        case MarkdownType.heading5:
          widgets.add(Container(margin: margin, child: Text(line.substring(5).trim(), style: Theme.of(context).textTheme.headline5)));
          break;

        case MarkdownType.heading6:
          widgets.add(Container(margin: margin, child: Text(line.substring(6).trim(), style: Theme.of(context).textTheme.headline6)));
          break;

        default:
          widgets.add(Container(margin: margin, child: Text(line)));
      }
      currentType = newMarkdownType;
    }

    return Column(
      children: widgets,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

class MarkdownPageView extends StatefulWidget {
  final String content;
  final String baseUrl;

  const MarkdownPageView({Key? key, required this.content, this.baseUrl = 'http://localhost:8081/doc/'}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MarkdownPageViewState();
}

class MarkdownPageViewState extends State<MarkdownPageView> {
  late String doc;

  List<String> docStack = <String>[];

  List<String> tableData = <String>[];

  void refresh() {
    setState(() {});
  }

  void back() {
    setState(() {
      if (docStack.isNotEmpty) {
        doc = docStack.last;
        docStack.removeLast();
      }
    });
  }

  @override
  void initState() {
    doc = widget.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? link = Theme.of(context).textTheme.bodyText2?.copyWith(color: Theme.of(context).primaryColor, decoration: TextDecoration.underline);

    return FutureBuilder<String>(
        future: http.read(Uri.parse(widget.baseUrl + doc)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (doc.endsWith('.feature')) {
              return MarkdownViewer(content: snapshot.data!);
            }

            return buildMarkdown(context, snapshot.data!, link);
          } else {
            return const Text('Waiting .....');
          }
        });
  }

  Widget buildMarkdown(BuildContext context, String content, TextStyle? link) {
    var widgets = <Widget>[];
    var lines = content.split('\n');
    String currentText = '';
    var currentType = MarkdownType.normal;

    for (var line in lines) {
      var newMarkdownType = markdownType(line, currentType);

      switch (newMarkdownType) {
        case MarkdownType.heading1:
          currentText.isNotEmpty ? widgets.add(normalTextLine(currentText, link)) : {};
          currentText = '';
          widgets.add(Text(
            line.substring(1).trim(),
            style: Theme.of(context).textTheme.headline1,
          ));
          break;

        case MarkdownType.heading2:
          currentText.isNotEmpty ? widgets.add(normalTextLine(currentText, link)) : {};
          currentText = '';
          widgets.add(Text(
            line.substring(2).trim(),
            style: Theme.of(context).textTheme.headline2,
          ));
          break;

        case MarkdownType.heading3:
          currentText.isNotEmpty ? widgets.add(normalTextLine(currentText, link)) : {};
          currentText = '';
          widgets.add(Text(
            line.substring(3).trim(),
            style: Theme.of(context).textTheme.headline3,
          ));
          break;

        case MarkdownType.heading4:
          currentText.isNotEmpty ? widgets.add(normalTextLine(currentText, link)) : {};
          currentText = '';
          widgets.add(Text(
            line.substring(4).trim(),
            style: Theme.of(context).textTheme.headline4,
          ));
          break;

        case MarkdownType.heading5:
          currentText.isNotEmpty ? widgets.add(normalTextLine(currentText, link)) : {};
          currentText = '';
          widgets.add(Text(
            line.substring(5).trim(),
            style: Theme.of(context).textTheme.headline5,
          ));
          break;

        case MarkdownType.heading6:
          currentText.isNotEmpty ? widgets.add(normalTextLine(currentText, link)) : {};
          currentText = '';
          widgets.add(Text(
            line.substring(6).trim(),
            style: Theme.of(context).textTheme.headline6,
          ));
          break;

        case MarkdownType.newLine:
          if (currentType == MarkdownType.table) {
            widgets.add(makeTable(context, tableData, link));
            tableData.clear();
          } else {
            currentText = (currentText + line).trim();
            widgets.add(normalTextLine(currentText, link));
            currentText = '';
          }
          break;

        case MarkdownType.divider:
          currentText.isNotEmpty ? widgets.add(normalTextLine(currentText, link)) : {};
          widgets.add(const Divider());
          currentText = '';
          break;

        case MarkdownType.unOrderedList:
          currentText.isNotEmpty ? widgets.add(normalTextLine(currentText, link)) : {};
          currentText = '';
          widgets.add(
            Row(children: [
              Icon(
                Icons.arrow_right,
                color: Theme.of(context).primaryColor,
              ),
              normalTextLine(line.substring(2), link)
            ]),
          );
          currentText = '';
          break;

        case MarkdownType.table:
          tableData.add(line);
          break;

        default:
          currentText = (currentText + ' ' + line).trim();
      }

      currentType = newMarkdownType;
    }

    if (currentType == MarkdownType.table) {
      widgets.add(makeTable(context, tableData, link));
      tableData.clear();
    } else {
      currentText.isNotEmpty ? widgets.add(Text(currentText)) : {};
    }

    return Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          key: GlobalKey(),
          children: widgets,
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
  }

  Widget makeTable(BuildContext context, List<String> tableData, TextStyle? link) {
    var columnData = tableData.first.split('|');
    var columns = <DataColumn>[];
    for (var columnText in columnData) {
      columns.add(DataColumn(label: Text(columnText)));
    }

    tableData.removeRange(0, 2);

    var rows = <DataRow>[];
    for (var row in tableData) {
      var cells = <DataCell>[];
      for (var cellData in row.split('|')) {
        cells.add(DataCell(normalTextLine(cellData, link)));
      }
      rows.add(DataRow(cells: cells));
    }

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 10,
          columns: columns,
          rows: rows,
          headingTextStyle: Theme.of(context).textTheme.subtitle2?.copyWith(color: Theme.of(context).primaryColor),
        ));
  }

  Widget normalTextLine(String text, TextStyle? link) {
    if (text.isEmpty) {
      return const Text('');
    }

    var widgets = <Widget>[];
    for (var item in splitMarkdown([text])) {
      if (item.startsWith('(') && !item.startsWith('( ') && item.endsWith(')')) {
        widgets.add(
          InkWell(
            child: Text(
              item.substring(1, item.length - 1),
              style: link,
            ),
            onTap: () {
              setState(() {
                docStack.add(doc);
                doc = item.substring(1, item.length - 1);
              });
            },
          ),
        );
      } else {
        if (item.startsWith('!(') && !item.startsWith('(! ') && item.endsWith(')')) {
          widgets.add(Image.network(
            widget.baseUrl + item.substring(2, item.length - 1),
          ));
        } else {
          widgets.add(Text(item));
        }
      }
    }

    return Wrap(children: widgets);
  }

  List<String> splitMarkdown(List<String> items) {
    var response = <String>[];
    for (var item in items) {
      if (item.isNotEmpty) {
        var openBracket = item.indexOf('(');
        var found = false;
        while (openBracket > -1 && !found) {
          if (item.indexOf('( ') == openBracket) {
            openBracket = item.indexOf('(', openBracket + 1);
          } else {
            found = true;
          }
        }
        var openExclamationMark = item.indexOf('!(');
        found = false;
        while (openExclamationMark > -1 && !found) {
          if (item.indexOf('!( ') == openExclamationMark) {
            openExclamationMark = item.indexOf('!(', openExclamationMark + 1);
          } else {
            found = true;
          }
        }
        if (openBracket == -1 && openExclamationMark == -1) {
          response.add(item);
        } else {
          var start = (openBracket == -1 || openExclamationMark > -1 && openExclamationMark < openBracket) ? openExclamationMark : openBracket;
          var closeBracket = item.indexOf(')', start);
          if (start == 0 && closeBracket == item.length - 1) {
            response.add(item);
          } else {
            var first = item.substring(0, start);
            var second = item.substring(start, closeBracket + 1);
            var third = item.substring(closeBracket + 1);
            response.addAll(splitMarkdown([first, second, third]));
          }
        }
      }
    }

    return response;
  }
}

enum MarkdownType { table, divider, normal, heading1, heading2, heading3, heading4, heading5, heading6, newLine, unOrderedList }

MarkdownType markdownType(String line, MarkdownType current) {
  if (line.startsWith('###### ')) {
    return MarkdownType.heading6;
  }

  if (line.startsWith('##### ')) {
    return MarkdownType.heading5;
  }

  if (line.startsWith('#### ')) {
    return MarkdownType.heading4;
  }

  if (line.startsWith('### ')) {
    return MarkdownType.heading3;
  }

  if (line.startsWith('## ')) {
    return MarkdownType.heading2;
  }

  if (line.startsWith('# ')) {
    return MarkdownType.heading1;
  }

  if (line.startsWith('---')) {
    return MarkdownType.divider;
  }

  if (line.trim().isEmpty || line.endsWith('  ')) {
    return MarkdownType.newLine;
  }

  if (line.startsWith('- ')) {
    return MarkdownType.unOrderedList;
  }

  if (line.startsWith('|')) {
    return MarkdownType.table;
  }

  return MarkdownType.normal;
}
