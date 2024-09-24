import 'package:DairyDunk/model/driverprofile.dart';
import 'package:flutter/material.dart';
import 'package:DairyDunk/components/myrecipt.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Oderedpage extends StatefulWidget {
  const Oderedpage({Key? key}) : super(key: key);

  @override
  _OderedpageState createState() => _OderedpageState();
}

class _OderedpageState extends State<Oderedpage> {
  DriverProfile? driverProfile;

  @override
  void initState() {
    super.initState();
    _fetchDriverProfile();
  }

  Future<void> _fetchDriverProfile() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('deliprogress').doc('orderId').get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          driverProfile = DriverProfile.fromMap(data['driverProfile']);
        });
      }
    } catch (e) {
      print('Error fetching driver profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery in progress.."),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Myrecipt(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                if (driverProfile != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DriverProfilePage(driverProfile: driverProfile!),
                    ),
                  );
                }
              },
              icon: Icon(Icons.person),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                driverProfile?.name ?? "Ms.Chalintip",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              Text(
                "Driver",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => _openLineChat('line://ti/p/@clown546'),
                  icon: const Icon(Icons.message),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    if (driverProfile != null) {
                      _makePhoneCall('tel:${driverProfile!.phone}');
                    }
                  },
                  icon: Icon(Icons.phone),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _openLineChat(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class DriverProfilePage extends StatelessWidget {
  final DriverProfile driverProfile;

  const DriverProfilePage({Key? key, required this.driverProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${driverProfile.name}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text("Phone: ${driverProfile.phone}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8.0),
            Text("Vehicle Details: ${driverProfile.vehicleDetails}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8.0),
            Text("Status: ${driverProfile.status}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
