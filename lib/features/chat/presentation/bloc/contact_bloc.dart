import 'package:chat/features/chat/data/remote_data_source/contact_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactApi _service;

  ContactBloc(this._service) : super(ContactState.initial()) {
    on<LoadContacts>(_onLoadContacts);
  }

  Future<void> _onLoadContacts(
      LoadContacts event, Emitter<ContactState> emit) async {
    emit(state.copyWith(status: ContactStatus.loading));
    try {
      final contacts = await _service.fetchContacts();
      emit(state.copyWith(status: ContactStatus.loaded, contacts: contacts));
    } catch (e) {
      emit(state.copyWith(
          status: ContactStatus.error, errorMessage: e.toString()));
    }
  }
}
