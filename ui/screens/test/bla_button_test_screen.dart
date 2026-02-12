import 'package:flutter/material.dart';
import '../../widgets/inputs/bla_button.dart';

class BlaButtonTestScreen extends StatelessWidget {
  const BlaButtonTestScreen({Key? key}) : super(key: key);

  void _showToast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BlaButton Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text('Primary (filled)', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            BlaButton(
              label: 'Request to book',
              icon: Icons.event_available,
              onPressed: () => _showToast(context, 'Primary pressed'),
            ),

            const SizedBox(height: 20),
            const Text('Primary - no icon', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            BlaButton(
              label: 'Contact Volodia',
              primary: true,
              onPressed: () => _showToast(context, 'Contact pressed'),
            ),

            const SizedBox(height: 20),
            const Text('Secondary (outline)', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            BlaButton(
              label: 'View details',
              primary: false,
              icon: Icons.info_outline,
              onPressed: () => _showToast(context, 'Secondary pressed'),
            ),

            const SizedBox(height: 20),
            const Text('Disabled states', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            BlaButton(
              label: 'Disabled primary',
              onPressed: null,
            ),

            const SizedBox(height: 12),
            BlaButton(
              label: 'Disabled secondary',
              primary: false,
              onPressed: null,
            ),

            const SizedBox(height: 20),
            const Text('Compact / not full width', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: BlaButton(
                    label: 'Full width',
                    icon: Icons.send,
                    onPressed: () => _showToast(context, 'Full width'),
                    fullWidth: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                BlaButton(
                  label: 'Compact',
                  icon: Icons.star,
                  fullWidth: false,
                  onPressed: () => _showToast(context, 'Compact'),
                ),
                const SizedBox(width: 12),
                BlaButton(
                  label: 'Compact 2',
                  primary: false,
                  fullWidth: false,
                  onPressed: () => _showToast(context, 'Compact 2'),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
