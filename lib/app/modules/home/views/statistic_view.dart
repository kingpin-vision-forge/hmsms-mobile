import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/widget/dashboard_calendar.dart';
import 'package:student_management/app/modules/home/controllers/admin_dashboard_controller.dart';

class DashboardStatistics extends StatefulWidget {
  const DashboardStatistics({super.key});

  @override
  State<DashboardStatistics> createState() => _DashboardStatisticsState();
}

class _DashboardStatisticsState extends State<DashboardStatistics>
    with SingleTickerProviderStateMixin {
  int touchedIndex = -1;
  int touchedBarIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _statAnimation;
  late AdminDashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(AdminDashboardController());
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
    // Stat number animation (3 seconds)
    _statAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(50),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (_controller.hasError.value) {
        return _buildErrorState();
      }

      return Column(
        children: [
          // Calendar Widget
          const DashboardCalendar(),

          const SizedBox(height: 8),

          // Quick Stats Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Students',
                    _controller.formattedTotalStudents,
                    Icons.school,
                    const Color(0xFF6C5CE7),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Total Staff',
                    _controller.formattedTotalStaff,
                    Icons.people,
                    const Color(0xFF00B894),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Pie Chart Section
          _buildPieChartSection(),

          const SizedBox(height: 20),

          // Bar Chart Section
          _buildBarChartSection(),

          const SizedBox(height: 20),

          // Students Ranks Line Chart Section
          _buildLineChartSection(),

          const SizedBox(height: 100),
        ],
      );
    });
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAlertCircle,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load dashboard',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              _controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray500),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _controller.refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Student Distribution',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 280,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: _animation.value * 2 * 3.14159,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            sectionsSpace: 5,
                            centerSpaceRadius: 85,
                            sections: _getPieSections(),
                          ),
                        ),
                      ),
                      // Center content with legend
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.08),
                              blurRadius: 15,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildCenterLegendItems(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCenterLegendItems() {
    final distribution = _controller.studentDistribution;
    final colors = [
      AppColors.primaryColor,
      AppColors.green500,
      const Color(0xFFFD79A8),
      AppColors.yellow,
    ];

    if (distribution.isEmpty) {
      return [
        _buildCenterLegendItem('No Data', AppColors.gray500),
      ];
    }

    final items = <Widget>[];
    for (int i = 0; i < distribution.length && i < 4; i++) {
      final item = distribution[i];
      final label = item['className'] ?? 'Class ${i + 1}';
      items.add(_buildCenterLegendItem(label, colors[i % colors.length]));
      if (i < 3) items.add(const SizedBox(height: 8));
    }
    return items;
  }

  Widget _buildBarChartSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Monthly Fees Collection',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green500.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _controller.formattedTotalCollected,
                    style: const TextStyle(
                      color: Color(0xFF00B894),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _controller.growthPercentageText,
              style: TextStyle(color: AppColors.gray500, fontSize: 13),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getBarChartMaxY(),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            barTouchResponse == null ||
                            barTouchResponse.spot == null) {
                          touchedBarIndex = -1;
                          return;
                        }
                        touchedBarIndex =
                            barTouchResponse.spot!.touchedBarGroupIndex;
                      });
                    },
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => AppColors.primaryColor,
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final monthData = _controller.monthlyFeesCollection;
                        if (groupIndex >= monthData.length) return null;
                        final month = monthData[groupIndex]['month'] ?? '';
                        return BarTooltipItem(
                          '$month\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: '₹${(rod.toY / 1000).toStringAsFixed(0)}K',
                              style: const TextStyle(
                                color: AppColors.secondaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '₹${(value / 1000).toInt()}K',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final monthData = _controller.monthlyFeesCollection;
                          final index = value.toInt();
                          if (index >= monthData.length) {
                            return const SizedBox.shrink();
                          }
                          final month = monthData[index]['month'] ?? '';
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              month.length > 3 ? month.substring(0, 3) : month,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _getBarChartMaxY() / 5 > 0 
                        ? _getBarChartMaxY() / 5 
                        : 20000, // Fallback to prevent zero
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[200],
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _getBarGroups(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getBarChartMaxY() {
    final monthData = _controller.monthlyFeesCollection;
    if (monthData.isEmpty) return 100000;
    double maxY = 0;
    for (final m in monthData) {
      final collected = (m['collected'] ?? 0) as num;
      if (collected > maxY) maxY = collected.toDouble();
    }
    return maxY * 1.2; // 20% headroom
  }

  Widget _buildLineChartSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Students Rank Progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ranking trend by Class & Year',
              style: TextStyle(color: AppColors.gray500, fontSize: 12),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 220,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, _) {
                  return LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: _getLineChartMaxX(),
                      minY: 0,
                      maxY: 100,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 20,
                        getDrawingHorizontalLine: (value) =>
                            FlLine(color: AppColors.gray50, strokeWidth: 1),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}%',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            interval: 1,
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final performance = _controller.currentYearPerformance;
                              final index = value.toInt();
                              if (index < 0 || index >= performance.length) {
                                return const SizedBox.shrink();
                              }
                              final className = performance[index]['className'] ?? '';
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  className.length > 8 
                                      ? '${className.substring(0, 8)}...' 
                                      : className,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      lineBarsData: _getLineChartData(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getLineChartMaxX() {
    final performance = _controller.currentYearPerformance;
    return performance.isEmpty ? 3 : (performance.length - 1).toDouble();
  }

  List<LineChartBarData> _getLineChartData() {
    final currentYear = _controller.currentYearPerformance;
    final previousYear = _controller.previousYearPerformance;

    final currentSpots = <FlSpot>[];
    final previousSpots = <FlSpot>[];

    for (int i = 0; i < currentYear.length; i++) {
      final percentage = (currentYear[i]['percentage'] ?? 0) as num;
      currentSpots.add(FlSpot(i.toDouble(), percentage.toDouble() * _animation.value));
    }

    for (int i = 0; i < previousYear.length; i++) {
      final percentage = (previousYear[i]['percentage'] ?? 0) as num;
      previousSpots.add(FlSpot(i.toDouble(), percentage.toDouble() * _animation.value));
    }

    // Fallback to placeholder data if no data
    if (currentSpots.isEmpty) {
      currentSpots.addAll([
        FlSpot(0, 75 * _animation.value),
        FlSpot(1, 82 * _animation.value),
        FlSpot(2, 90 * _animation.value),
        FlSpot(3, 68 * _animation.value),
      ]);
    }
    if (previousSpots.isEmpty) {
      previousSpots.addAll([
        FlSpot(0, 70 * _animation.value),
        FlSpot(1, 78 * _animation.value),
        FlSpot(2, 83 * _animation.value),
        FlSpot(3, 65 * _animation.value),
      ]);
    }

    return [
      LineChartBarData(
        spots: currentSpots,
        isCurved: true,
        color: AppColors.primaryColor,
        barWidth: 3,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withOpacity(0.3),
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        dotData: FlDotData(show: true),
      ),
      LineChartBarData(
        spots: previousSpots,
        isCurved: true,
        color: AppColors.green500,
        barWidth: 3,
        dashArray: [6, 4],
        belowBarData: BarAreaData(show: false),
        dotData: FlDotData(show: true),
      ),
    ];
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final targetValue = double.tryParse(value.replaceAll(',', '')) ?? 0;

    return AnimatedBuilder(
      animation: _statAnimation,
      builder: (context, child) {
        final animatedValue = targetValue * _statAnimation.value;

        String formattedValue = animatedValue >= 1000
            ? animatedValue.toInt().toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              )
            : animatedValue.toInt().toString();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                formattedValue,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _getPieSections() {
    final distribution = _controller.studentDistribution;
    final colors = [
      AppColors.primaryColor,
      AppColors.green500,
      const Color(0xFFFD79A8),
      AppColors.yellow,
    ];

    if (distribution.isEmpty) {
      // Fallback to placeholder
      return [
        PieChartSectionData(
          color: AppColors.gray500,
          value: 100,
          title: 'No Data',
          radius: 65,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ];
    }

    return distribution.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final percentage = (item['percentage'] ?? 0) as num;
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: percentage.toDouble(),
        title: '${percentage.toStringAsFixed(0)}%',
        radius: touchedIndex == index ? 75 : 65,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgePositionPercentageOffset: 1.2,
      );
    }).toList();
  }

  Widget _buildCenterLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label.length > 10 ? '${label.substring(0, 10)}...' : label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    final monthData = _controller.monthlyFeesCollection;

    if (monthData.isEmpty) {
      // Fallback to placeholder
      return [
        _createBarGroup(0, 65000),
        _createBarGroup(1, 58000),
        _createBarGroup(2, 72000),
        _createBarGroup(3, 68000),
        _createBarGroup(4, 82000),
        _createBarGroup(5, 78000),
      ];
    }

    return monthData.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final collected = (item['collected'] ?? 0) as num;
      return _createBarGroup(index, collected.toDouble());
    }).toList();
  }

  BarChartGroupData _createBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: touchedBarIndex == x ? 20 : 16,
          gradient: LinearGradient(
            colors: touchedBarIndex == x
                ? [AppColors.primaryColor, AppColors.green500]
                : [const Color(0xFF6C5CE7), const Color(0xFF00B894)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }
}
