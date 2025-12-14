import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/user_profile_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadInitialProfile>(_loadInitial);
    on<UpdateBasicInfo>(_updateBasic);
    on<UpdateAddress>(_updateAddress);
    on<UpdatePayment>(_updatePayment);
  }

  void _loadInitial(
      LoadInitialProfile event, Emitter<ProfileState> emit) {
    emit(
      ProfileLoaded(
        UserProfileModel(
          name: event.name,
          email: event.email,
          phone: '',
          address: '',
          cardNumber: '',
          cardHolder: '',
          expiryDate: '',
        ),
      ),
    );
  }

  void _updateBasic(
      UpdateBasicInfo event, Emitter<ProfileState> emit) {
    final current = (state as ProfileLoaded).profile;
    emit(ProfileLoaded(
      current.copyWith(name: event.name, phone: event.phone),
    ));
  }

  void _updateAddress(
      UpdateAddress event, Emitter<ProfileState> emit) {
    final current = (state as ProfileLoaded).profile;
    emit(ProfileLoaded(current.copyWith(address: event.address)));
  }

  void _updatePayment(
      UpdatePayment event, Emitter<ProfileState> emit) {
    final current = (state as ProfileLoaded).profile;
    emit(
      ProfileLoaded(
        current.copyWith(
          cardNumber: event.cardNumber,
          cardHolder: event.cardHolder,
          expiryDate: event.expiryDate,
        ),
      ),
    );
  }
}
