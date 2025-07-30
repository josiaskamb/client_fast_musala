import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> artisan;

  const BookingScreen({super.key, required this.artisan});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _paymentMethod = 'Mobile Money';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réserver un service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildArtisanHeader(),
            const SizedBox(height: 24),
            _buildServiceDetails(),
            const SizedBox(height: 24),
            _buildDateTimePicker(),
            const SizedBox(height: 24),
            _buildPaymentMethod(),
            const SizedBox(height: 32),
            _buildBookButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildArtisanHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(widget.artisan['image']),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.artisan['name'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.artisan['service'],
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  widget.artisan['commune'],
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Détails du service',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Décrivez votre besoin',
            border: OutlineInputBorder(),
            hintText: 'Ex: Réparation fuite sous évier...',
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildDateTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date et heure',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _selectDate,
                child: Text(
                  _selectedDate == null
                      ? 'Choisir une date'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: _selectedDate == null ? null : _selectTime,
                child: Text(
                  _selectedTime == null
                      ? 'Choisir une heure'
                      : '${_selectedTime!.hour}h${_selectedTime!.minute.toString().padLeft(2, '0')}',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Méthode de paiement',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _paymentMethod,
          items: ['Mobile Money', 'Espèces', 'Carte bancaire'].map((method) {
            return DropdownMenuItem(
              value: method,
              child: Text(method),
            );
          }).toList(),
          onChanged: (value) => setState(() => _paymentMethod = value!),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
        style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        padding: const EdgeInsets.symmetric(vertical: 16)),
    onPressed: _selectedDate == null || _selectedTime == null
    ? null
        : _confirmBooking,
    child: const Text(
    'Confirmer la réservation',
    style: TextStyle(fontSize: 16),
    ),
    ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _confirmBooking() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Artisan: ${widget.artisan['name']}'),
              Text('Service: ${widget.artisan['service']}'),
              Text('Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
              Text('Heure: ${_selectedTime!.hour}h${_selectedTime!.minute.toString().padLeft(2, '0')}'),
              const SizedBox(height: 16),
              const Text('Un SMS de confirmation vous sera envoyé'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Réservation confirmée !'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }
}