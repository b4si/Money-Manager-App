// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/db/category_db/category_db.dart';
import 'package:money_manager/db/transaction_db/transaction_db.dart';
import 'package:money_manager/transaction_model/transaction_model.dart';
import '../../catagory_model/category_model.dart';
import 'widget.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

class _FormScreenState extends State<FormScreen> {
  String? _categoryID;
  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  CategoryModel? _selectedCategoryModel;

  @override
  void initState() {
    _selectedCategorytype = CategoryType.income;
    super.initState();
  }

  TextEditingController amountController = TextEditingController();
  final nameEditingController = TextEditingController();

  final incomeCategoryList = CategoryDB().incomeCategoryListNotifier.value;
  final expenseCategoryList = CategoryDB().expenseCategoryListNotifier.value;
  @override
  Widget build(BuildContext context) {
    CategoryDB.instance.refreshUI();
    // String? category;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add transactions'),
        backgroundColor: const Color(0xFF15485D),
      ),
      body: SizedBox(
        height: 320,
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                      value: CategoryType.income,
                      groupValue: _selectedCategorytype,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategorytype = CategoryType.income;
                          _categoryID = null;
                        });
                      },
                    ),
                    const Text('Income')
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: CategoryType.expense,
                      groupValue: _selectedCategorytype,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategorytype = CategoryType.expense;
                          _categoryID = null;
                        });
                      },
                    ),
                    const Text('Expense'),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: _categoryID,
                    hint: const Text('Select category'),
                    items: (_selectedCategorytype == CategoryType.income
                            ? CategoryDB().incomeCategoryListNotifier
                            : CategoryDB().expenseCategoryListNotifier)
                        .value
                        .map(
                      (e) {
                        return DropdownMenuItem(
                          value: e.id,
                          child: Text(e.name),
                          onTap: () {
                            _selectedCategoryModel = e;
                          },
                        );
                      },
                    ).toList(),
                    onChanged: (selectedValue) {
                      setState(
                        () {
                          _categoryID = selectedValue;
                        },
                      );
                    },
                    onTap: () {},
                  ),
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return Center(
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text(
                                      "Add category",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: nameEditingController,
                                      decoration: const InputDecoration(
                                        labelText: 'category name',
                                      ),
                                      maxLength: 10,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: const [
                                          RadioButton(
                                            title: 'Income',
                                            type: CategoryType.income,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          RadioButton(
                                            title: 'Expense',
                                            type: CategoryType.expense,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final name = nameEditingController.text;
                                      if (name.isEmpty) {
                                        return;
                                      }
                                      final type =
                                          selectedCategoryNotifier.value;
                                      final category = CategoryModel(
                                        id: DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                        name: name,
                                        type: type,
                                      );
                                      CategoryDB().insertCategory(category);

                                      Navigator.of(context).pop();
                                      setState(() {
                                        CategoryDB.instance.refreshUI();
                                      });
                                      nameEditingController.clear();
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.add)),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 5, bottom: 5, right: 12, left: 12),
              child: TextFormField(
                controller: amountController,
                decoration: const InputDecoration(hintText: 'Amount'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final selectedDateTemp = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 30)),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDateTemp == null) {
                        return;
                      } else {
                        setState(() {
                          _selectedDate = selectedDateTemp;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_month),
                    label: Text(
                      _selectedDate == null
                          ? 'Select date'
                          : ('${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(),
                onPressed: () {
                  checkAmount();
                  TransactionDB.instance.refresh();
                },
                child: const Text('Submit'))
          ],
        ),
      ),
    );
  }

  void checkAmount() {
    final amountCheck = amountController.text.trim();
    final dateCheck = _selectedDate;
    if (_categoryID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content: Text('Select Category'),
        ),
      );
    } else if (amountCheck.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content: Text('Amount Required'),
        ),
      );
    } else if (dateCheck == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content: Text('Date Required'),
        ),
      );
    } else {
      addtransaction();
      Navigator.of(context).pop();
    }
  }

  Future<void> addtransaction() async {
    final _amountText = amountController.text;
    final _date = _selectedDate;

    final _parsedAmount = double.tryParse(_amountText);

    final _model = TransactionModel(
      amount: _parsedAmount!,
      date: _date!,
      type: _selectedCategorytype!,
      category: _selectedCategoryModel!,
    );

    TransactionDB.instance.addTransaction(_model);
  }
}
