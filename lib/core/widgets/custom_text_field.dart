import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputAction textInputAction;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1a1c1c),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          maxLines: _obscureText ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          style: GoogleFonts.manrope(
            fontSize: 16,
            color: const Color(0xFF1a1c1c),
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: const Color(0xFF8c7071))
                : null,
            suffixIcon: widget.obscureText
                ? GestureDetector(
                    onTap: _toggleObscureText,
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF8c7071),
                    ),
                  )
                : widget.suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.prefixIcon != null ? 12 : 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
