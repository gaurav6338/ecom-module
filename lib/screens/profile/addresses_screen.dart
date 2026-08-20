import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/address.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/app_colors.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  void _showAddEditAddressDialog(BuildContext context, {Address? existing}) {
    final labelCtrl = TextEditingController(text: existing?.label ?? 'Home');
    final nameCtrl = TextEditingController(text: existing?.recipientName ?? 'Rishi Kumar');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '+91 98765 43210');
    final streetCtrl = TextEditingController(text: existing?.street ?? '');
    final cityCtrl = TextEditingController(text: existing?.city ?? 'Bengaluru');
    final stateCtrl = TextEditingController(text: existing?.state ?? 'Karnataka');
    final zipCtrl = TextEditingController(text: existing?.zipCode ?? '560001');
    bool isDefault = existing?.isDefault ?? false;

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(existing == null ? 'Add New Address' : 'Edit Address'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        label: 'Label (e.g. Home, Office)',
                        controller: labelCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: 'Recipient Name',
                        controller: nameCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: 'Phone',
                        controller: phoneCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: 'Street Address',
                        controller: streetCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: 'City',
                        controller: cityCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: 'Zip Code',
                        controller: zipCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      CheckboxListTile(
                        title: const Text('Set as Default Address', style: TextStyle(fontSize: 13)),
                        value: isDefault,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setDialogState(() => isDefault = val ?? false);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    final userProvider = Provider.of<UserProvider>(context, listen: false);

                    final newAddr = Address(
                      id: existing?.id ?? 'addr_${DateTime.now().millisecondsSinceEpoch}',
                      label: labelCtrl.text.trim(),
                      recipientName: nameCtrl.text.trim(),
                      phone: phoneCtrl.text.trim(),
                      street: streetCtrl.text.trim(),
                      city: cityCtrl.text.trim(),
                      state: stateCtrl.text.trim(),
                      zipCode: zipCtrl.text.trim(),
                      isDefault: isDefault,
                    );

                    if (existing == null) {
                      userProvider.addAddress(newAddr);
                    } else {
                      userProvider.updateAddress(newAddr);
                    }

                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Shipping Addresses')),
      body: userProvider.addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 70, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No addresses saved yet'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showAddEditAddressDialog(context),
                    child: const Text('Add Address'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userProvider.addresses.length,
              itemBuilder: (context, index) {
                final addr = userProvider.addresses[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  addr.label,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (addr.isDefault) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'DEFAULT',
                                      style: TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18),
                                  onPressed: () => _showAddEditAddressDialog(context, existing: addr),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                                  onPressed: () => userProvider.deleteAddress(addr.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(addr.recipientName, style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text(addr.fullAddress, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        Text('Phone: ${addr.phone}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddEditAddressDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
