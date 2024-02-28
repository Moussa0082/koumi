import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:koumi_app/models/MessageWa.dart';
import 'package:koumi_app/service/MessageService.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _NotificationPageState extends State<NotificationPage> {
  late TextEditingController _searchController;
  List<MessageWa> messageList = [];

  @override
  Widget build(BuildContext context) {
    return FloatingDraggableWidget(
      mainScreenWidget: Scaffold(
          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 100,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
            title: Text(
              "Notifications",
              style:
                  TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
               Consumer(builder: (context, messageService, child) {
                return FutureBuilder(
                    future: MessageService().fetchMessage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        );
                      }

                      if (!snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("0",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              )),
                        );
                      } else {
                        messageList = snapshot.data!;
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            messageList.length.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        );
                      }
                    });
              })
            ]),
          )), // Replace YourMainScreenWidget() with your actual main screen widget
      floatingWidget: FloatingActionButton(
        backgroundColor: d_colorGreen,
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingWidgetHeight: 60,
      floatingWidgetWidth: 60,
      dx: 330,
      dy: 700,
    );
  }
}
