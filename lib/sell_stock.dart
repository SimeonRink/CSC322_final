import 'dart:io';
import 'package:egr423_starter_project/models/stocks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class sellStock extends StatefulWidget {
  const sellStock(
      {super.key,
      required this.ticker,
      required this.currentPrice,
      required this.onSellStock,
      required this.totalShares});

  final void Function(Stocks buy) onSellStock;
  final String ticker;
  final String currentPrice;
  final double totalShares;

  @override
  State<sellStock> createState() {
    return _sellStockState();
  }
}

class _sellStockState extends State<sellStock> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController(text: '1');
  DateTime _selectedDate = DateTime.now();
  Widget content = const Text('--');
  String shares = '1';

  void _showDialog() {
    //find out what platform you are on to have alert dialogs display in the same style
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text('Invalid input'),
                content: const Text(
                    'You do not have enough shares to sell that amount.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okay'),
                  ),
                ],
              ));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content:
              const Text('You do not have enough shares to sell that amount.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void _submitStockData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null ||
        enteredAmount <= 0 ||
        enteredAmount > widget.totalShares;
    if (amountIsInvalid) {
      _showDialog();
      return;
    }

    widget.onSellStock(
      Stocks(
        ticker: widget.ticker,
        shares: enteredAmount,
        date: _selectedDate,
        currentPrice: double.parse(widget.currentPrice),
        totalShares: double.parse(widget.totalShares.toString()),
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //getting the amount of space the keyboard takes up
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    //get constraints for screen
    return LayoutBuilder(
      builder: (ctx, Constraints) {
        final width = Constraints.maxWidth;

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              //implementing custom padding for the keyboard
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.ticker,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.currentPrice,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 24),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            onChanged: (value) {
                              setState(() {
                                shares = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              label: Text('Shares'),
                            ),
                          ),
                        ),
                      ],
                    )
                  else if (width >= 600)
                    Row(
                      children: [
                        const SizedBox(width: 24),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(format.format(_selectedDate)),
                              Icon(
                                Icons.calendar_month,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            onChanged: (value) {
                              setState(() {
                                shares = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              label: Text('Shares'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(format.format(_selectedDate)),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.calendar_month,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Credit:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      if (shares != '')
                        Expanded(
                          child: Text(
                            (double.parse(shares) *
                                    double.parse(widget.currentPrice))
                                .toStringAsFixed(2),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Shares Available:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.totalShares.toStringAsFixed(2),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (width >= 600)
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: _submitStockData,
                          child: const Text('Sell'),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: _submitStockData,
                          child: const Text('Sell'),
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
