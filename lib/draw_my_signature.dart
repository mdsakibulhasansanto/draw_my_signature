import 'dart:io';
import 'dart:ui' as ui;
import 'package:draw_my_signature/signature_painter.dart';
import 'package:flutter/material.dart';

class SignaturePad extends StatefulWidget {
  final Function(File file)? onSaved;
  final double width;
  final double height;
  final Color strokeColor;
  final double strokeWidth;
  final Color backgroundColor;

  const SignaturePad({
    super.key,
    this.onSaved,
    this.width = double.infinity,
    this.height = 200,
    this.strokeColor = Colors.black,
    this.strokeWidth = 3.0,
    this.backgroundColor = Colors.white,
  });

  @override
  SignaturePadState createState() => SignaturePadState();
}

class SignaturePadState extends State<SignaturePad> {

  final List<Offset?> _points = [];

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onPanDown: (details) => setState(() => _points.add(details.localPosition)),
      onPanUpdate: (details) => setState(() => _points.add(details.localPosition)),
      onPanEnd: (_) => _points.add(null),
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: SignaturePainter(_points, widget.strokeColor, widget.strokeWidth),
      ),
    );
  }



  void undoLastStroke() {
    setState(() {
      if (_points.isEmpty) return;

      int lastIndex = _points.lastIndexWhere((p) => p == null);
      if (lastIndex == -1) {
        _points.clear();
      } else {
        _points.removeRange(lastIndex, _points.length);
      }
    });
  }

  void clear() {
    setState(() {
      _points.clear();
    });
  }


  Future<File?> save() async {
    if (_points.isEmpty) return null;

    try {

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint()
        ..color = widget.strokeColor
        ..strokeCap = StrokeCap.round
        ..strokeWidth = widget.strokeWidth;

      canvas.drawColor(widget.backgroundColor, BlendMode.src);

      for (int i = 0; i < _points.length - 1; i++) {
        if (_points[i] != null && _points[i + 1] != null) {
          canvas.drawLine(_points[i]!, _points[i + 1]!, paint);
        }
      }

      final width = widget.width.isFinite ? widget.width : MediaQuery.of(context).size.width;
      final height = widget.height.isFinite ? widget.height : 200.0;

      final picture = recorder.endRecording();
      final img = await picture.toImage(width.toInt(), height.toInt());

      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final bytes = byteData.buffer.asUint8List();
      final file = File('${Directory.systemTemp.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);

      widget.onSaved?.call(file);
      return file;

    } catch (e) {
      print('Error saving signature: $e');
      return null;
    }
  }


}

