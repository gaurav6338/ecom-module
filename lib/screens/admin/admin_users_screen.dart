import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: userProvider.users.length,
        itemBuilder: (context, index) {
          final user = userProvider.users[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(user.avatarUrl),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(user.email, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text(
                              'Joined: ${Formatters.formatDate(user.registrationDate)}',
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      // Role Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: user.role == 'admin' ? AppColors.primary.withOpacity(0.15) : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          user.role.toUpperCase(),
                          style: TextStyle(
                            color: user.role == 'admin' ? AppColors.primary : Colors.grey.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Role Toggle Button
                      OutlinedButton.icon(
                        icon: const Icon(Icons.swap_horiz, size: 16),
                        label: Text(user.role == 'admin' ? 'Set as Customer' : 'Make Admin', style: const TextStyle(fontSize: 12)),
                        onPressed: () => userProvider.toggleUserRole(user.id),
                      ),
                      // Active/Deactivate Switch
                      Row(
                        children: [
                          Text(
                            user.isActive ? 'Active' : 'Disabled',
                            style: TextStyle(
                              fontSize: 12,
                              color: user.isActive ? AppColors.secondary : AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Switch(
                            value: user.isActive,
                            activeColor: AppColors.secondary,
                            onChanged: (_) => userProvider.toggleUserActiveStatus(user.id),
                          ),
                        ],
                      ),
                      // Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete User'),
                              content: Text('Are you sure you want to delete ${user.name}?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                  onPressed: () {
                                    userProvider.deleteUser(user.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
