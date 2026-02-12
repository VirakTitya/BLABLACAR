import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// A versatile button used across the app.
///
/// Supports primary (filled) and secondary (outline) styles,
/// optional leading icon, disabled state and a full width option.
class BlaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool primary;
  final IconData? icon;
  final bool disabled;
  final double? height;
  final bool fullWidth;

  const BlaButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.primary = true,
    this.icon,
    this.disabled = false,
    this.height = 48,
    this.fullWidth = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = disabled || onPressed == null;

    final BorderRadius borderRadius = BorderRadius.circular(BlaSpacings.radius);

    if (primary) {
      return SizedBox(
        width: fullWidth ? double.infinity : null,
        height: height,
        child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDisabled ? BlaColors.disabled : BlaColors.primary,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: BlaSpacings.m),
            textStyle: BlaTextStyles.button,
          ),
          child: _buildChild(),
        ),
      );
    }

    // Secondary (outline) style
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDisabled ? BlaColors.disabled : BlaColors.primary,
          side: BorderSide(color: isDisabled ? BlaColors.disabled : BlaColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: const EdgeInsets.symmetric(horizontal: BlaSpacings.m),
          textStyle: BlaTextStyles.button,
        ),
        child: _buildChild(iconColor: isDisabled ? BlaColors.disabled : BlaColors.primary),
      ),
    );
  }

  Widget _buildChild({Color? iconColor}) {
    final List<Widget> children = [];
    if (icon != null) {
      children.add(Icon(icon, size: 18, color: iconColor ?? BlaColors.white));
      children.add(const SizedBox(width: 10));
    }

    children.add(Text(label, style: BlaTextStyles.button.copyWith(color: primary ? BlaColors.white : (iconColor ?? BlaColors.primary))));

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
