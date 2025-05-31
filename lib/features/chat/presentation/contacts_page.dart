import 'package:chat/features/chat/data/remote_data_source/contact_api.dart';
import 'package:chat/features/chat/presentation/bloc/contact_event.dart';
import 'package:chat/features/message/data/remote_data_source/chat_api.dart';
import 'package:chat/features/message/presentation/chat_page.dart';
import 'package:chat/utils/widgets/app_background.dart';
import 'package:chat/utils/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../message/presentation/bloc/chat_bloc.dart';
import 'bloc/contact_bloc.dart';
import 'bloc/contact_state.dart';

class ContactsPage extends StatefulWidget {
  final String userToken;
  const ContactsPage({super.key, required this.userToken});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late ContactBloc _chatBloc;

  @override
  void initState() {
    super.initState();

    _chatBloc = ContactBloc(
      ContactApi(userToken: widget.userToken),
    );

    _chatBloc.add(LoadContacts());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider.value(
        value: _chatBloc,
        child: AppBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('مخاطبین'),
              centerTitle: true,
            ),
            body: BlocBuilder<ContactBloc, ContactState>(
              builder: (context, state) {
                if (state.status == ContactStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == ContactStatus.error) {
                  return Center(child: Text(state.errorMessage ?? 'خطا'));
                }
                if (state.contacts.isEmpty) {
                  return const Center(child: Text('مخاطبی یافت نشد'));
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                    itemCount: state.contacts.length,
                    itemBuilder: (context, index) {
                      final contact = state.contacts[index];
                      final String firstLetter = contact.name.substring(0, 1);
                      return Column(
                        children: [
                          ListTile(
                            leading: Avatar(firstLetter: firstLetter),
                            title: Text(
                              contact.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: const Text(
                              'هنوز پیامی ارسال نکرده‌اید...',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13),
                            ),
                            trailing: const Text(
                              'هیچ‌گاه',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (_) => ChatBloc(ChatApi(
                                        userToken: widget.userToken,
                                        contactToken: contact.contactToken)),
                                    child: ChatPage(
                                        userToken: widget.userToken,
                                        contact: contact),
                                  ),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 0, thickness: 0.5),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
