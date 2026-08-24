import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        padding: EdgeInsets.all(16.r),
        children: [
          // Active appointments section
          if (userAppointments.isNotEmpty) ...[
            Text(
              'Your Scheduled Appointments',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            ...userAppointments.map((app) {
              return GlassCard(
                margin: EdgeInsets.only(bottom: 12.h),
                borderColor: AppTheme.medicalTealAccent.withValues(alpha: 0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.event_available, color: AppTheme.medicalTealAccent),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            app.centerName,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: AppTheme.statusOptimal.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            'CONFIRMED',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.statusOptimal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Booking Ref: ${app.bookingConfirmationCode}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryCrimson,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Date: ${app.appointmentDateTime.day}/${app.appointmentDateTime.month}/${app.appointmentDateTime.year} at ${app.appointmentDateTime.hour.toString().padLeft(2, '0')}:${app.appointmentDateTime.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ],
                ),
              );
            }),
            Divider(height: 30.h),
          ],

          Text(
            'Book a New Appointment Slot',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),

          // Center Picker
          DropdownButtonFormField<String>(
            initialValue: centers.any((c) => c.name == _selectedCenter)
                ? _selectedCenter
                : centers.first.name,
            isExpanded: true,
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
          SizedBox(height: 14.h),

          // Donation Type
          DropdownButtonFormField<String>(
            initialValue: _selectedType,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Donation Component Type',
              prefixIcon: Icon(Icons.bloodtype),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Whole Blood',
                child: Text('Whole Blood (450ml)', overflow: TextOverflow.ellipsis),
              ),
              DropdownMenuItem(
                value: 'Platelets',
                child: Text('Platelets (Apheresis)', overflow: TextOverflow.ellipsis),
              ),
              DropdownMenuItem(
                value: 'Plasma',
                child: Text('Plasma (Plasmapheresis)', overflow: TextOverflow.ellipsis),
              ),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _selectedType = val);
            },
          ),
          SizedBox(height: 20.h),

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
                  icon: Icon(Icons.calendar_today, size: 16.sp),
                  label: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (picked != null) setState(() => _selectedTime = picked);
                  },
                  icon: Icon(Icons.access_time, size: 16.sp),
                  label: Text(_selectedTime.format(context)),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Pre-Screening Quiz Checklist
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pre-Donation Medical Checklist',
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Please verify health criteria before booking:',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                ),
                SizedBox(height: 10.h),
                CheckboxListTile(
                  title: Text('Body weight is above 50 kg (110 lbs)', style: TextStyle(fontSize: 13.sp)),
                  value: _weightCheck,
                  onChanged: (v) => setState(() => _weightCheck = v ?? false),
                  activeColor: AppTheme.primaryCrimson,
                  dense: true,
                ),
                CheckboxListTile(
                  title: Text('No antibiotics/major medications in last 7 days', style: TextStyle(fontSize: 13.sp)),
                  value: _medicationCheck,
                  onChanged: (v) => setState(() => _medicationCheck = v ?? false),
                  activeColor: AppTheme.primaryCrimson,
                  dense: true,
                ),
                CheckboxListTile(
                  title: Text('No tattoo or body piercing in last 6 months', style: TextStyle(fontSize: 13.sp)),
                  value: _tattooCheck,
                  onChanged: (v) => setState(() => _tattooCheck = v ?? false),
                  activeColor: AppTheme.primaryCrimson,
                  dense: true,
                ),
                CheckboxListTile(
                  title: Text('Feeling healthy and well today with good sleep', style: TextStyle(fontSize: 13.sp)),
                  value: _healthCheck,
                  onChanged: (v) => setState(() => _healthCheck = v ?? false),
                  activeColor: AppTheme.primaryCrimson,
                  dense: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

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
              padding: EdgeInsets.symmetric(vertical: 16.h),
              backgroundColor: AppTheme.medicalTeal,
            ),
          ),
        ],
      ),
    );
  }
}
