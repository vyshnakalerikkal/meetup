import 'package:flutter/material.dart';
import 'package:testapp/model/userModel.dart';
import 'package:testapp/screens/chat/widgets/messages_widget.dart';
import 'package:testapp/screens/chat/widgets/new_message_widget.dart';
import 'package:testapp/screens/chat/widgets/profile_header_widget.dart';
import 'package:testapp/theme/colors.dart';

class ChatPage extends StatefulWidget {
  final UserModel user;

  const ChatPage({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: Column(
            children: [
              ProfileHeaderWidget(name: widget.user.name.toString()),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: MessagesWidget(idUser: widget.user.mobile.toString()),
                ),
              ),
              NewMessageWidget(idUser: widget.user.mobile.toString())
            ],
          ),
        ),
      );
}
