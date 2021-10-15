
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/waterloo.dart';

void main() {

  int count = 0;

 group('Test ChangeNotifierList', () {

   setUp( () {
     count = 0;
   });

   testWidgets('Create a change notifier and amend it checking that notifications are triggered', (WidgetTester tester) async {

     var list = ChangeNotifierList<Item>();
     expect(list.list.isEmpty, true);
     list.addListener(() {
       count++;
     });
     expect(count, 0);

     list.add(Item(1));
     expect(count, 1);

     var item2 = Item(2);
     list.add(item2);
     expect(count, 2);
     expect(list.list.length ,2);

     list.remove(item2);
     expect(count, 3);
     expect(list.list.length ,1);
     expect(list.list.first.i, 1);

     var item3 = Item(3);
     var item4 = Item(4);

     list.replaceAll( [ item2, item3, item4 ]);
     expect(count, 4);

     // notify directly
     list.notify();
     expect(count, 5);

     var item5 = Item(5);
     list.add(item5, beforeItem: item4);
     expect(list.list[2].i, 5);

     var item6 = Item(6);
     list.add(item6, beforeItem: item2);
     expect(list.list.first.i, 6);

     expect(list.list.length, 5);
     list.add(item2, beforeItem: item4);
     expect(list.list.length, 5);
     expect(list.list[3].i, 2);



   });
 });
}

class Item extends Object {

  int i;

  Item(this.i);

}