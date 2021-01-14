import 'package:js_core_demo/model.dart';

class GuestRepository {
  final List<Guest> _guests = [
    Guest('Ben', [CakeTopping.vanilla, CakeTopping.cherie], false),
    Guest('Alex', [CakeTopping.apple, CakeTopping.chocolate], false),
    Guest('Jones', [CakeTopping.apple, CakeTopping.vanilla], true),
    Guest('Joe', [CakeTopping.apple, CakeTopping.vanilla], false),
    Guest('Steven', [CakeTopping.strawberry, CakeTopping.apple], false),
  ];

  List<Guest> fetchGuests() {
    return _guests;
  }

}
