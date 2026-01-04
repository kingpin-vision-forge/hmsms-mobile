import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';

/// Event type options
enum EventType {
  HOLIDAY('HOLIDAY', 'Holiday', '#FF5252', HugeIcons.strokeRoundedCalendarRemove02),
  EXAM('EXAM', 'Exam', '#FF9800', HugeIcons.strokeRoundedNotebook),
  FEE_DUE('FEE_DUE', 'Fee Due', '#FFEB3B', HugeIcons.strokeRoundedDollarSquare),
  MEETING('MEETING', 'Meeting', '#2196F3', HugeIcons.strokeRoundedUserGroup),
  EVENT('EVENT', 'Event', '#4CAF50', HugeIcons.strokeRoundedCalendarCheckIn02),
  OTHER('OTHER', 'Other', '#9E9E9E', HugeIcons.strokeRoundedCalendar03);

  final String value;
  final String label;
  final String color;
  final IconData icon;
  
  const EventType(this.value, this.label, this.color, this.icon);
  
  Color get colorValue => Color(int.parse(color.replaceFirst('#', '0xFF')));
}

/// Form data for creating/editing events
class EventFormData {
  String? id;
  String title;
  String? description;
  EventType type;
  DateTime startDate;
  DateTime? endDate;
  bool allDay;
  bool allStudents;
  List<String> classIds;
  List<String> sectionIds;

  EventFormData({
    this.id,
    this.title = '',
    this.description,
    this.type = EventType.EVENT,
    DateTime? startDate,
    this.endDate,
    this.allDay = true,
    this.allStudents = true,
    this.classIds = const [],
    this.sectionIds = const [],
  }) : startDate = startDate ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'type': type.value,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'allDay': allDay,
      'color': type.color,
      'allStudents': allStudents,
      'classIds': classIds,
      'sectionIds': sectionIds,
    };
  }
}

/// Modal dialog for creating or editing calendar events
class AddEventModal extends StatefulWidget {
  /// Initial data for editing (null for new event)
  final EventFormData? initialData;
  
  /// Selected date from calendar
  final DateTime? selectedDate;
  
  /// Callback when event is saved
  final Function(EventFormData event)? onSave;

  const AddEventModal({
    super.key,
    this.initialData,
    this.selectedDate,
    this.onSave,
  });

  /// Show the modal as a bottom sheet
  static Future<EventFormData?> show({
    required BuildContext context,
    EventFormData? initialData,
    DateTime? selectedDate,
  }) async {
    return showModalBottomSheet<EventFormData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEventModal(
        initialData: initialData,
        selectedDate: selectedDate,
      ),
    );
  }

  @override
  State<AddEventModal> createState() => _AddEventModalState();
}

class _AddEventModalState extends State<AddEventModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late EventType _selectedType;
  late DateTime _startDate;
  DateTime? _endDate;
  late bool _allDay;
  late bool _allStudents;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    _titleController = TextEditingController(text: data?.title ?? '');
    _descriptionController = TextEditingController(text: data?.description ?? '');
    _selectedType = data?.type ?? EventType.EVENT;
    _startDate = data?.startDate ?? widget.selectedDate ?? DateTime.now();
    _endDate = data?.endDate;
    _allDay = data?.allDay ?? true;
    _allStudents = data?.allStudents ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.initialData?.id != null;

  Future<void> _selectDate(BuildContext context, {required bool isEndDate}) async {
    final initialDate = isEndDate ? (_endDate ?? _startDate) : _startDate;
    
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isEndDate ? _startDate : DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        if (isEndDate) {
          _endDate = picked;
        } else {
          _startDate = picked;
          // Reset end date if it's before start date
          if (_endDate != null && _endDate!.isBefore(_startDate)) {
            _endDate = null;
          }
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, {required bool isEndTime}) async {
    final initialTime = TimeOfDay.fromDateTime(
      isEndTime ? (_endDate ?? _startDate) : _startDate
    );
    
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        if (isEndTime && _endDate != null) {
          _endDate = DateTime(
            _endDate!.year, _endDate!.month, _endDate!.day,
            picked.hour, picked.minute,
          );
        } else if (!isEndTime) {
          _startDate = DateTime(
            _startDate.year, _startDate.month, _startDate.day,
            picked.hour, picked.minute,
          );
        }
      });
    }
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final eventData = EventFormData(
      id: widget.initialData?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      type: _selectedType,
      startDate: _startDate,
      endDate: _endDate,
      allDay: _allDay,
      allStudents: _allStudents,
    );

    if (widget.onSave != null) {
      widget.onSave!(eventData);
    }
    
    Navigator.pop(context, eventData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
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
                Text(
                  _isEditing ? 'Edit Event' : 'Add Event',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          
          Divider(height: 1, color: AppColors.gray50),
          
          // Form
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Type Selection
                    Text(
                      'Event Type',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: EventType.values.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final type = EventType.values[index];
                          final isSelected = type == _selectedType;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedType = type),
                            child: Container(
                              width: 70,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? type.colorValue.withOpacity(0.2) 
                                    : AppColors.gray50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected 
                                      ? type.colorValue 
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    type.icon,
                                    color: isSelected 
                                        ? type.colorValue 
                                        : AppColors.gray500,
                                    size: 24,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    type.label,
                                    style: TextStyle(
                                      color: isSelected 
                                          ? type.colorValue 
                                          : AppColors.gray500,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Title
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Event Title *',
                        hintText: 'Enter event title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description (Optional)',
                        hintText: 'Enter event description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // All Day Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Day Event',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Switch(
                          value: _allDay,
                          onChanged: (value) => setState(() => _allDay = value),
                          activeColor: AppColors.primaryColor,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Start Date
                    Text(
                      'Start Date${_allDay ? '' : ' & Time'}',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _DateTimeButton(
                            icon: Icons.calendar_today,
                            label: DateFormat('MMM d, yyyy').format(_startDate),
                            onTap: () => _selectDate(context, isEndDate: false),
                          ),
                        ),
                        if (!_allDay) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DateTimeButton(
                              icon: Icons.access_time,
                              label: DateFormat('hh:mm a').format(_startDate),
                              onTap: () => _selectTime(context, isEndTime: false),
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // End Date
                    Text(
                      'End Date${_allDay ? ' (Optional)' : ' & Time'}',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _DateTimeButton(
                            icon: Icons.calendar_today,
                            label: _endDate != null 
                                ? DateFormat('MMM d, yyyy').format(_endDate!)
                                : 'Select date',
                            onTap: () => _selectDate(context, isEndDate: true),
                          ),
                        ),
                        if (!_allDay && _endDate != null) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DateTimeButton(
                              icon: Icons.access_time,
                              label: DateFormat('hh:mm a').format(_endDate!),
                              onTap: () => _selectTime(context, isEndTime: true),
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Applies to all students
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Applies to All Students',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Event visible to everyone',
                              style: TextStyle(
                                color: AppColors.gray500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _allStudents,
                          onChanged: (value) => setState(() => _allStudents = value),
                          activeColor: AppColors.primaryColor,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _isEditing ? 'Update Event' : 'Create Event',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable date/time picker button
class _DateTimeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DateTimeButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray500.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
