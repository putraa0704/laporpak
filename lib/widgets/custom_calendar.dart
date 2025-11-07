// lib/widgets/custom_calendar.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const CustomCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;

  // Nama bulan dalam bahasa Indonesia
  final List<String> _monthNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
    _selectedDate = widget.selectedDate;
  }

  @override
  void didUpdateWidget(CustomCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      setState(() {
        _selectedDate = widget.selectedDate;
        _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
      });
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateChanged(date);
  }

  List<DateTime?> _getDaysInMonth() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    
    List<DateTime?> days = [];
    
    // Add empty days for alignment (Minggu = 0, Senin = 1, dst)
    int startWeekday = firstDay.weekday % 7; // Convert to 0-6 (Sunday-Saturday)
    for (int i = 0; i < startWeekday; i++) {
      days.add(null); // placeholder
    }
    
    // Add actual days
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(_currentMonth.year, _currentMonth.month, i));
    }
    
    return days;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return _isSameDay(date, today);
  }

  String _getMonthYearText() {
    return '${_monthNames[_currentMonth.month - 1]} ${_currentMonth.year}';
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth();

    return Column(
      children: [
        // Month navigation
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Color(0xff5f34e0)),
                onPressed: _previousMonth,
              ),
              Text(
                _getMonthYearText(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5f34e0),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Color(0xff5f34e0)),
                onPressed: _nextMonth,
              ),
            ],
          ),
        ),

        // Weekday headers
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab']
                .map((day) => SizedBox(
                      width: 40,
                      child: Center(
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),

        const SizedBox(height: 8),

        // Calendar grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final date = days[index];
              
              // Skip placeholder dates
              if (date == null) {
                return const SizedBox();
              }

              final isSelected = _isSameDay(date, _selectedDate);
              final isToday = _isToday(date);
              final isCurrentMonth = date.month == _currentMonth.month;

              return GestureDetector(
                onTap: () => _selectDate(date),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xff5f34e0)
                        : isToday
                            ? const Color(0xff5f34e0).withOpacity(0.1)
                            : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isToday && !isSelected
                        ? Border.all(
                            color: const Color(0xff5f34e0),
                            width: 2,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected || isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : isCurrentMonth
                                ? Colors.black87
                                : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}