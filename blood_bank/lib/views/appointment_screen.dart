import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class AppointmentScreen extends StatefulWidget {
  final String? preSelectedCenter;
  const AppointmentScreen({super.key, this.preSelectedCenter});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late String _selectedCenter;
  String _selectedType = 'Whole Blood';

  bool _weightCheck = true;
  bool _medicationCheck = true;
  bool _tattooCheck = true;
  bool _healthCheck = true;

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 30);

  @override
  void initState() {
    super.initState();
    _selectedCenter = widget.preSelectedCenter ?? 'Central Red Cross Blood Bank & Lab';
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    final centers = provider.bloodCenters;
    final userAppointments = provider.appointments;

    final isEligible = _weightCheck && _medicationCheck && _tattooCheck && _healthCheck;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Donation Appointment'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Active appointments section
          if (userAppointments.isNotEmpty) ...[
            const Text(
              'Your Scheduled Appointments',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...userAppointments.map((app) {
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 12),
                borderColor: AppTheme.medicalTealAccent.withOpacity(0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.event_available, color: AppTheme.medicalTealAccent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            app.centerName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.statusOptimal.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'CONFIRMED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.statusOptimal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Booking Ref: ${app.bookingConfirmationCode}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryCrimson,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${app.appointmentDateTime.day}/${app.appointmentDateTime.month}/${app.appointmentDateTime.year} at ${app.appointmentDateTime.hour.toString().padLeft(2, '0')}:${app.appointmentDateTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              );
            }).toList(),
            const Divider(height: 30),
          ],

          const Text(
            'Book a New Appointment Slot',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Center Picker
          DropdownButtonFormField<String>(
            value: centers.any((c) => c.name == _selectedCenter)
                ? _selectedCenter
                : centers.first.name,
            decoration: const InputDecoration(
              labelText: 'Select Donation Center',
              prefixIcon: Icon(Icons.local_hospital),
            ),
            items: centers.map((c) {
              return DropdownMenuItem(
                value: c.name,
                child: Text(
                  c.name,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCenter = val);
            },
          ),
          const SizedBox(height: 14),

          // Donation Type
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: const InputDecoration(
              labelText: 'Donation Component Type',
              prefixIcon: Icon(Icons.bloodtype),
            ),
            items: const [
              DropdownMenuItem(value: 'Whole Blood', child: Text('Whole Blood (450ml)')),
              DropdownMenuItem(value: 'Platelets', child: Text('Platelets (Apheresis)')),
              DropdownMenuItem(value: 'Plasma', child: Text('Plasma (Plasmapheresis)')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _selectedType = val);
            },
          ),
          const SizedBox(height: 20),

          // Date & Time Picker Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 60)),
                    );
                    if (picked != null) setState(() => _selectedDate = picked);
                  },
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (picked != null) setState(() => _selectedTime = picked);
                  },
                  icon: const Icon(Icons.access_time, size: 16),
                  label: Text(_selectedTime.format(context)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Pre-Screening Quiz Checklist
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pre-Donation Medical Checklist',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Please verify health criteria before booking:',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  title: const Text('Body weight is above 50 kg (110 lbs)', style: TextStyle(fontSize: 13)),
                  value: _weightCheck,
                  onChanged: (v) => setState(() => _weightCheck = v ?? false),
                  activeColor: AppTheme.primaryCrimson,
                  dense: true,
                ),
                CheckboxListTile(
                  title: const Text('No antibiotics/major medications in last 7 days', style: TextStyle(fontSize: 13)),
                  value: _medicationCheck,
                  onChanged: (v) => setState(() => _medicationCheck = v ?? false),
                  activeColor: AppTheme.primaryCrimson,
                  dense: true,
                ),
                CheckboxListTile(
                  title: const Text('No tattoo or body piercing in last 6 months', style: TextStyle(fontSize: 13)),
                  value: _tattooCheck,
                  onChanged: (v) => setState(() => _tattooCheck = v ?? false),
                  activeColor: AppTheme.primaryCrimson,
                  dense: true,
                ),
                CheckboxListTile(
                  title: const Text('Feeling healthy and well today with good sleep', style: TextStyle(fontSize: 13)),
                  value: _healthCheck,
                  onChanged: (v) => setState(() => _healthCheck = v ?? false),
                  activeColor: AppTheme.primaryCrimson,
                  dense: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: isEligible
                ? () {
                    final appointmentDateTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    );

                    provider.bookAppointment(
                      centerName: _selectedCenter,
                      appointmentDateTime: appointmentDateTime,
                      bloodGroup: provider.currentUser.bloodGroup,
                      donationType: _selectedType,
                      quiz: HealthScreeningQuiz(
                        weightAbove50kg: _weightCheck,
                        noRecentMedication: _medicationCheck,
                        noTattooLast6Months: _tattooCheck,
                        feelsHealthyToday: _healthCheck,
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            '✅ Appointment successfully reserved! Confirmation ticket generated.'),
                        backgroundColor: AppTheme.statusOptimal,
                      ),
                    );
                  }
                : null,
            icon: const Icon(Icons.bookmark_added),
            label: const Text('Confirm Appointment Booking'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppTheme.medicalTeal,
            ),
          ),
        ],
      ),
    );
  }
}
