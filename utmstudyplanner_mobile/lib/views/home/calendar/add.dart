import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarEvent extends StatefulWidget {
  const CalendarEvent({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _CalendarEventPageState createState() => _CalendarEventPageState();
}



class _CalendarEventPageState extends State<CalendarEvent> {
  final titleInput = TextEditingController();
  final dateBeforeInput = TextEditingController();
  final dateAfterInput = TextEditingController();
  final timeBeforeInput = TextEditingController();
  final timeAfterInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(93, 6, 29, 1.0),
        title: const Text('Add Event'),
      ),
      body: CustomScrollView( // main content
        slivers: <Widget>[
          //Todo List Section
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextFormField(controller: titleInput,
                          style: const TextStyle(fontSize: 24),
                          textInputAction: TextInputAction.next,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 20, right: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              hintText: "Add title",
                              fillColor: Colors.white)
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: TextFormField(
                            controller: dateBeforeInput,
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final DateTime? selectedDate = await showDatePicker(context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(0),
                                  lastDate: DateTime(9999));
                              dateBeforeInput.text = DateFormat.yMMMEd().format(selectedDate!);
                            },

                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20),
                                hintText: DateFormat.yMMMEd().format(DateTime.now()),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white
                            ),
                          )
                      ),

                      Expanded(
                        child: TextFormField(
                          controller: timeBeforeInput,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final TimeOfDay? selectedTime = await showTimePicker(context: context,
                                initialTime: TimeOfDay.now()
                            );

                            DateTime formattedTime(TimeOfDay today){
                              final newTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, today.hour, today.minute);
                              return newTime;
                            }
                            timeBeforeInput.text = DateFormat.jm().format(formattedTime(selectedTime!));
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 20, right: 20),
                              hintText: DateFormat.jm().format(DateTime.now()),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: TextFormField(
                            controller: dateAfterInput,
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final DateTime? selectedDate = await showDatePicker(context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(0),
                                  lastDate: DateTime(9999));
                              dateAfterInput.text = DateFormat.yMMMEd().format(selectedDate!);
                            },

                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20),
                                hintText: DateFormat.yMMMEd().format(DateTime.now()),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white
                            ),
                          )
                      ),

                      Expanded(
                        child: TextFormField(
                          controller: timeAfterInput,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final TimeOfDay? selectedTime = await showTimePicker(context: context,
                                initialTime: TimeOfDay.now()
                            );

                            DateTime formattedTime(TimeOfDay today){
                              final newTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, today.hour, today.minute);
                              return newTime;
                            }
                            timeAfterInput.text = DateFormat.jm().format(formattedTime(selectedTime!));
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 20, right: 20),
                              hintText: DateFormat.jm().format(DateTime.now().add(const Duration(hours: 2))),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      MaterialButton(
                          onPressed: (){


                          },
                          child:
                          const Text("Submit",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue
                            ),)
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}