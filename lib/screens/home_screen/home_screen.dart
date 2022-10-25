import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_manager/catagory_model/category_model.dart';
import 'package:money_manager/db/category_db/category_db.dart';
import 'package:money_manager/db/transaction_db/transaction_db.dart';
import 'package:money_manager/screens/category_screen.dart';
import 'package:money_manager/screens/settings_screen.dart';
import 'package:money_manager/screens/statics_screen/statics_screen.dart';
import 'package:money_manager/screens/transaction_screen/transaction_screen.dart';
import '../../transaction_model/transaction_model.dart';
import '../form_screen/form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  PageController pageController = PageController();

  List<TransactionModel> transactions =
      TransactionDB.instance.transactionListNotifier.value;

  @override
  void initState() {
    TransactionDB.instance.refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CategoryDB.instance.refreshUI();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Manager'),
        centerTitle: true,
        backgroundColor: const Color(0xFF15485D),
      ),
      body: PageView(
        controller: pageController,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF15485D)),
                    height: 100,
                    width: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Income',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            Text(
                              TransactionDB.instance
                                  .allIncomeAmount()
                                  .toString(),
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Balance',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            Text(
                              TransactionDB.instance.totalAmount().toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Expense',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            Text(
                              TransactionDB.instance
                                  .allExpenseAmount()
                                  .toString(),
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 3),
                child: ListTile(
                  title: const Text('Recent transactions'),
                  trailing: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) {
                              return const TransactionScreen();
                            }),
                          ),
                        );
                      },
                      child: const Text('View all')),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    ValueListenableBuilder(
                      valueListenable:
                          TransactionDB.instance.transactionListNotifier,
                      builder: (BuildContext ctx,
                          List<TransactionModel> newList, Widget? _) {
                        return newList.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'No Transactions',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : ListView.builder(
                                itemCount:
                                    (newList.length >= 6 ? 6 : newList.length),
                                itemBuilder: ((ctx, index) {
                                  final transactionList = newList[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, bottom: 5),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ListTile(
                                          title: Text(
                                            transactionList.category.name,
                                          ),
                                          subtitle: Text(
                                            parseDate(
                                              transactionList.date,
                                            ),
                                          ),
                                          trailing: transactionList.type ==
                                                  CategoryType.income
                                              ? Text(
                                                  (('₹${transactionList.amount.toString()}')),
                                                  style: const TextStyle(
                                                      color: Colors.green),
                                                )
                                              : Text(
                                                  (('₹${transactionList.amount.toString()}')),
                                                  style: const TextStyle(
                                                      color: Colors.red),
                                                )),
                                    ),
                                  );
                                }),
                              );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                onPressed: (() {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: ((context) {
                                    return const FormScreen();
                                  })));
                                }),
                                backgroundColor: const Color(0xFF15485D),
                                child: const Icon(FontAwesomeIcons.plus),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const CategoryScreen(),
          const StaticsScreen(),
          const SettingsScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        unselectedItemColor: Colors.white38,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              backgroundColor: Color(0xFF15485D),
              icon: Icon(
                Icons.home,
              ),
              label: '______'),
          BottomNavigationBarItem(
              backgroundColor: Color(0xFF15485D),
              icon: Icon(
                Icons.category,
              ),
              label: '______'),
          BottomNavigationBarItem(
              backgroundColor: Color(0xFF15485D),
              icon: Icon(
                Icons.bar_chart,
              ),
              label: '______'),
          BottomNavigationBarItem(
              backgroundColor: Color(0xFF15485D),
              icon: Icon(
                Icons.settings,
              ),
              label: '______'),
        ],
        onTap: ((value) {
          setState(() {
            selectedIndex = value;
          });
          pageController.animateToPage(
            value,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }),
      ),
    );
  }

  String parseDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
