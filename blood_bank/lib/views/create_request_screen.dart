import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/blood_group.dart';
import '../models/blood_request.dart';
import '../providers/app_provider.dart';
import '../services/compatibility_engine.dart';
import '../theme/app_theme.dart';
import '../widgets/blood_group_badge.dart';
import '../widgets/glass_card.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _hospitalNameController = TextEditingController();
  final _hospitalAddressController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _reasonController = TextEditingController();

  BloodGroupType _selectedGroup = BloodGroupType.oNegative;
  UrgencyLevel _selectedUrgency = UrgencyLevel.critical;
  int _unitsNeeded = 2;

  @override
  void dispose() {
    _patientNameController.dispose();
    _hospitalNameController.dispose();
    _hospitalAddressController.dispose();
    _contactPhoneController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    final compatibleGroupTypes = CompatibilityEngine.getCompatibleDonors(_selectedGroup);
    final matchingDonors = provider.filteredDonors
        .where((donor) => compatibleGroupTypes.contains(donor.bloodGroup))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Emergency Blood Call'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.r),
          children: [
            GlassCard(
              borderColor: AppTheme.statusCritical.withValues(alpha: 0.4),
              child: Row(
                children: [
                  Icon(
                    Icons.add_alert_rounded,
                    color: AppTheme.statusCritical,
                    size: 28.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Broadcast Urgent Request',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Will notify compatible registered donors within your city immediately.',
                          style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            Text(
              '1. Select Required Blood Group',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: BloodGroupType.values.map((group) {
                  final isSelected = _selectedGroup == group;
                  return Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: BloodGroupBadge(
                      group: group,
                      size: 50.r,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedGroup = group;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppTheme.medicalTeal.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.people_alt, color: AppTheme.medicalTealAccent, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text(
                    '${matchingDonors.length} compatible registered donors nearby for ${_selectedGroup.label}',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            TextFormField(
              controller: _patientNameController,
              decoration: const InputDecoration(
                labelText: 'Patient Full Name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (val) => val == null || val.trim().isEmpty
                  ? 'Please enter patient name'
                  : null,
            ),
            SizedBox(height: 14.h),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Blood Units Required (Bags):',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  onPressed: _unitsNeeded > 1
                      ? () => setState(() => _unitsNeeded--)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  '$_unitsNeeded Units',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryCrimson,
                  ),
                ),
                IconButton(
                  onPressed: _unitsNeeded < 10
                      ? () => setState(() => _unitsNeeded++)
                      : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            Text(
              'Urgency Priority Level:',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            Row(
              children: UrgencyLevel.values.map((urgency) {
                final isSel = _selectedUrgency == urgency;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                    child: ChoiceChip(
                      label: Text(
                        urgency.label.split(' ')[0],
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: isSel ? Colors.white : null,
                        ),
                      ),
                      selected: isSel,
                      selectedColor: urgency == UrgencyLevel.critical
                          ? AppTheme.statusCritical
                          : (urgency == UrgencyLevel.urgent
                              ? AppTheme.statusUrgent
                              : AppTheme.medicalTeal),
                      onSelected: (val) {
                        if (val) setState(() => _selectedUrgency = urgency);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.h),

            TextFormField(
              controller: _hospitalNameController,
              decoration: const InputDecoration(
                labelText: 'Hospital / Medical Center Name',
                prefixIcon: Icon(Icons.local_hospital),
              ),
              validator: (val) => val == null || val.trim().isEmpty
                  ? 'Please enter hospital name'
                  : null,
            ),
            SizedBox(height: 14.h),

            TextFormField(
              controller: _hospitalAddressController,
              decoration: const InputDecoration(
                labelText: 'Hospital Location / Address',
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (val) => val == null || val.trim().isEmpty
                  ? 'Please enter address'
                  : null,
            ),
            SizedBox(height: 14.h),

            TextFormField(
              controller: _contactPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Emergency Contact Phone Number',
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (val) => val == null || val.trim().isEmpty
                  ? 'Please enter phone number'
                  : null,
            ),
            SizedBox(height: 14.h),

            TextFormField(
              controller: _reasonController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Medical Condition / Notes for Donors',
                prefixIcon: Icon(Icons.notes),
              ),
              validator: (val) => val == null || val.trim().isEmpty
                  ? 'Please describe reason for donation'
                  : null,
            ),
            SizedBox(height: 24.h),

            ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  provider.createEmergencyRequest(
                    patientName: _patientNameController.text.trim(),
                    bloodGroup: _selectedGroup,
                    unitsNeeded: _unitsNeeded,
                    hospitalName: _hospitalNameController.text.trim(),
                    hospitalAddress: _hospitalAddressController.text.trim(),
                    contactPhone: _contactPhoneController.text.trim(),
                    urgency: _selectedUrgency,
                    medicalReason: _reasonController.text.trim(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          '🚨 Emergency Request Published! Local compatible donors have been alerted.'),
                      backgroundColor: AppTheme.primaryCrimson,
                    ),
                  );

                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.send_rounded),
              label: const Text('Publish Emergency Broadcast'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                backgroundColor: AppTheme.primaryCrimson,
              ),
            ),
          ],
        ),
      ),
    );
  }
}