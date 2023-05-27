import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testapp/model/message.dart';
import 'package:testapp/provider/provider.dart';
import 'package:testapp/screens/chat/widgets/message_widget.dart';
import 'package:testapp/services/firebase_api.dart';

class MessagesWidget extends ConsumerStatefulWidget {
  final String idUser;

  const MessagesWidget({
    required this.idUser,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends ConsumerState<MessagesWidget> {
  Map<String, dynamic> data = {};
  @override
  void initState() {
    setValues();
    super.initState();
  }

  setValues() {
    data = ref.read(userProvider).userData;
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot>(
      stream: FirbaseApi().getChatMessage(
        data['mobile'],
      ),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Message> listMessages = [];
        if (snapshot.hasData) {
          snapshot.data?.docs.forEach(
            (element) {
              listMessages.add(Message.fromJson(
                element.data() as Map<String, dynamic>,
              ));
            },
          );

          if (listMessages.isNotEmpty) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              reverse: true,
              itemCount: listMessages.length,
              itemBuilder: (context, index) {
                final message = listMessages[index];

                return MessageWidget(
                  message: message,
                  isMe: message.idUser == data['mobile'],
                );
              },
            );
          } else {
            return buildText('No Chat Yet');
          }
        }
        return SizedBox();
      }

      // switch (snapshot.connectionState) {
      //   case ConnectionState.waiting:
      //     return const Center(child: CircularProgressIndicator());
      //   default:
      //     // if (snapshot.hasError) {
      //     //   return buildText('Something Went Wrong Try later');
      //     // } else {
      //     //   final messages = snapshot.data;

      //     //   return messages!.isEmpty
      //     //       ? buildText('Say Hi..')
      // : ListView.builder(
      //     physics: const BouncingScrollPhysics(),
      //     reverse: true,
      //     itemCount: messages.length,
      //     itemBuilder: (context, index) {
      //       final message = messages[index];

      //       return MessageWidget(
      //         message: message,
      //         isMe: message.idUser == data['mobile'],
      //       );
      //     },
      //   );
      //     // }
      // }

      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      );
}
