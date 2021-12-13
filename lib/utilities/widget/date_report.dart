import 'package:flutter/material.dart';
import 'package:iris/utilities/widget/monthcelldecoration.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePikerReport extends StatefulWidget {
  const DatePikerReport({Key? key}) : super(key: key);

  @override
  _DatePikerReportState createState() => _DatePikerReportState();
}

class _DatePikerReportState extends State<DatePikerReport> {
  late List<DateTime> days;

  @override
  void initState() {
    days = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: height * 0.5,
            width: double.infinity,
            child: _datePicker(),
          ),
        ],
      ),
    );
  }

  Widget _datePicker() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        margin: const EdgeInsets.all(30),
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SfDateRangePicker(
                selectionShape: DateRangePickerSelectionShape.rectangle,
                selectionColor: Colors.greenAccent,
                onSelectionChanged: (change) => days = change.value,
                selectionMode: DateRangePickerSelectionMode.multiple,
                selectionTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 14),
                minDate: DateTime.now().add(const Duration(days: -200)),
                maxDate: DateTime.now(),
                headerStyle: DateRangePickerHeaderStyle(
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.7),
                    )),
                monthCellStyle: DateRangePickerMonthCellStyle(
                    cellDecoration: MonthCellDecoration(
                        borderColor: Colors.transparent,
                        backgroundColor: Colors.greenAccent.withOpacity(0.1),
                        showIndicator: false,
                        indicatorColor: const Color(0xFF1AC4C7)),
                    todayCellDecoration: MonthCellDecoration(
                        borderColor: Colors.greenAccent,
                        backgroundColor: Colors.greenAccent.withOpacity(0.1),
                        showIndicator: false,
                        indicatorColor: const Color(0xFF1AC4C7)),
                    specialDatesDecoration: MonthCellDecoration(
                        borderColor: Colors.transparent,
                        backgroundColor: Colors.greenAccent.withOpacity(0.1),
                        showIndicator: true,
                        indicatorColor: const Color(0xFF1AC4C7)),
                    disabledDatesTextStyle: TextStyle(
                      color: Colors.greenAccent.withOpacity(0.1),
                    ),
                    weekendTextStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    textStyle:
                        const TextStyle(color: Colors.black, fontSize: 14),
                    specialDatesTextStyle:
                        const TextStyle(color: Colors.black, fontSize: 14),
                    todayTextStyle: const TextStyle(
                        color: Colors.greenAccent, fontSize: 14)),
                yearCellStyle: DateRangePickerYearCellStyle(
                  todayTextStyle:
                      const TextStyle(color: Colors.greenAccent, fontSize: 14),
                  textStyle: const TextStyle(color: Colors.black, fontSize: 14),
                  disabledDatesTextStyle:
                      const TextStyle(color: Color(0xffe2d7fe)),
                  leadingDatesTextStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5), fontSize: 14),
                ),
                showNavigationArrow: true,
                todayHighlightColor: Colors.greenAccent,
                monthViewSettings: const DateRangePickerMonthViewSettings(
                  firstDayOfWeek: 1,
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                  dayFormat: 'EEE',
                  showTrailingAndLeadingDates: false,
                  // specialDates: specialDates,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancelar',
                          style:
                              TextStyle(fontSize: 18, color: Colors.redAccent),
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(days);
                        },
                        child: const Text(
                          'Confirmar',
                          style: TextStyle(
                              fontSize: 18, color: Colors.greenAccent),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
