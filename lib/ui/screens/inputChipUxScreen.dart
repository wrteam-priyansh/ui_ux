import 'dart:async';

import 'package:flutter/material.dart';

class InputChipUxScreen extends StatelessWidget {
  const InputChipUxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TextButton(
                  onPressed: () {
                    //
                    showModalBottomSheet(
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        )),
                        enableDrag: true,
                        context: context,
                        builder: (context) {
                          return AddAttributeBottomSheet();
                        });
                  },
                  child: Text("Add Attribute")),
            ),
          ],
        ),
      ),
    );
  }
}

class AddAttributeBottomSheet extends StatefulWidget {
  AddAttributeBottomSheet({Key? key}) : super(key: key);

  @override
  _AddAttributeBottomSheetState createState() => _AddAttributeBottomSheetState();
}

class _AddAttributeBottomSheetState extends State<AddAttributeBottomSheet> {
  //late StreamSubscription<bool> keyboardSubscription;
  List<String> colors = ["Red", "Yellow", "Blue", "Green", "Pink", "Purple"];

  List<String> selectedColors = [];

  List<String> suggestedColors = [];

  bool showSuggestedAttributes = false;

  TextEditingController textEditingController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();

  //   //var keyboardVisibilityController = KeyboardVisibilityController();

  //   //keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {});
  // }

  // @override
  // void dispose() {
  //   keyboardSubscription.cancel();
  //   super.dispose();
  // }

  bool isAttributeAdded(String element) {
    return selectedColors.contains(element);
  }

  Widget _buildSuggestions() {
    return Column(
      children: suggestedColors
          .map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  tileColor: isAttributeAdded(e) ? Colors.grey : Colors.white,
                  onTap: () {
                    if (isAttributeAdded(e)) {
                      selectedColors.remove(e);
                    } else {
                      selectedColors.add(e);
                    }

                    setState(() {});
                  },
                  title: Text(e),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSelectedAttributes() {
    return selectedColors.isEmpty
        ? Center(child: Text("Please add attributes"))
        : Column(
            children: selectedColors
                .map((e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: isAttributeAdded(e) ? Colors.grey : Colors.white,
                        onTap: () {
                          selectedColors.remove(e);
                          setState(() {});
                        },
                        title: Text(e),
                      ),
                    ))
                .toList(),
          );
  }

  void clearTextField() {
    textEditingController.clear();
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
    setState(() {
      showSuggestedAttributes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (textEditingController.text.isNotEmpty) {
          clearTextField();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onTap: () {
                    setState(() {
                      showSuggestedAttributes = true;
                      suggestedColors.clear();
                    });
                  },
                  controller: textEditingController,
                  onChanged: (value) {
                    if (value.trim().isNotEmpty) {
                      final suggestions = colors.where((element) => element.toLowerCase().contains(value.trim().toLowerCase())).toList();

                      suggestedColors.clear();
                      suggestedColors.addAll(suggestions);
                      if (!showSuggestedAttributes) {
                        showSuggestedAttributes = true;
                      }

                      setState(() {});
                    } else {
                      //
                      showSuggestedAttributes = false;
                      setState(() {});
                    }
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          color: Colors.black,
                          onPressed: () {
                            clearTextField();
                          },
                          icon: Icon(Icons.close)),
                      hintText: "Search Attribute"),
                ),
                SizedBox(
                  height: 30.0,
                ),
                AnimatedSwitcher(
                    duration: Duration(
                      milliseconds: 300,
                    ),
                    child: showSuggestedAttributes ? _buildSuggestions() : _buildSelectedAttributes()),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * (0.85),
          ),
        ),
      ),
    );
  }
}
