import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/widget/dashboard_calendar.dart';

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

  @override
  void initState() {
    super.initState();
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
                  '1,248',
                  Icons.school,
                  const Color(0xFF6C5CE7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Total Staffs',
                  '86',
                  Icons.people,
                  const Color(0xFF00B894),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Pie Chart Section
        Padding(
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
                            angle:
                                _animation.value * 2 * 3.14159, // Full rotation
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                        setState(() {
                                          if (!event
                                                  .isInterestedForInteractions ||
                                              pieTouchResponse == null ||
                                              pieTouchResponse.touchedSection ==
                                                  null) {
                                            touchedIndex = -1;
                                            return;
                                          }
                                          touchedIndex = pieTouchResponse
                                              .touchedSection!
                                              .touchedSectionIndex;
                                        });
                                      },
                                ),
                                sectionsSpace: 5,
                                centerSpaceRadius: 85,
                                sections: _getPieSections(),
                              ),
                            ),
                          ),
                          // Center content with legend (without percentages)
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
                              children: [
                                _buildCenterLegendItem(
                                  'Class 1st',
                                  AppColors.primaryColor,
                                ),
                                const SizedBox(height: 8),
                                _buildCenterLegendItem(
                                  'Class 2nd',
                                  AppColors.green500,
                                ),
                                const SizedBox(height: 8),
                                _buildCenterLegendItem(
                                  'Class 3rd',
                                  const Color(0xFFFD79A8),
                                ),
                                const SizedBox(height: 8),
                                _buildCenterLegendItem(
                                  'Others',
                                  AppColors.yellow,
                                ),
                              ],
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
        ),

        const SizedBox(height: 20),

        // Bar Chart Section
        Padding(
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
                      child: const Text(
                        '₹8.2L',
                        style: TextStyle(
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
                  '+12.5% from last month',
                  style: TextStyle(color: AppColors.gray500, fontSize: 13),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100,
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
                            const months = [
                              'January',
                              'February',
                              'March',
                              'April',
                              'May',
                              'June',
                            ];
                            return BarTooltipItem(
                              '${months[group.x.toInt()]}\n',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  text: '₹${rod.toY.toInt()}K',
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
                                '₹${value.toInt()}K',
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
                              const months = [
                                'Jan',
                                'Feb',
                                'Mar',
                                'Apr',
                                'May',
                                'Jun',
                              ];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  months[value.toInt()],
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
                        horizontalInterval: 20,
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
        ),
        const SizedBox(height: 20),

        // Students Ranks Line Chart Section
        Padding(
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
                          maxX: 3,
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
                                  const classes = [
                                    'Class 1st',
                                    'Class 2nd',
                                    'Class 3rd',
                                    'Oth',
                                  ];

                                  // 🛡 Prevent out-of-range access
                                  if (value.toInt() < 0 ||
                                      value.toInt() >= classes.length) {
                                    return const SizedBox.shrink();
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      classes[value.toInt()],
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
                          lineBarsData: [
                            // Current Year trend
                            LineChartBarData(
                              spots: [
                                FlSpot(0, 75 * _animation.value),
                                FlSpot(1, 82 * _animation.value),
                                FlSpot(2, 90 * _animation.value),
                                FlSpot(3, 68 * _animation.value),
                              ],
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

                            // Last Year trend (comparison)
                            LineChartBarData(
                              spots: [
                                FlSpot(0, 70 * _animation.value),
                                FlSpot(1, 78 * _animation.value),
                                FlSpot(2, 83 * _animation.value),
                                FlSpot(3, 65 * _animation.value),
                              ],
                              isCurved: true,
                              color: AppColors.green500,
                              barWidth: 3,
                              dashArray: [6, 4], // dashed line for distinction
                              belowBarData: BarAreaData(show: false),
                              dotData: FlDotData(show: true),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 100),
      ],
    );
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
    return [
      PieChartSectionData(
        color: AppColors.primaryColor,
        value: 35,
        title: '35%',
        radius: touchedIndex == 0 ? 75 : 65,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgePositionPercentageOffset: 1.2,
      ),
      PieChartSectionData(
        color: AppColors.green500,
        value: 28,
        title: '28%',
        radius: touchedIndex == 1 ? 75 : 65,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),

        badgePositionPercentageOffset: 1.2,
      ),
      PieChartSectionData(
        color: const Color(0xFFFD79A8),
        value: 22,
        title: '22%',
        radius: touchedIndex == 2 ? 75 : 65,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),

        badgePositionPercentageOffset: 1.2,
      ),
      PieChartSectionData(
        color: AppColors.yellow,
        value: 15,
        title: '15%',
        radius: touchedIndex == 3 ? 75 : 65,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),

        badgePositionPercentageOffset: 1.2,
      ),
    ];
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
          label,
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
    return [
      _createBarGroup(0, 65),
      _createBarGroup(1, 58),
      _createBarGroup(2, 72),
      _createBarGroup(3, 68),
      _createBarGroup(4, 82),
      _createBarGroup(5, 78),
    ];
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
