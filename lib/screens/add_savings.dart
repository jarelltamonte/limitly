import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/savings.dart';
import '../services/savings_service.dart';

class AddSavings extends StatefulWidget {
  final String? selectedCategory;

  const AddSavings({super.key, this.selectedCategory});

  @override
  State<AddSavings> createState() => _AddSavingsState();
}

class _AddSavingsState extends State<AddSavings> {
  final _dateController = TextEditingController();
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  
  final SavingsService _savingsService = SavingsService();
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _dateController.text = _formatDate(_selectedDate);
    _categoryController.text = _selectedCategory ?? '';
    
    // Pre-fill based on category
    if (_selectedCategory != null) {
      switch (_selectedCategory!.toLowerCase()) {
        case 'travel':
          _amountController.text = '231.17';
          _titleController.text = 'Travel Deposit';
          break;
        case 'house':
          _amountController.text = '231.17';
          _titleController.text = 'House Deposit';
          break;
        case 'car':
          _amountController.text = '397.32';
          _titleController.text = 'Car Deposit';
          break;
        case 'wedding':
          _amountController.text = '183.32';
          _titleController.text = 'Wedding Deposit';
          break;
        default:
          _amountController.text = '100.00';
          _titleController.text = 'Savings Deposit';
      }
    } else {
      _amountController.text = '100.00';
      _titleController.text = 'Savings Deposit';
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _categoryController.dispose();
    _amountController.dispose();
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked!; // ✅ Assert non-null
        _dateController.text = _formatDate(picked!);
      });
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  void _saveSavings() async {
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final saving = Savings(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      amount: amount,
      category: _selectedCategory!,
      date: _selectedDate,
      message: _messageController.text.isNotEmpty ? _messageController.text : null,
      targetAmount: _savingsService.getTargetAmount(_selectedCategory!),
    );

    await _savingsService.addSavings(saving);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Savings added successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkGreen = const Color(0xFF006231);
    final lightGreen = const Color(0xFFEAF8EF);
    final fieldGreen = const Color(0xFFDEF8E1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: darkGreen,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    'Add Savings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Positioned(
                  left: 4,
                  bottom: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: Container(
              color: lightGreen,
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Date field
                    const Text(
                      'Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: fieldGreen,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _selectDate,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category dropdown
                    const Text(
                      'Select the category',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: fieldGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        items: _savingsService.categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                            // Update title based on category
                            if (value != null) {
                              switch (value.toLowerCase()) {
                                case 'travel':
                                  _titleController.text = 'Travel Deposit';
                                  break;
                                case 'house':
                                  _titleController.text = 'House Deposit';
                                  break;
                                case 'car':
                                  _titleController.text = 'Car Deposit';
                                  break;
                                case 'wedding':
                                  _titleController.text = 'Wedding Deposit';
                                  break;
                                default:
                                  _titleController.text = 'Savings Deposit';
                              }
                            }
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Amount field
                    const Text(
                      'Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                        prefixText: '\$',
                        filled: true,
                        fillColor: fieldGreen,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title field
                    const Text(
                      'Title',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: fieldGreen,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Message field
                    const Text(
                      'Enter Message',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _messageController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: fieldGreen,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: _saveSavings,
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 