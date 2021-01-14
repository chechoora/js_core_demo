import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_core_demo/dialog_utils.dart';
import 'package:js_core_demo/guest_reposittory.dart';
import 'package:js_core_demo/js_demo_bloc.dart';
import 'package:js_core_demo/model.dart';

class JsDemoPage extends StatefulWidget {
  @override
  _JsDemoPageState createState() => _JsDemoPageState();
}

class _JsDemoPageState extends State<JsDemoPage> {
  JsDemoBloc _jsDemoBloc;

  int _pieces;
  String _topping;
  bool _hasGluten = false;

  final Set<Guest> pickedGuests = {};

  @override
  void initState() {
    _jsDemoBloc = JsDemoBloc(DefaultAssetBundle.of(context), GuestRepository());
    super.initState();
  }

  @override
  void dispose() {
    _jsDemoBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _jsDemoBloc,
      child: BlocConsumer<JsDemoBloc, JsDemoState>(
        listenWhen: (previous, current) {
          return current is ValidatedState || current is ErrorState;
        },
        buildWhen: (previous, current) {
          return current is IdleState || current is DataState;
        },
        listener: (context, state) {
          if (state is ErrorState) {
            showErrorMessage(state.message);
          }
          if (state is ValidatedState) {
            alert(context, state.message);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildCakeBuilder(),
              if (state is DataState) _buildGuestList(state.guests),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCakeBuilder() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24, horizontal: 6),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 8,
              ),
              Text(
                'Create Cake',
                style: TextStyle(fontSize: 24),
              ),
              _buildPiecesCounter(),
              _buildTopping(),
              _buildGlutenCheck(),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    'Validate',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  onPressed: () {
                    if (_cakeIsDone()) {
                      _jsDemoBloc.validateCake(
                        Cake(_pieces, _topping, _hasGluten),
                        pickedGuests.toList(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPiecesCounter() {
    return TextField(
      focusNode: FocusNode(canRequestFocus: false),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(hintText: 'How many pieces it will be?'),
      onChanged: (String value) {
        _pieces = int.parse(value);
      },
    );
  }

  Widget _buildTopping() {
    return DropdownButton(
        value: _topping,
        items: [
          DropdownMenuItem(
            child: Text(CakeTopping.vanilla),
            value: CakeTopping.vanilla,
          ),
          DropdownMenuItem(
            child: Text(CakeTopping.chocolate),
            value: CakeTopping.chocolate,
          ),
          DropdownMenuItem(
            child: Text(CakeTopping.apple),
            value: CakeTopping.apple,
          ),
          DropdownMenuItem(
            child: Text(CakeTopping.cherie),
            value: CakeTopping.cherie,
          ),
          DropdownMenuItem(
            child: Text(CakeTopping.strawberry),
            value: CakeTopping.strawberry,
          ),
        ],
        onChanged: (value) {
          setState(() {
            _topping = value;
          });
        });
  }

  Widget _buildGlutenCheck() {
    return Row(
      children: [
        Text('Has Gluten:'),
        Switch(
          value: _hasGluten,
          onChanged: (bool value) {
            setState(() {
              _hasGluten = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildGuestList(List<Guest> guests) {
    return Expanded(
        child: ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: guests.length,
      itemBuilder: (context, index) {
        final guest = guests[index];
        final isPicked = pickedGuests.contains(guest);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isPicked) {
                pickedGuests.remove(guest);
              } else {
                pickedGuests.add(guest);
              }
            });
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Ink(
              color: isPicked ? Colors.blueGrey : Colors.white,
              child: ListTile(
                title: Text(guest.name),
                subtitle: Text(guest.favoriteToppings.join(', ')),
                trailing: Container(
                  width: 144,
                  child: Row(
                    children: [
                      Text('Allergic to Gluten:'),
                      guest.glutenAllergic ? Icon(Icons.check_circle) : Icon(Icons.remove_circle_outline_sharp)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ));
  }

  bool _cakeIsDone() {
    if (_pieces == null || _topping == null) {
      showErrorMessage('Cake is not done');
      return false;
    } else if (pickedGuests.isEmpty) {
      showErrorMessage('Guest are not picked');
      return false;
    }
    return true;
  }
}
