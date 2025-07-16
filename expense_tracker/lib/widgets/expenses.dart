import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expense_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 49.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Groceries',
      amount: 23.45,
      date: DateTime.now(),
      category: Category.food,
    ),
  ];

  void _addExpenseoverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(addexpense: addexpense),
    );
  }

  void addexpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void removeexpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Expense was deleted'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    Widget mainContent = Center(
      child: Text('no expense found please add to display'),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: removeexpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
        actions: [
          IconButton(
            onPressed: () {
              _addExpenseoverlay();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body:
          width < 500
              ? Column(
                children: [
                  Chart(expenses: _registeredExpenses),
                  Expanded(child: mainContent),
                ],
              )
              : Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Chart(expenses: _registeredExpenses),
                  ),
                  Expanded(child: mainContent),
                ],
              ),
    );
  }
}
