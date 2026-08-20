import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/product_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          // Revenue Trend Line Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Revenue Growth (Weekly)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.trending_up, color: AppColors.secondary),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total Sales: ${Formatters.formatCurrency(orderProvider.totalRevenue)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: const FlTitlesData(
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(1, 12000),
                              FlSpot(2, 25000),
                              FlSpot(3, 18000),
                              FlSpot(4, 34000),
                              FlSpot(5, 29000),
                              FlSpot(6, 42000),
                              FlSpot(7, 58000),
                            ],
                            isCurved: true,
                            color: AppColors.primary,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.primary.withOpacity(0.15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Category Sales Bar Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  const Text(
                    'Sales by Category',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: [
                          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 12, color: AppColors.primary)]),
                          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 18, color: AppColors.secondary)]),
                          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 10, color: AppColors.warning)]),
                          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 8, color: Colors.purple)]),
                          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 15, color: Colors.teal)]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Audio', style: TextStyle(fontSize: 10)),
                      Text('Fashion', style: TextStyle(fontSize: 10)),
                      Text('Footwear', style: TextStyle(fontSize: 10)),
                      Text('Watches', style: TextStyle(fontSize: 10)),
                      Text('Home', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Order Status Donut Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  const Text(
                    'Order Status Breakdown',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: orderProvider.pendingOrdersCount.toDouble() == 0 ? 1 : orderProvider.pendingOrdersCount.toDouble(),
                            color: AppColors.warning,
                            title: 'Pending',
                            radius: 50,
                            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            value: orderProvider.completedOrdersCount.toDouble() == 0 ? 1 : orderProvider.completedOrdersCount.toDouble(),
                            color: AppColors.secondary,
                            title: 'Delivered',
                            radius: 50,
                            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
