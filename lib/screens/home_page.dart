import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quantity_input/quantity_input.dart';
import '../constants/colors.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text fields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final CollectionReference _productss =
      FirebaseFirestore.instance.collection('products');
  int simpleIntInput = 1;
  String selectedStationeryItem = "Stationery";

  List<DropdownMenuItem<String>> get stationeryList {
    final List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Stationery"), value: "Stationery"),
      DropdownMenuItem(child: Text("hole puncher"), value: "hole puncher"),
      DropdownMenuItem(
          child: Text("stapler and staples"), value: "stapler and staples"),
      DropdownMenuItem(child: Text("tapes"), value: "tapes"),
      DropdownMenuItem(child: Text("brushes"), value: "brushes"),
      DropdownMenuItem(child: Text("colour pencils"), value: "colour pencils"),
      DropdownMenuItem(child: Text("crayons"), value: "crayons"),
      DropdownMenuItem(child: Text("water colour"), value: "water colour"),
      DropdownMenuItem(child: Text("erasers"), value: "erasers"),
      DropdownMenuItem(child: Text("printer"), value: "printer"),
      DropdownMenuItem(
          child: Text("expandable file"), value: "expandable file"),
      DropdownMenuItem(child: Text("envelope"), value: "envelope"),
      DropdownMenuItem(child: Text("notebooks"), value: "notebooks"),
      DropdownMenuItem(
          child: Text("college ruled paper"), value: "college ruled paper"),
      DropdownMenuItem(child: Text("pen"), value: "pen"),
      DropdownMenuItem(child: Text("pencils"), value: "pencils"),
      DropdownMenuItem(
          child: Text("highlighter pen"), value: "highlighter pen"),
      DropdownMenuItem(child: Text("scissor"), value: "scissor"),
      DropdownMenuItem(child: Text("calculator"), value: "calculator"),
      DropdownMenuItem(
          child: Text("mathematical instrument"),
          value: "mathematical instrument"),
    ];
    return menuItems;
  }

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      selectedStationeryItem = documentSnapshot['stationery'];
      simpleIntInput = documentSnapshot['quantity'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    value: selectedStationeryItem,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStationeryItem = newValue!;
                      });
                    },
                    items: stationeryList),
                QuantityInput(
                    minValue: 1,
                    maxValue: 10,
                    value: simpleIntInput,
                    onChanged: (value) => setState(() =>
                        simpleIntInput = int.parse(value.replaceAll(',', '')))),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ColorStyle.green)),
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? stationery = selectedStationeryItem;
                    final int? quantity = simpleIntInput;
                    final String? status = "";
                    if (stationery != null && quantity != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _productss.add({
                          "stationery": stationery,
                          "quantity": quantity,
                          "status": status
                        });
                      }

                      if (action == 'update') {
                        // Update the product
                        await _productss.doc(documentSnapshot!.id).update(
                            {"stationery": stationery, "quantity": quantity});
                      }

                      // Clear the text fields
                      selectedStationeryItem = '';
                      simpleIntInput.toString();

                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  // Deleteing a product by id
  Future<void> _deleteProduct(String productId) async {
    await _productss.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyle.green,
        title: const Text('Stationery Request List'),
        actions: <Widget>[
          //Logout functionality
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: ColorStyle.black),
            ),
          ),
        ],
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _productss.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                        "stationery Item:" + documentSnapshot['stationery']),
                    subtitle: Column(
                      children: [
                        Text("quantity:" +
                            documentSnapshot['quantity'].toString()),
                        Text("status:" + documentSnapshot['status'].toString()),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single product
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // This icon button is used to delete a single product
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Add new product
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorStyle.green,
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
