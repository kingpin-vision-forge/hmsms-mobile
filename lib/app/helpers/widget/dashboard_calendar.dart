import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/rbac/rbac.dart';
import 'package:student_management/app/helpers/widget/add_event_modal.dart';

/// Event model for calendar
class CalendarEvent {
  final String id;
  final String title;
  final String? description;
  final String type;
  final DateTime startDate;
  final DateTime? endDate;
  final bool allDay;
  final String color;

  CalendarEvent({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.startDate,
    this.endDate,
    this.allDay = true,
    this.color = '#4CAF50',
  });

  /// Get color from hex string
  Color get eventColor {
    try {
      return Color(int.parse(color.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppColors.primaryColor;
    }
  }

  /// Get icon based on event type
  IconData get typeIcon {
    switch (type.toUpperCase()) {
      case 'HOLIDAY':
        return HugeIcons.strokeRoundedCalendarRemove02;
      case 'EXAM':
        return HugeIcons.strokeRoundedNotebook;
      case 'FEE_DUE':
        return HugeIcons.strokeRoundedDollarSquare;
      case 'MEETING':
        return HugeIcons.strokeRoundedUserGroup;
      case 'EVENT':
        return HugeIcons.strokeRoundedCalendarCheckIn02;
      default:
        return HugeIcons.strokeRoundedCalendar03;
    }
  }
}

/// A calendar widget for the dashboard
/// Shows full month view with event markers and management options
class DashboardCalendar extends StatefulWidget {
  /// Events mapped by date
  final Map<DateTime, List<CalendarEvent>>? events;
  
  /// Callback when a day is selected
  final Function(DateTime selectedDay)? onDaySelected;
  
  /// Callback when add button is pressed
  final VoidCallback? onAddEvent;
  
  /// Callback when edit is requested
  final Function(CalendarEvent event)? onEditEvent;
  
  /// Callback when delete is requested
  final Function(CalendarEvent event)? onDeleteEvent;

  const DashboardCalendar({
    super.key,
    this.events,
    this.onDaySelected,
    this.onAddEvent,
    this.onEditEvent,
    this.onDeleteEvent,
  });

  @override
  State<DashboardCalendar> createState() => _DashboardCalendarState();
}

class _DashboardCalendarState extends State<DashboardCalendar> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  /// Get events for a specific day
  List<CalendarEvent> _getEventsForDay(DateTime day) {
    if (widget.events == null) return [];
    
    final normalizedDay = DateTime(day.year, day.month, day.day);
    
    for (final entry in widget.events!.entries) {
      final eventDate = DateTime(entry.key.year, entry.key.month, entry.key.day);
      if (eventDate.isAtSameMomentAs(normalizedDay)) {
        return entry.value;
      }
    }
    return [];
  }

  /// Check if user can manage events (Admin only)
  bool get _canManageEvents {
    try {
      final rbac = Get.find<RbacService>();
      return rbac.isRole(UserRole.SUPER_ADMIN) || rbac.isRole(UserRole.ADMIN);
    } catch (e) {
      return false;
    }
  }

  /// Show events bottom sheet
  void _showEventsBottomSheet(DateTime day, List<CalendarEvent> events) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EventsBottomSheet(
        day: day,
        events: events,
        canManage: _canManageEvents,
        onEdit: widget.onEditEvent,
        onDelete: widget.onDeleteEvent,
        onAdd: () => _showAddEventModal(context, selectedDate: day),
      ),
    );
  }

  /// Show add event modal
  void _showAddEventModal(BuildContext ctx, {DateTime? selectedDate}) async {
    final result = await AddEventModal.show(
      context: ctx,
      selectedDate: selectedDate ?? _selectedDay ?? DateTime.now(),
    );
    
    if (result != null) {
      // Event was created - notify parent or show success
      botToastSuccess('Event "${result.title}" created successfully');
      // TODO: Call API to save event
      debugPrint('Event data: ${result.toJson()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: TableCalendar<CalendarEvent>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: const {CalendarFormat.month: 'Month'},
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            defaultTextStyle: TextStyle(color: AppColors.black),
            weekendTextStyle: TextStyle(color: AppColors.gray500),
            markerDecoration: BoxDecoration(
              color: AppColors.callBtn,
              shape: BoxShape.circle,
            ),
            markersMaxCount: 3,
            markerSize: 6,
            markerMargin: const EdgeInsets.symmetric(horizontal: 1),
            outsideDaysVisible: false,
            cellMargin: const EdgeInsets.all(4),
          ),
          
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            headerPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          
          calendarBuilders: CalendarBuilders(
            headerTitleBuilder: (context, day) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.yMMMM().format(day),
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_canManageEvents)
                      GestureDetector(
                        onTap: () => _showAddEventModal(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: AppColors.gray500,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            weekendStyle: TextStyle(
              color: AppColors.gray500.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            widget.onDaySelected?.call(selectedDay);
            
            // Show events bottom sheet if day has events
            final events = _getEventsForDay(selectedDay);
            if (events.isNotEmpty) {
              _showEventsBottomSheet(selectedDay, events);
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
      ),
    );
  }
}

/// Bottom sheet for displaying events on a selected day
class _EventsBottomSheet extends StatelessWidget {
  final DateTime day;
  final List<CalendarEvent> events;
  final bool canManage;
  final Function(CalendarEvent)? onEdit;
  final Function(CalendarEvent)? onDelete;
  final VoidCallback? onAdd;

  const _EventsBottomSheet({
    required this.day,
    required this.events,
    required this.canManage,
    this.onEdit,
    this.onDelete,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray500.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE').format(day),
                      style: TextStyle(
                        color: AppColors.gray500,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      DateFormat('d MMMM yyyy').format(day),
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (canManage)
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onAdd?.call();
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          Divider(height: 1, color: AppColors.gray50),
          
          // Events list
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final event = events[index];
                return _EventCard(
                  event: event,
                  canManage: canManage,
                  onEdit: () {
                    Navigator.pop(context);
                    onEdit?.call(event);
                  },
                  onDelete: () => _showDeleteConfirmation(context, event),
                );
              },
            ),
          ),
          
          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, CalendarEvent event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Close bottom sheet
              onDelete?.call(event);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Individual event card
class _EventCard extends StatelessWidget {
  final CalendarEvent event;
  final bool canManage;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _EventCard({
    required this.event,
    required this.canManage,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: event.eventColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: event.eventColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Event type icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: event.eventColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                event.typeIcon,
                color: event.eventColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            
            // Event details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (event.description != null && event.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        event.description!,
                        style: TextStyle(
                          color: AppColors.gray500,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: event.eventColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      event.type.toUpperCase(),
                      style: TextStyle(
                        color: event.eventColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Admin actions
            if (canManage)
              Column(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: Icon(
                      HugeIcons.strokeRoundedEdit02,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      HugeIcons.strokeRoundedDelete02,
                      color: Colors.red,
                      size: 20,
                    ),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
