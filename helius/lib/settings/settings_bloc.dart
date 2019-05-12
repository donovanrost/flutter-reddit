import 'package:bloc/bloc.dart';
import 'package:helius/settings/settings_event.dart';
import 'package:helius/settings/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  // @override
  // SettingsState get initialState =>
  //     SettingsState(temperatureUnits: TemperatureUnits.celsius);
    @override
  // TODO: implement initialState
  SettingsState get initialState => null;

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    // if (event is TemperatureUnitsToggled) {
    //   yield SettingsState(
    //     temperatureUnits:
    //         currentState.temperatureUnits == TemperatureUnits.celsius
    //             ? TemperatureUnits.fahrenheit
    //             : TemperatureUnits.celsius,
    //   );
    // }
  }


}