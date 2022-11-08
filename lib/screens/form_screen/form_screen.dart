// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/db/category_db/category_db.dart';
import 'package:money_manager/db/transaction_db/transaction_db.dart';
import 'package:money_manager/transaction_model/transaction_model.dart';
import '../../catagory_model/category_model.dart';
import 'radio_button.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

ValueNotifier<List<TransactionModel>> transactions =
    TransactionDB.instance.transactionListNotifier;

List<CategoryModel> incCategories =
    CategoryDB.instance.incomeCategoryListNotifier.value;

List<CategoryModel> expCategories =
    CategoryDB.instance.expenseCategoryListNotifier.value;

final _formKey = GlobalKey<FormState>();

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
  TextEditingController notesController = TextEditingController();
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 400,
              child: Column(
                //Income Expense radio button for adding Transactions------>

                mainAxisAlignment: MainAxisAlignment.start,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Dropdown for selecting the category----->

                      DropdownButton<String>(
                        elevation: 1,
                        underline: Container(),
                        dropdownColor: Colors.blueGrey[100],
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

                          //Modal sheet for adding category------>

                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.white,
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (ctx) {
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
                                        child: Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Enter a Category name';
                                              } else {
                                                for (var i = 0;
                                                    i < incCategories.length;
                                                    i++) {
                                                  if (value
                                                          .toLowerCase()
                                                          .trim() ==
                                                      incCategories[i]
                                                          .name
                                                          .toLowerCase()
                                                          .trim()
                                                          .toString()) {
                                                    return 'Already exist';
                                                  }
                                                }
                                                for (var i = 0;
                                                    i < expCategories.length;
                                                    i++) {
                                                  if (value
                                                          .toLowerCase()
                                                          .trim() ==
                                                      expCategories[i]
                                                          .name
                                                          .toLowerCase()
                                                          .trim()) {
                                                    return 'Already exist';
                                                  }
                                                }
                                              }
                                              return null;
                                            },
                                            controller: nameEditingController,
                                            decoration: const InputDecoration(
                                              labelText: 'category name',
                                            ),
                                            maxLength: 10,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        //Radio button for adding category---->

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

                                      //For saving categories------->

                                      ElevatedButton(
                                        onPressed: () {
                                          final name =
                                              nameEditingController.text;
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final type =
                                                selectedCategoryNotifier.value;
                                            final category = CategoryModel(
                                              id: DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString(),
                                              name: name,
                                              type: type,
                                            );
                                            CategoryDB()
                                                .insertCategory(category);
                                            Navigator.of(context).pop();
                                            setState(() {
                                              CategoryDB.instance.refreshUI();
                                            });
                                            nameEditingController.clear();
                                          }
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

                  //Amount textfield------->

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 12, left: 12),
                    child: TextFormField(
                      controller: amountController,
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(35)),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      maxLength: 8,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp('[0-9.]'),
                        ),
                      ],
                    ),
                  ),

                  //Notes textfield------->

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 12, left: 12),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: notesController,
                      decoration: InputDecoration(
                        hintText: 'Notes',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2, color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                      maxLength: 15,
                    ),
                  ),

                  //Datepicker------->

                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            final selectedDateTemp = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 60)),
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

                  //Transaction submit button------>

                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          onPressed: () {
                            checkAmount();
                            setState(() {
                              TransactionDB.instance.refresh();
                            });
                          },
                          child: const Text('Submit')),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Function for checking and adding Transactions------>

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.green,
          content: Text('Submitted Successfully'),
        ),
      );
    }
  }

  //Function for adding transaction----->

  Future<void> addtransaction() async {
    final _amountText = amountController.text;
    final _date = _selectedDate;
    final _notes = notesController.text;

    final _parsedAmount = double.tryParse(_amountText);

    final _model = TransactionModel(
      amount: _parsedAmount!,
      date: _date!,
      type: _selectedCategorytype!,
      category: _selectedCategoryModel!,
      notes: _notes,
    );

    TransactionDB.instance.addTransaction(_model);
  }
}
