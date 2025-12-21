import 'package:flutter/material.dart';
import 'boot_controller.dart';
import '../../core/boot/boot_intent.dart';

class BootInput extends StatefulWidget {
  const BootInput({super.key});

  @override
  State<BootInput> createState() => _BootInputState();
}

class _BootInputState extends State<BootInput> {
  final _controller = TextEditingController();
  final _boot = BootController();

  BootIntent? intent;

  void _onSubmit(String value) {
    setState(() {
      intent = _boot.handleInput(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          onSubmitted: _onSubmit,
          decoration: const InputDecoration(
            hintText: 'Peça algo ao boot…',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        if (intent != null) _IntentPreview(intent!),
      ],
    );
  }
}
