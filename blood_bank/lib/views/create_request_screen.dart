import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.all(16),
          children: [
            GlassCard(
              borderColor: AppTheme.statusCritical.withValues(alpha: 0.4),
              child: Row(
                children: [
                  const Icon(
                    Icons.add_alert_rounded,
                    color: AppTheme.statusCritical,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Broadcast Urgent Request',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Will notify compatible registered donors within your city immediately.',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              '1. Select Required Blood Group',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: BloodGroupType.values.map((group) {
                  final isSelected = _selectedGroup == group;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: BloodGroupBadge(
                      group: group,
                      size: 50,
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
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.medicalTeal.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.people_alt, color: AppTheme.medicalTealAccent, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${matchingDonors.length} compatible registered donors nearby for ${_selectedGroup.label}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

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
            const SizedBox(height: 14),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Blood Units Required (Bags):',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                  style: const TextStyle(
                    fontSize: 16,
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
            const SizedBox(height: 14),

            const Text(
              'Urgency Priority Level:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: UrgencyLevel.values.map((urgency) {
                final isSel = _selectedUrgency == urgency;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(
                        urgency.label.split(' ')[0],
                        style: TextStyle(
                          fontSize: 12,
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
            const SizedBox(height: 16),

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
            const SizedBox(height: 14),

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
            const SizedBox(height: 14),

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
            const SizedBox(height: 14),

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
            const SizedBox(height: 24),

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
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.primaryCrimson,
              ),
            ),
          ],
        ),
      ),
    );
  }
}