/*import 'package:flutter/material.dart';

class CommentBox extends StatefulWidget {
  final Widget image;
  final TextEditingController controller;
  final BorderRadius inputRadius;
  final Function onSend;
  final Function onImageRemoved;

  CommentBox(
    this.image,
    this.controller,
    this.inputRadius,
    this.onSend,
    this.onImageRemoved,
  );

  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  late Widget image;

  @override
  void initState() {
    image = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          height: 1,
          color: Colors.grey[300],
          thickness: 1,
        ),
        const SizedBox(height: 20),
        if (image != null)
          _removable(
            context,
            _imageView(context),
          ),
        if (widget.controller != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: widget.controller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    if (widget.onSend != null) {
                      widget.onSend();
                    }
                  },
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: widget.inputRadius ?? BorderRadius.circular(32),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _removable(BuildContext context, Widget child) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        child,
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              image =
                  const SizedBox(); // You can set it to an empty SizedBox or any other suitable widget.
              if (widget.onImageRemoved != null) {
                widget.onImageRemoved();
              }
            });
          },
        ),
      ],
    );
  }

  Widget _imageView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: image,
      ),
    );
  }
}*/
