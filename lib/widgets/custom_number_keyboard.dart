import 'package:flutter/material.dart';
import 'package:extended_keyboard/extended_keyboard.dart';

class CustomNumberKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onBackspace;
  final VoidCallback onConfirm;
  final bool isVisible;

  const CustomNumberKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.onBackspace,
    required this.onConfirm,
    this.isVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isVisible ? 300 : 0,
      child: isVisible
          ? Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  _buildRow(['1', '2', '3']),
                  _buildRow(['4', '5', '6']),
                  _buildRow(['7', '8', '9']),
                  Row(
                    children: [
                      Expanded(
                        child: _buildKey('0'),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: onBackspace,
                          icon: const Icon(Icons.backspace),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text('确定'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildRow(List<String> keys) {
    return Expanded(
      child: Row(
        children: keys.map((key) => _buildKey(key)).toList(),
      ),
    );
  }

  Widget _buildKey(String key) {
    return Expanded(
      child: TextButton(
        onPressed: () => onKeyPressed(key),
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Text(
          key,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
