import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Widget? tearDropImage; // Make the tearDropImage optional

  const CustomButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.tearDropImage, // Add the tearDropImage parameter
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isHovered = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return _buildButton();
  }

  Widget _buildButton() {
    Color baseColor = const Color.fromARGB(255, 1, 158, 140);
    Color hoverColor = baseColor.withOpacity(0.8);
    Color pressColor = baseColor.withOpacity(0.6);

    return GestureDetector(
      onTap: () => _handlePress(true),
      onTapUp: (_) => _handlePress(false),
      onTapCancel: () => _handlePress(false),
      child: MouseRegion(
        onHover: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isPressed ? pressColor : (isHovered ? hoverColor : baseColor),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.tearDropImage !=
                  null) // Check if tearDropImage is provided
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.8), // Lighter background color
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: widget.tearDropImage,
                    ),
                  ),
                ),
              Center(
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleHover(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }

  void _handlePress(bool isPressed) {
    setState(() {
      this.isPressed = isPressed;
    });

    if (isPressed) {
      widget.onPressed();
    }
  }
}
