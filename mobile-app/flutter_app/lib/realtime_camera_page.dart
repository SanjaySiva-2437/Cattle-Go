import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class RealtimeCameraPage extends StatefulWidget {
  const RealtimeCameraPage({super.key});

  @override
  _RealtimeCameraPageState createState() => _RealtimeCameraPageState();
}

class _RealtimeCameraPageState extends State<RealtimeCameraPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

  // Store full prediction data
  Map<String, dynamic>? _predictionData;

  final String _realtimeApiUrl =
      'https://superstrenuous-marcelina-overeffusively.ngrok-free.dev/predict-frame';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _controller!.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });

      _controller!.startImageStream((CameraImage image) {
        if (!_isProcessing) {
          _isProcessing = true;
          _processCameraImage(image);
        }
      });
    }
  }

  img.Image _convertCameraImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel!;

    final yPlane = image.planes[0].bytes;
    final uPlane = image.planes[1].bytes;
    final vPlane = image.planes[2].bytes;

    final img.Image imageConverted = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex =
            uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;

        final int yp = yPlane[index];
        final int up = uPlane[uvIndex];
        final int vp = vPlane[uvIndex];

        final int r = (yp + 1.402 * (vp - 128)).round().clamp(0, 255);
        final int g = (yp - 0.344136 * (up - 128) - 0.714136 * (vp - 128))
            .round()
            .clamp(0, 255);
        final int b = (yp + 1.772 * (up - 128)).round().clamp(0, 255);

        imageConverted.setPixelRgba(x, y, r, g, b, 255);
      }
    }

    return imageConverted;
  }

  Future<void> _processCameraImage(CameraImage image) async {
    try {
      final img.Image convertedImage = _convertCameraImage(image);
      final img.Image resized = img.copyResize(convertedImage, width: 256, height: 256);

      // Compress for upload
      final List<int> jpegBytes = img.encodeJpg(resized, quality: 75);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(_realtimeApiUrl),
      );

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        jpegBytes,
        filename: 'frame.jpg',
      ));

      final response = await request.send().timeout(const Duration(seconds: 10));
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        if (mounted) {
          setState(() {
            _predictionData = data;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _predictionData = {
              'message': "Server Error: ${response.statusCode}"
            };
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _predictionData = {'message': 'Connection Error'};
        });
      }
    } finally {
      if (mounted) _isProcessing = false;
    }
  }

  @override
  void dispose() {
    _controller?.stopImageStream();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized || _controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Optional: compute confidence as percentage for a progress bar
    double confidencePercent = 0.0;
    if (_predictionData != null && _predictionData!['confidence'] != null) {
      confidencePercent = (_predictionData!['confidence'] as double).clamp(0.0, 1.0);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Real-time Analysis')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _predictionData?['message'] ?? "Point at cattle...",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  // Optional: confidence bar
                  LinearProgressIndicator(
                    value: confidencePercent,
                    minHeight: 8,
                    backgroundColor: Colors.grey[700],
                    color: Colors.greenAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
