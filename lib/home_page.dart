import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _totalBillAmount = 0.0;
  int _numberOfPeople = 1;
  double _eachPersonAmount = 0.0;
  bool _splitUnEqually = false;
  double _unequalAmount = 0.0;
  final maxLength = 6;
  final formatter = NumberFormat.decimalPatternDigits(decimalDigits: 2);

  void _calculateSplitAmount() {
    setState(() {
      if (_numberOfPeople > 0) {
        if (_splitUnEqually && _unequalAmount > 0) {
          // Calculate total contribution excluding the unequal amount
          double totalContributed = _totalBillAmount - _unequalAmount;

          // Divide the remaining amount among the remaining members
          int remainingMembers = _numberOfPeople - 1;
          if (remainingMembers > 0) {
            _eachPersonAmount = totalContributed / remainingMembers;
          } else {
            _eachPersonAmount = 0.0;
          }
        } else {
          // If no unequal amount is contributed, divide the total bill equally
          _eachPersonAmount = _totalBillAmount / _numberOfPeople;
        }
        if (_eachPersonAmount < 0) {
          _eachPersonAmount = 0.0;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Splitter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              maxLength: maxLength,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Bill Amount',
                counterText: '',
              ),
              onChanged: (value) {
                setState(() {
                  _totalBillAmount = double.tryParse(value) ?? 0.0;
                  _calculateSplitAmount();
                });
              },
            ),
            const SizedBox(height: 20.0),
            TextField(
              maxLength: maxLength ~/ 2,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of People',
                counterText: '',
              ),
              onChanged: (value) {
                setState(() {
                  _numberOfPeople = int.tryParse(value) ?? 1;
                  _calculateSplitAmount();
                });
              },
            ),
            const SizedBox(height: 20.0),
            CheckboxListTile(
              title: const Text('Split Un-Equally'),
              value: _splitUnEqually,
              onChanged: (newValue) {
                setState(() {
                  _splitUnEqually = newValue!;
                  _calculateSplitAmount();
                });
              },
            ),
            if (_splitUnEqually)
              TextField(
                maxLength: maxLength,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Unequal Amount',
                  counterText: '',
                ),
                onChanged: (value) {
                  setState(() {
                    _unequalAmount = double.tryParse(value) ?? 0.0;
                    _calculateSplitAmount();
                  });
                },
              ),
            const SizedBox(height: 20.0),
            Text(
              'Each Person Pays: \$${formatter.format(_eachPersonAmount)}',
              style: const TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
