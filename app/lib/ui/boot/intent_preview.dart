import 'package:flutter/material.dart';
import '../../core/boot/boot_intent.dart';

class _IntentPreview extends StatelessWidget {
  final BootIntent intent;

  const _IntentPreview(this.intent);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Intent: ${intent.type.name}'
        '${intent.targetFormat != null ? ' → ${intent.targetFormat}' : ''}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
