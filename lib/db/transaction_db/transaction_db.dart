// ignore_for_file: no_leading_underscores_for_local_identifiers, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/transaction_model/transaction_model.dart';

import '../../catagory_model/category_model.dart';
import '../../screens/form_screen/form_screen.dart';

const transactionDbName = 'transaction-db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(String transactionID);
  Future<void> deleteAllTransactions();
  // Future<void> editTarsaction(index,String transactionID);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();
  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> incomeTransactionNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> expenseTransactionNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> todayTransactionNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> monthlyTransactionNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> yearlyTransactionNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> allMonthlyincomeTransactions =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> allMonthlyExpenseTransactions =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(transactionDbName);
    _db.put(obj.id, obj);
    refresh();
  }

  Future<void> refresh() async {
    final _list = await getAllTransactions();

    transactionListNotifier.value.clear();
    incomeTransactionNotifier.value.clear();
    expenseTransactionNotifier.value.clear();

    _list.sort((first, second) => second.date.compareTo(first.date));

    transactionListNotifier.value.addAll(_list);

    transactionListNotifier.notifyListeners();

    //For Getting all income and expense transactions in separate list----->

    await Future.forEach(
      _list,
      (TransactionModel transaction) {
        if (transaction.type == CategoryType.income) {
          _list.sort((first, second) => second.date.compareTo(first.date));
          incomeTransactionNotifier.value.add(transaction);
        } else {
          _list.sort((first, second) => second.date.compareTo(first.date));
          expenseTransactionNotifier.value.add(transaction);
        }
      },
    );
    incomeTransactionNotifier.notifyListeners();
    expenseTransactionNotifier.notifyListeners();

    //For getting today's transaction List------->

    todayTransactionNotifier.value.clear();
    await Future.forEach(
      _list,
      (TransactionModel transaction) {
        if (transaction.date ==
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day)) {
          todayTransactionNotifier.value.add(transaction);
        } else {
          return;
        }
      },
    );

    todayTransactionNotifier.notifyListeners();

    //For getting monthly Transaction List--------->

    monthlyTransactionNotifier.value.clear();
    await Future.forEach(
      _list,
      (TransactionModel transaction) {
        if (transaction.date.month == DateTime.now().month) {
          _list.sort((first, second) => second.date.compareTo(first.date));
          monthlyTransactionNotifier.value.add(transaction);
        }
      },
    );
    monthlyTransactionNotifier.notifyListeners();

    //For getting yearly transaction List------->

    yearlyTransactionNotifier.value.clear();
    await Future.forEach(
      _list,
      (TransactionModel transaction) {
        if (transaction.date.year == DateTime.now().year) {
          yearlyTransactionNotifier.value.add(transaction);
        }
      },
    );
    yearlyTransactionNotifier.notifyListeners();

    //for getting all monthly incomes-------->
    allMonthlyincomeTransactions.value.clear();
    await Future.forEach(
      _list,
      (TransactionModel transaction) {
        if (transaction.date.month == DateTime.now().month &&
            transaction.type == CategoryType.income) {
          allMonthlyincomeTransactions.value.add(transaction);
        }
      },
    );
    allMonthlyincomeTransactions.notifyListeners();

    //for getting all monthly expenses------->
    allMonthlyExpenseTransactions.value.clear();
    await Future.forEach(
      _list,
      (TransactionModel transaction) {
        if (transaction.date.month == DateTime.now().month &&
            transaction.type == CategoryType.expense) {
          allMonthlyExpenseTransactions.value.add(transaction);
        }
      },
    );
    allMonthlyExpenseTransactions.notifyListeners();
  }

  //Function for Getting Total balance------->

  double totalAmount() {
    double totalAmount = 0;
    for (var i = 0; i < transactionListNotifier.value.length; i++) {
      totalAmount = (allIncomeAmount() - allExpenseAmount());
      refresh();
    }

    return totalAmount;
  }

  //Function for getting sum of today's income amount------>

  double alltodayIncomeAmount() {
    double allTodayIncomeamount = 0;
    for (var i = 0; i < incomeTransactionNotifier.value.length; i++) {
      if (incomeTransactionNotifier.value[i].date ==
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
        allTodayIncomeamount =
            allTodayIncomeamount + incomeTransactionNotifier.value[i].amount;
      }
    }
    return allTodayIncomeamount;
  }

  //Function for getting sum of today's expense amount------>

  double alltodayExpenseAmount() {
    double allTodayExpenseamount = 0;
    for (var i = 0; i < expenseTransactionNotifier.value.length; i++) {
      if (expenseTransactionNotifier.value[i].date.month ==
          DateTime.now().month) {
        allTodayExpenseamount =
            allTodayExpenseamount + expenseTransactionNotifier.value[i].amount;
      }
    }
    return allTodayExpenseamount;
  }

  //Function for getting the sum of monthly income------->

  double allMonthlyIncomeAmount() {
    double allMonthlyIncomeAmount = 0;
    for (var i = 0; i < incomeTransactionNotifier.value.length; i++) {
      if (incomeTransactionNotifier.value[i].date.month ==
          DateTime.now().month) {
        allMonthlyIncomeAmount =
            allMonthlyIncomeAmount + incomeTransactionNotifier.value[i].amount;
      }
    }
    return allMonthlyIncomeAmount;
  }

  //Function for getting the sum of monthly expense------->

  double allMonthlyExpenseAmount() {
    double allMonthlyExpenseAmount = 0;
    for (var i = 0; i < expenseTransactionNotifier.value.length; i++) {
      if (expenseTransactionNotifier.value[i].date.month ==
          DateTime.now().month) {
        allMonthlyExpenseAmount = allMonthlyExpenseAmount +
            expenseTransactionNotifier.value[i].amount;
      }
    }
    return allMonthlyExpenseAmount;
  }

  //Function for getting monthly balance----->

  double monthlyBalance() {
    double monthlyBalance = 0;
    for (var i = 0; i < transactionListNotifier.value.length; i++) {
      monthlyBalance = (allMonthlyIncomeAmount() - allMonthlyExpenseAmount());
      refresh();
    }

    return monthlyBalance;
  }

  //Function for getting total income amount----->

  double allIncomeAmount() {
    double totalIncomeAmount = 0;
    for (var i = 0; i < transactionListNotifier.value.length; i++) {
      if (transactionListNotifier.value[i].category.type ==
          CategoryType.income) {
        totalIncomeAmount =
            totalIncomeAmount + transactionListNotifier.value[i].amount;
        refresh();
      }
    }
    return totalIncomeAmount;
  }

  //Function for gettinf total expense amount------>

  double allExpenseAmount() {
    double totalExpenseAmount = 0;
    for (var i = 0; i < transactionListNotifier.value.length; i++) {
      if (transactionListNotifier.value[i].category.type ==
          CategoryType.expense) {
        totalExpenseAmount =
            totalExpenseAmount + transactionListNotifier.value[i].amount;
        refresh();
      }
    }
    return totalExpenseAmount;
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(transactionDbName);
    return _db.values.toList();
  }

  @override
  Future<void> deleteTransaction(String transactionID) async {
    final _db = await Hive.openBox<TransactionModel>(transactionDbName);
    await _db.delete(transactionID);
    refresh();
  }

  @override
  Future<void> deleteAllTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(transactionDbName);
    _db.clear();
    refresh();
  }
}
