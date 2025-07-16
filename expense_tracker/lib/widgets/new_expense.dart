import 'dart:developer';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addexpense});

  final void Function(Expense expense) addexpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selecteddate;

  Category _selectedcategory = Category.leisure;

  void presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selecteddate = pickedDate;
    });
    log(pickedDate.toString());
  }

  void _submitExpense() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selecteddate == null) {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('Invalid Input'),
              content: const Text(
                'Please make sure a valid title, amount, date and category was entered.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return;
    } else {
      widget.addexpense(
        Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selecteddate!,
          category: _selectedcategory,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardheight = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardheight + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            decoration: InputDecoration(labelText: 'Title'),
                            maxLength: 50,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              prefixText: '\$',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                      maxLength: 50,
                    ),
                  if (width >= 600)
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selecteddate == null
                                    ? 'No Date Selected'
                                    : formatter.format(_selecteddate!),
                              ),
                              SizedBox(width: 2),
                              IconButton(
                                onPressed: () {
                                  presentDatePicker();
                                },
                                icon: Icon(
                                  Icons.calendar_month_outlined,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButton(
                            value: _selectedcategory,
                            items:
                                Category.values
                                    .map(
                                      (category) => DropdownMenuItem(
                                        value: category,
                                        child: Text(
                                          category.name.toUpperCase(),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              } else {
                                setState(() {
                                  _selectedcategory = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        prefixText: '\$',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  SizedBox(height: 8),
                  if (width >= 600)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Logic to save the expense
                            _submitExpense();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black38,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Add Expense'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Cancel'),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selecteddate == null
                                    ? 'No Date Selected'
                                    : formatter.format(_selecteddate!),
                              ),
                              SizedBox(width: 2),
                              IconButton(
                                onPressed: () {
                                  presentDatePicker();
                                },
                                icon: Icon(
                                  Icons.calendar_month_outlined,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButton(
                            value: _selectedcategory,
                            items:
                                Category.values
                                    .map(
                                      (category) => DropdownMenuItem(
                                        value: category,
                                        child: Text(
                                          category.name.toUpperCase(),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              } else {
                                setState(() {
                                  _selectedcategory = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  if (width < 600)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Logic to save the expense
                            _submitExpense();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black38,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Add Expense'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
