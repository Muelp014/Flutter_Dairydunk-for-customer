import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mycurrentlocation extends StatefulWidget {
  const Mycurrentlocation({Key? key}) : super(key: key);

  @override
  _MycurrentlocationState createState() => _MycurrentlocationState();

  static Future<String> getAddressData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('address') ?? "Address here";
  }
}

class _MycurrentlocationState extends State<Mycurrentlocation> {
  String _address = "กรุณากรอกที่อยู่";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  void _loadAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _address = prefs.getString('address') ?? "กรุณากรอกที่อยู่";
    });
  }

  void _saveAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('address', address);
  }

  void openLocationSearchBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Your Location"),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: "Search address..."),
        ),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          MaterialButton(
            onPressed: () {
              setState(() {
                _address = _controller.text;
              });
              _saveAddress(_address);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery now',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          GestureDetector(
            onTap: () => openLocationSearchBox(context),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    children: [
                      Text(
                        _address,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
