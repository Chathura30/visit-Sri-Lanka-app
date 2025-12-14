// lib/screens/trip/add_edit_trip_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/trip_provider.dart';
import '../../models/trip_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../widgets/custom_button.dart';

class AddEditTripScreen extends StatefulWidget {
  const AddEditTripScreen({super.key});

  @override
  State<AddEditTripScreen> createState() => _AddEditTripScreenState();
}

class _AddEditTripScreenState extends State<AddEditTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _destinationController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final List<String> _selectedCities = [];
  TripModel? _existingTrip;
  bool _isLoading = false;

  final List<String> _sriLankanCities = [
    'Colombo',
    'Kandy',
    'Galle',
    'Jaffna',
    'Negombo',
    'Ella',
    'Nuwara Eliya',
    'Anuradhapura',
    'Polonnaruwa',
    'Trincomalee',
    'Bentota',
    'Arugam Bay',
    'Mirissa',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is TripModel) {
        _existingTrip = args;
        _loadExistingTrip();
      }
    });
  }

  void _loadExistingTrip() {
    if (_existingTrip != null) {
      _nameController.text = _existingTrip!.name;
      _destinationController.text = _existingTrip!.destination;
      _startDate = _existingTrip!.startDate;
      _endDate = _existingTrip!.endDate;
      _selectedCities.addAll(_existingTrip!.cities);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_existingTrip == null ? 'Create Trip' : 'Edit Trip'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Trip Name',
                  prefixIcon: Icon(Icons.title, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    Validators.validateRequired(value, 'Trip name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _destinationController,
                decoration: InputDecoration(
                  labelText: 'Main Destination',
                  prefixIcon: Icon(Icons.place, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    Validators.validateRequired(value, 'Destination'),
              ),
              const SizedBox(height: 16),
              _buildDateSelector(
                'Start Date',
                _startDate,
                (date) => setState(() => _startDate = date),
              ),
              const SizedBox(height: 16),
              _buildDateSelector(
                'End Date',
                _endDate,
                (date) => setState(() => _endDate = date),
              ),
              const SizedBox(height: 24),
              const Text(
                'Select Cities to Visit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _sriLankanCities.map((city) {
                  final isSelected = _selectedCities.contains(city);
                  return FilterChip(
                    label: Text(city),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCities.add(city);
                        } else {
                          _selectedCities.remove(city);
                        }
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.3),
                    checkmarkColor: AppColors.primary,
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: _existingTrip == null ? 'Create Trip' : 'Update Trip',
                onPressed: _saveTrip,
                isLoading: _isLoading,
                icon: Icons.save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(
    String label,
    DateTime? selectedDate,
    Function(DateTime) onDateSelected,
  ) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          selectedDate != null
              ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
              : 'Select date',
          style: TextStyle(
            fontSize: 16,
            color: selectedDate != null ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Future<void> _saveTrip() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end dates')),
      );
      return;
    }
    if (_selectedCities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one city')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final duration = _endDate!.difference(_startDate!).inDays + 1;
    final trip = TripModel(
      id: _existingTrip?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      destination: _destinationController.text.trim(),
      startDate: _startDate!,
      endDate: _endDate!,
      duration: duration,
      cities: _selectedCities,
      createdAt: _existingTrip?.createdAt ?? DateTime.now(),
    );

    final tripProvider = Provider.of<TripProvider>(context, listen: false);

    if (_existingTrip == null) {
      await tripProvider.addTrip(trip);
    } else {
      await tripProvider.updateTrip(trip);
    }

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _existingTrip == null
                ? 'Trip created successfully!'
                : 'Trip updated successfully!',
          ),
        ),
      );
    }
  }
}
