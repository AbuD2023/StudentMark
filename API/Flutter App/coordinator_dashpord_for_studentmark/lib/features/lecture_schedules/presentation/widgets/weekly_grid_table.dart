import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';

class WeeklyGridTable extends StatelessWidget {
  final List<LectureSchedule> schedules;
  final double cellHeight;
  final double minCellWidth;

  WeeklyGridTable({
    required this.schedules,
    this.cellHeight = 70,
    this.minCellWidth = 40,
    super.key,
  });

  final List<String> days = [
    'الأحد', // 0
    'الإثنين', // 1
    'الثلاثاء', // 2
    'الأربعاء', // 3
    'الخميس', // 4
    'الجمعة', // 5
    'السبت', // 6
  ];

  final int dayStartHour = 8;
  final int dayEndHour = 19;
  final double hourWidth = 120; // عرض الساعة الواحدة بالبكسل

  DateTime _parseTime(String t) {
    final parts = t.split(':').map(int.parse).toList();
    return DateTime(0, 1, 1, parts[0], parts[1]);
  }

  int _toMinutes(DateTime t) => t.hour * 60 + t.minute;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cellTextStyle =
        TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black);
    final totalDayMinutes = (dayEndHour - dayStartHour) * 60;
    const headerHeight = 40.0;
    final totalWidth = (dayEndHour - dayStartHour) * hourWidth;

    // رؤوس الوقت (كل ساعة)
    List<Widget> buildTimeHeader() {
      List<Widget> headers = [];
      for (int h = dayStartHour; h < dayEndHour; h++) {
        headers.add(Container(
          width: hourWidth,
          height: headerHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            border: Border(
              // right: BorderSide(color: theme.dividerColor),
              left: BorderSide(color: theme.dividerColor),
            ),
          ),
          child: Text('$h-${h + 1}',
              style: cellTextStyle.copyWith(fontWeight: FontWeight.bold)),
        ));
      }
      return headers;
    }

    Widget buildDayRow(List<LectureSchedule> lectures, int dayIndex) {
      lectures.sort(
          (a, b) => _parseTime(a.startTime).compareTo(_parseTime(b.startTime)));
      List<Widget> cells = [];
      int currentMinute = dayStartHour * 60;
      final int dayStartMinute = dayStartHour * 60;
      final int dayEndMinute = dayEndHour * 60;
      for (var lecture in lectures) {
        final start = _parseTime(lecture.startTime);
        final end = _parseTime(lecture.endTime);
        int startMinute = _toMinutes(start);
        int endMinute = _toMinutes(end);

        // إذا كانت المحاضرة خارج اليوم بالكامل (قبل 8:00 أو بعد 19:00)
        if (endMinute <= dayStartMinute || startMinute >= dayEndMinute) {
          cells.add(Container(
            width: minCellWidth,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.12),
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  lecture.courseSubject?.subject?.subjectName ?? '',
                  style:
                      cellTextStyle.copyWith(color: Colors.red, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'خارج اليوم',
                  style:
                      cellTextStyle.copyWith(color: Colors.red, fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ));
          continue;
        }

        // ضبط وقت البداية والنهاية ليكون ضمن اليوم
        int displayStart =
            startMinute < dayStartMinute ? dayStartMinute : startMinute;
        int displayEnd = endMinute > dayEndMinute ? dayEndMinute : endMinute;

        // خانة فارغة قبل المحاضرة إذا وجدت فجوة
        if (displayStart > currentMinute) {
          int gap = displayStart - currentMinute;
          double cellWidth = ((gap / totalDayMinutes) * totalWidth)
              .clamp(minCellWidth, totalWidth);
          cells.add(Container(
            width: cellWidth,
            height: 60,
            color: theme.primaryColor.withOpacity(0.03),
          ));
        }
        // خانة المحاضرة
        int duration = displayEnd - displayStart;
        double cellWidth = ((duration / totalDayMinutes) * totalWidth)
            .clamp(minCellWidth, totalWidth);
        cells.add(Container(
          width: cellWidth,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.07),
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                lecture.courseSubject?.subject?.subjectName ?? '',
                style: cellTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              Text(
                lecture.doctor?.fullName ?? '',
                style: cellTextStyle.copyWith(fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              Text(
                lecture.room,
                style: cellTextStyle.copyWith(fontSize: 11, color: Colors.blue),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              Text(
                '${lecture.startTime} - ${lecture.endTime}',
                style: cellTextStyle.copyWith(fontSize: 10, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
        currentMinute = displayEnd;
      }
      // خانة فارغة بعد آخر محاضرة حتى نهاية اليوم
      if (currentMinute < dayEndMinute) {
        int gap = dayEndMinute - currentMinute;
        double cellWidth = ((gap / totalDayMinutes) * totalWidth)
            .clamp(minCellWidth, totalWidth);
        cells.add(
          Container(
            width: cellWidth,
            height: 60,
            color: theme.primaryColor.withOpacity(0.03),
          ),
        );
        // cells.add(Container(
        //   height: 60,
        //   width: cellWidth,
        //   decoration: BoxDecoration(
        //     color: Colors.black.withOpacity(0.12),
        //     border: Border.all(color: Colors.black),
        //     borderRadius: BorderRadius.circular(6),
        //   ),
        // ));
      }
      return Row(children: cells);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor, width: 1.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    width: 60,
                    height: headerHeight,
                    color: theme.primaryColor.withOpacity(0.1),
                    alignment: Alignment.center,
                    child: Text('الايام', style: cellTextStyle),
                  ),
                  ...buildTimeHeader(),
                ],
              ),
              // Rows for each day
              ...List.generate(days.length, (dayIndex) {
                final lectures =
                    schedules.where((s) => s.dayOfWeek == dayIndex).toList();
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          color: theme.primaryColor.withOpacity(0.1),
                          child: Text(days[dayIndex],
                              style: cellTextStyle.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                        buildDayRow(lectures, dayIndex),
                      ],
                    ),
                    // خط فاصل أفقي بين الأيام
                    Container(
                      height: 1,
                      color: theme.dividerColor.withOpacity(0.3),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    // Container(
                    //   // height: 1,
                    //   width: 5,
                    //   color: Colors.red,
                    //   margin: const EdgeInsets.symmetric(vertical: 8),
                    // ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
