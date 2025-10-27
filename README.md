# draw_my_signature

[![pub package](https://img.shields.io/pub/v/draw_my_signature.svg)](https://pub.dev/packages/draw_my_signature)

A Flutter plugin providing a customizable signature pad widget with the ability
to set stroke color, stroke width, background color, and save signatures as PNG images.  
This is a native Flutter implementation, so it supports all platforms.

## Why

At the time of creating this package, there was no available solution that had:

- Smooth and performance-optimized drawing on a wide range of devices  
- Undo and clear functionality  
- Easy save as PNG and preview  
- Fully customizable appearance and size  

## Usage

To use this plugin, add `draw_my_signature` as a
[dependency in your `pubspec.yaml` file](https://pub.dev/packages/draw_my_signature).

### Example

Here is a full example using the `HomePage` widget:

```dart
import 'dart:io';
import 'package:draw_my_signature/draw_my_signature.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<SignaturePadState> _signatureKey = GlobalKey<SignaturePadState>();
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text('Draw My Signature'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SignaturePad(
                  key: _signatureKey,
                  height: 200,
                  strokeColor: Colors.black,
                  strokeWidth: 3,
                  backgroundColor: Colors.grey[100]!,
                  onSaved: (savedFile) {
                    setState(() => file = savedFile);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Saved to: ${savedFile.path}')),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _signatureKey.currentState?.undoLastStroke(),
                    child: const Text('Undo', style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () => _signatureKey.currentState?.clear(),
                    child: const Text('Clear', style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () => _signatureKey.currentState?.save(),
                    child: const Text('Save', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (file != null) Image.file(file!, height: 150),
            ],
          ),
        ),
      ),
    );
  }
}

## Example Preview

Here’s how the signature pad looks in action 👇

![Example Screenshot](https://raw.githubusercontent.com/mdsakibulhasansanto/draw_my_signature/main/example/example.jpg)

