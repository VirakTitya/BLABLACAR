import 'package:flutter/material.dart';

import '../../../../model/ride/locations.dart';
import '../../../../data/dummy_data.dart';
import '../../../../model/ride_pref/ride_pref.dart';

///
/// A Ride Preference From is a view to select:
///   - A depcarture location
///   - An arrival location
///   - A date
///   - A number of seats
///
/// The form can be created with an existing RidePref (optional).
///
class RidePrefForm extends StatefulWidget {
  // The form can be created with an optional initial RidePref.
  final RidePref? initRidePref;
  // Optional callback used when the form is submitted. If null, the form
  // will pop the Navigator with the resulting RidePref.
  final ValueChanged<RidePref>? onSearch;

  const RidePrefForm({super.key, this.initRidePref, this.onSearch});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  late DateTime departureDate;
  Location? arrival;
  late int requestedSeats;

  // ----------------------------------
  // Initialize the Form attributes
  // ----------------------------------

  @override
  void initState() {
    super.initState();
    // Initialize from provided RidePref or use sensible defaults.
    if (widget.initRidePref != null) {
      departure = widget.initRidePref!.departure;
      arrival = widget.initRidePref!.arrival;
      departureDate = widget.initRidePref!.departureDate;
      requestedSeats = widget.initRidePref!.requestedSeats;
    } else {
      departure = null;
      arrival = null;
      departureDate = DateTime.now();
      requestedSeats = 1;
    }
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------

  // ----------------------------------
  // Compute the widgets rendering
  // ----------------------------------

  // ----------------------------------
  // Build the widgets
  // ----------------------------------
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [ 
        // Departure
        ListTile(
          leading: const Icon(Icons.radio_button_checked),
          title: Text(departure?.name ?? 'Choose departure'),
          subtitle: departure != null ? Text(departure!.country.name) : null,
          trailing: IconButton(
            icon: const Icon(Icons.swap_vert),
            onPressed: _switchLocations,
            tooltip: 'Switch locations',
          ),
          onTap: () => _pickLocation(context, isDeparture: true),
        ),

        const Divider(height: 1),

        // Arrival
        ListTile(
          leading: const Icon(Icons.location_on_outlined),
          title: Text(arrival?.name ?? 'Choose arrival'),
          subtitle: arrival != null ? Text(arrival!.country.name) : null,
          onTap: () => _pickLocation(context, isDeparture: false),
        ),

        const Divider(height: 1),

        // Date
        ListTile(
          leading: const Icon(Icons.calendar_today_outlined),
          title: Text(_formatDate(departureDate)),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: departureDate,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
            );
            if (picked != null) setState(() => departureDate = picked);
          },
        ),

        const Divider(height: 1),

        // Seats
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Seats'),
          trailing: DropdownButton<int>(
            value: requestedSeats,
            items: List.generate(6, (i) => i + 1)
                .map((s) => DropdownMenuItem(value: s, child: Text('$s')))
                .toList(),
            onChanged: (v) {
              if (v == null) return;
              setState(() => requestedSeats = v);
            },
          ),
        ),

        const SizedBox(height: 12),

        // Search button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _onSearchPressed,
            child: const Text('Search', style: TextStyle(color: Colors.white)),
          ),
        ),

      ]);
  }

  // -------------------------
  // Helpers
  // -------------------------

  String _formatDate(DateTime d) {
    // Simple dd MMM formatting (e.g. 14 Feb)
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  Future<void> _pickLocation(BuildContext context, {required bool isDeparture}) async {
    // Use fake locations from dummy data for the picker.
    final sample = fakeLocations;

    final picked = await showModalBottomSheet<Location>(
      context: context,
      builder: (ctx) => ListView.separated(
        shrinkWrap: true,
        itemBuilder: (c, i) {
          final loc = sample[i];
          return ListTile(
            title: Text(loc.name),
            subtitle: Text(loc.country.name),
            onTap: () => Navigator.of(ctx).pop(loc),
          );
        },
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemCount: sample.length,
      ),
    );

    if (picked == null) return;
    setState(() {
      if (isDeparture) {
        departure = picked;
      } else {
        arrival = picked;
      }
    });
  }

  void _switchLocations() {
    setState(() {
      final tmp = departure;
      departure = arrival;
      arrival = tmp;
    });
  }

  void _onSearchPressed() {
    if (departure == null || arrival == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select both locations.')));
      return;
    }

    final pref = RidePref(
      departure: departure!,
      arrival: arrival!,
      departureDate: departureDate,
      requestedSeats: requestedSeats,
    );

    if (widget.onSearch != null) {
      widget.onSearch!(pref);
    } else {
      Navigator.of(context).pop(pref);
    }
  }
}
