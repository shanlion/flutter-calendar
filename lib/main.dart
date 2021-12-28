import 'package:flutter/material.dart';
import 'package:lunar/lunar.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 国际化

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'date calendar',
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const [Locale("zh", "CH"), Locale("en", "US")],
      home: Scaffold(
          body: Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 2),
                color: primaryColor[50],
              ),
              child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(flex: 2, child: DateCalendar(key: UniqueKey())),
                    Expanded(flex: 1, child: WriteContent(key: UniqueKey()))
                  ]))),
    );
  }
}

class DateCalendar extends StatefulWidget {
  const DateCalendar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DateCalendarState();
}

class _DateCalendarState extends State<DateCalendar> {
  // _showDatePicker() async {
  //   var picker = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1994),
  //     lastDate: DateTime(2024),
  //   );
  //   print(picker);
  //   setState(() {
  //     _time = picker.toString();
  //   });
  // }

  _formatDay(value) {
    var newValue = value.toString();
    var dateArr = newValue.split(' ')[0].split('-');
    var day = dateArr[2];
    Lunar lunar = Lunar.fromDate(value);

    var dayYiArr = lunar.getDayYi();
    var dayJiArr = lunar.getDayJi();

    var dayName = lunar.getSolar().getYear().toString();

    var dateInfo = {
      "dayYi": dayYiArr.join(","),
      "dayJi": dayJiArr.join(","),
      "week": lunar.getWeekInChinese(),
      "dayName": dayName
    };
    return {"day": day, "dateInfo": dateInfo};
  }

  _onDateChanged(value) {
    var info = _formatDay(value);
    setState(() {
      _time = info["day"];
      _dateInfo = info["dateInfo"];
    });
  }

  dynamic _time = "";
  dynamic _dateInfo = {"dayYi": "", "dayJi": "", "week": "", "dayName": ""};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _onDateChanged(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
            width: double.infinity,
            height: 20,
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: primaryColor, width: 2))),
            child: Text(_dateInfo["dayName"] + "星期" + _dateInfo["week"])),
        FittedBox(
            fit: BoxFit.contain,
            child: Text(
              _time,
              key: UniqueKey(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: primaryColor),
            )),
        CalendarDatePicker(
          initialDate: DateTime.now(),
          firstDate: DateTime(1994),
          lastDate: DateTime(2024),
          onDateChanged: (value) => _onDateChanged(value),
        ),
        Container(
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: primaryColor, width: 2))),
            child: SizedBox(
                width: double.infinity,
                height: 80,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  RichText(
                    text: TextSpan(text: "宜：" + _dateInfo["dayYi"]),
                    textAlign: TextAlign.left,
                  ),
                  RichText(
                    text: TextSpan(text: "忌：" + _dateInfo["dayJi"]),
                    textAlign: TextAlign.left,
                  )
                ])))
      ],
    );
  }
}

class WriteContent extends StatelessWidget {
  const WriteContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(left: BorderSide(color: primaryColor, width: 2))),
      child: Flex(
        direction: Axis.vertical,
        children: [Expanded(flex: 1, child: TodoList(key: UniqueKey())), const Expanded(flex: 1, child: Text("小结"))],
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State {
  @override
  Widget build(BuildContext context) {
    return const Text('todolist ');
  }
}

const MaterialColor primaryColor = MaterialColor(
  0xFF5A7690,
  <int, Color>{
    50: Color(0xFFF9F9F9),
    100: Color(0xFF5A7690),
    200: Color(0xFF5A7690),
    300: Color(0xFF5A7690),
    400: Color(0xFF5A7690),
    500: Color(0xFF5A7690),
    600: Color(0xFF5A7690),
    700: Color(0xFF5A7690),
    800: Color(0xFF5A7690),
    900: Color(0xFF5A7690),
  },
);
