import '/data/dummy_data.dart';

import '../model/ride/locations.dart';
import '../model/ride/ride.dart';

////
///   This service handles:
///   - The list of available rides
///
class LocationsService {
  static const List<Location> availableLocations =
      fakeLocations; // TODO for now fake data

  static List<Ride> filterByDeparture(Location departure){
    return fakeRides.where((ride) => ride.departureLocation == departure).toList();
  }

  static List<Ride> filterBySeatRequested(int seatRequested){
    return fakeRides.where((ride) => ride.availableSeats >= seatRequested).toList();
  }

  static List<Ride> filterBy({Location? departure, int? seatRequested}){
    return fakeRides.where((ride) {
      final matchDeparture = departure == null || ride.departureLocation == departure;
      final matchSeat = seatRequested == null || ride.availableSeats >= seatRequested;
      return matchDeparture && matchSeat;
    }).toList();
  }
}
