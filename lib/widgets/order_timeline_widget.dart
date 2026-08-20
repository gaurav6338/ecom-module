import 'package:flutter/material.dart';
import '../models/order.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';

class OrderTimelineWidget extends StatelessWidget {
  final List<OrderTimelineStep> steps;

  const OrderTimelineWidget({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            // Timeline Node & Indicator Line
            Column(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: step.isCompleted ? AppColors.secondary : Colors.grey.shade300,
                  child: Icon(
                    step.isCompleted ? Icons.check : Icons.circle,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 45,
                    color: step.isCompleted ? AppColors.secondary : Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Step Text Details
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          step.status,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: step.isCompleted
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          Formatters.formatDate(step.timestamp),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
