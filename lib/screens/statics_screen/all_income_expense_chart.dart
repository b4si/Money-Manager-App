import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../catagory_model/category_model.dart';
import '../../db/category_db/category_db.dart';
import '../../db/transaction_db/transaction_db.dart';
import '../../transaction_model/transaction_model.dart';

class PieCahrt extends StatefulWidget {
  const PieCahrt({super.key});

  @override
  State<PieCahrt> createState() => _PieCahrtState();
}

List<TransactionModel> transactions =
    TransactionDB.instance.transactionListNotifier.value;

List<CategoryModel> expCategories =
    CategoryDB.instance.expenseCategoryListNotifier.value;

List<CategoryModel> incCategories =
    CategoryDB.instance.incomeCategoryListNotifier.value;
double? totalIncomeAmount;
double? totalExpenseAmount;

class _PieCahrtState extends State<PieCahrt> {
  @override
  void initState() {
    totalIncomeAmount = TransactionDB.instance.allMonthlyIncomeAmount();
    totalExpenseAmount = TransactionDB.instance.allMonthlyExpenseAmount();
    super.initState();
  }

  int value1 = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          //FilterDropdown-------->
          child: DropdownButton(
            elevation: 1,
            dropdownColor: Colors.blueGrey[100],
            borderRadius: BorderRadius.circular(18),
            underline: Container(),
            value: value1,
            items: [
              DropdownMenuItem(
                value: 1,
                onTap: () {
                  setState(() {
                    totalIncomeAmount =
                        TransactionDB.instance.allMonthlyIncomeAmount();
                    totalExpenseAmount =
                        TransactionDB.instance.allMonthlyExpenseAmount();
                  });
                },
                child: const Text(
                  'Monthly',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
              ),
              DropdownMenuItem(
                value: 2,
                onTap: () {
                  setState(() {
                    totalIncomeAmount =
                        TransactionDB.instance.alltodayIncomeAmount();
                    totalExpenseAmount =
                        TransactionDB.instance.alltodayExpenseAmount();
                  });
                },
                child: const Text(
                  'Today',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
              ),
              DropdownMenuItem(
                value: 3,
                onTap: () {
                  setState(() {
                    totalIncomeAmount =
                        TransactionDB.instance.allIncomeAmount();
                    totalExpenseAmount =
                        TransactionDB.instance.allExpenseAmount();
                  });
                },
                child: const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
              ),
            ],
            onChanged: (value) {
              value1 = value!;
            },
          ),
        ),
        //All income and expense pie chart-------->
        Expanded(
            child: totalIncomeAmount != 0
                ? PieChart(
                    PieChartData(
                      centerSpaceRadius: 0,
                      sectionsSpace: 2,
                      sections: [
                        PieChartSectionData(
                          title: totalIncomeAmount.toString(),
                          value: totalIncomeAmount,
                          color: Colors.greenAccent,
                          radius: 120,
                        ),
                        PieChartSectionData(
                          title: totalExpenseAmount.toString(),
                          value: totalExpenseAmount,
                          color: Colors.redAccent,
                          radius: 120,
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: Text(
                      'Not enough Data to display',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.greenAccent,
                  radius: 10.0,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Income'),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 10.0,
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Expense'),
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}
