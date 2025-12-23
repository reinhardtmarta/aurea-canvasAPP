import 'package:flutter/material.dart';
import '../../core/copilot/copilot_engine.dart';
import '../../core/ui/copilot_ui_controller.dart';
import '../copilot/copilot_panel.dart';

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  late final CopilotEngine _engine;
  late final CopilotUIController _copilotController;

  @override
  void initState() {
    super.initState();

    _engine = CopilotEngine();
    _copilotController = CopilotUIController(_engine);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace'),
      ),
      body: Column(
        children: [
          // Canvas principal (placeholder por enquanto)
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              alignment: Alignment.center,
              child: const Text(
                'Canvas geométrico',
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ),

          // Copilot UI
          CopilotPanel(controller: _copilotController),
        ],
      ),
    );
  }
}
