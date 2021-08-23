import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sparks/alumni/utilities/school_departments.dart';
import 'package:sparks/utilities/colors.dart';
import 'package:sparks/utilities/styles.dart';

class SchoolDepartmentView extends StatefulWidget {
  final String prevSelectedDept;
  final Function(String) chosenDepartment;

  const SchoolDepartmentView(
      {Key? key,
      required this.prevSelectedDept,
      required this.chosenDepartment})
      : super(key: key);

  @override
  _SchoolDepartmentViewState createState() => _SchoolDepartmentViewState();
}

class _SchoolDepartmentViewState extends State<SchoolDepartmentView> {
  TextEditingController _deptSearchController = TextEditingController();

  final ItemScrollController itemScrollController = ItemScrollController();

  /// This boolean variable is used to indicate when text is being inputted into
  /// search field and return "true" OR "false" when the search input field is
  /// empty.
  ///
  /// The value of the variable when "true" is used to show a suffixIcon on the
  /// search input textfield to clear all inputted text
  bool _isSearchingSchoolDept = false;

  /// This variable hold the filtered school departments based on a user's search query
  List<String> _filteredSchDepartmentList = [];

  /// Variable that holds the school department selected by the user
  ///
  /// NOTE: This list will/should contain only a single value (department)
  List<String> _userSelectedDepartment = [];

  /// Method that handles toggling a check on a user's selected department
  void _departmentSelectionHandler(String dept) {
    setState(() {
      if (_userSelectedDepartment.isEmpty) {
        _userSelectedDepartment.add(dept);
        widget.chosenDepartment(dept);
        return;
      }

      _userSelectedDepartment.clear();
      _userSelectedDepartment.add(dept);
      widget.chosenDepartment(dept);
    });
  }

  void _deptSearchListener() {
    if (_deptSearchController.text.trim().length >= 1) {
      setState(() => _isSearchingSchoolDept = true);

      String searchedText = _deptSearchController.text.trim().toLowerCase();

      List<String> tempList = [];

      for (int i = 0; i < schoolDepartments.length; i++) {
        if (schoolDepartments[i].toLowerCase().contains(searchedText)) {
          setState(() {
            tempList.add(schoolDepartments[i]);
          });
        }
      }

      setState(() {
        _filteredSchDepartmentList = tempList;
      });
    }
  }

  /// This method checks if the user has made a prior department selection and
  /// then proceeds to scroll to the index of that selection
  void _scrollToPreviousDeptSelection() {
    if (widget.prevSelectedDept.isNotEmpty) {
      int getSchIndex = schDeptListToDisplay()
          .indexWhere((sch) => widget.prevSelectedDept == sch);

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        itemScrollController.jumpTo(index: getSchIndex);
      });
    }
  }

  /// Method that determines the school department list to display to the user
  ///
  /// If the search field is empty, the entire school departments is rendered to
  /// the user
  ///
  /// When there's a search query, the filtered school departments is rendered to
  /// the user
  List<String> schDeptListToDisplay() {
    if (_deptSearchController.text.trim().length >= 1)
      return _filteredSchDepartmentList;

    return schoolDepartments;
  }

  @override
  void initState() {
    super.initState();

    _deptSearchController.addListener(_deptSearchListener);

    if (widget.prevSelectedDept.isNotEmpty) {
      _userSelectedDepartment.add(widget.prevSelectedDept);
    }

    _scrollToPreviousDeptSelection();
  }

  @override
  void dispose() {
    _deptSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        color: kWhiteColor,
      ),
      child: Stack(
        overflow: Overflow.visible,
        fit: StackFit.expand,
        children: [
          Container(
            height: 96.0,
            margin: const EdgeInsets.only(top: 16.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text(
                  "Select Department",
                  style: kTextStyleFont15Bold.copyWith(fontSize: 20.0),
                ),
                SizedBox(
                  height: 12.0,
                ),
                TextField(
                  controller: _deptSearchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Search",
                    hintStyle:
                        kTextStyleFont15Medium.copyWith(color: kHintColor1),
                    suffixIcon: _isSearchingSchoolDept
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 24.0,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _deptSearchController.clear();
                              setState(() => _isSearchingSchoolDept = false);
                            },
                          )
                        : Icon(Icons.search),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120.0, left: 16.0, right: 16.0),
            child: ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              itemBuilder: (BuildContext context, int index) {
                String schDept = schDeptListToDisplay()[index];
                return CheckboxListTile(
                  title: Text(
                    "$schDept",
                    style: kTextStyleFont15Medium.copyWith(fontSize: 18.0),
                  ),
                  value:
                      _userSelectedDepartment.contains(schDept) ? true : false,
                  onChanged: (bool? value) {
                    _departmentSelectionHandler(schDept);
                  },
                );
              },
              itemCount: schDeptListToDisplay().length,
            ),
          ),
        ],
      ),
    );
  }
}
