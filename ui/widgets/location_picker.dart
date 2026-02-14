import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../model/ride/locations.dart';

/// A reusable location picker widget.
///
/// Use this widget inside a modal bottom sheet and it returns the selected
/// `Location` via `Navigator.pop`.
class LocationPicker extends StatefulWidget {
  final Location? initialLocation;
  final List<Location>? locations;

  const LocationPicker({super.key, this.initialLocation, this.locations});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late List<Location> _data;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _data = widget.locations ?? fakeLocations;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? _data
        : _data.where((l) => l.name.toLowerCase().contains(_query.toLowerCase())).toList();

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search a city',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      isDense: true,
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    if (_query.isEmpty) Navigator.of(context).pop();
                    setState(() => _query = '');
                  },
                )
              ],
            ),
          ),
          const Divider(height: 1),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final loc = filtered[i];
                return ListTile(
                  leading: widget.initialLocation != null && widget.initialLocation == loc
                      ? const Icon(Icons.radio_button_checked)
                      : const Icon(Icons.location_on_outlined),
                  title: Text(loc.name),
                  subtitle: Text(loc.country.name),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).pop(loc),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
