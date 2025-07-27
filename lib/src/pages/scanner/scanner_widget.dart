import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Overlay personalizado para el escáner: esquinas tipo Google Pay/Pix
class ScannerOverlay extends StatelessWidget {
  final double size;
  final double borderRadius;
  final double borderLength;
  final double borderWidth;
  final Color borderColor;

  const ScannerOverlay({
    Key? key,
    this.size = 250,
    this.borderRadius = 24,
    this.borderLength = 35,
    this.borderWidth = 5,
    this.borderColor = Colors.greenAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ScannerOverlayPainter(
        borderRadius: borderRadius,
        borderLength: borderLength,
        borderWidth: borderWidth,
        borderColor: borderColor,
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double borderRadius;
  final double borderLength;
  final double borderWidth;
  final Color borderColor;

  _ScannerOverlayPainter({
    required this.borderRadius,
    required this.borderLength,
    required this.borderWidth,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = borderColor
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // Esquinas - arriba izquierda
    canvas.drawLine(Offset(0, borderRadius), Offset(0, borderLength), paint);
    canvas.drawLine(Offset(borderRadius, 0), Offset(borderLength, 0), paint);

    // Esquinas - arriba derecha
    canvas.drawLine(
      Offset(size.width, borderRadius),
      Offset(size.width, borderLength),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - borderRadius, 0),
      Offset(size.width - borderLength, 0),
      paint,
    );

    // Esquinas - abajo izquierda
    canvas.drawLine(
      Offset(0, size.height - borderRadius),
      Offset(0, size.height - borderLength),
      paint,
    );
    canvas.drawLine(
      Offset(borderRadius, size.height),
      Offset(borderLength, size.height),
      paint,
    );

    // Esquinas - abajo derecha
    canvas.drawLine(
      Offset(size.width, size.height - borderRadius),
      Offset(size.width, size.height - borderLength),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - borderRadius, size.height),
      Offset(size.width - borderLength, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Recorta el área central para dejar ver la cámara y oscurecer el resto
class _ScannerAreaClipper extends CustomClipper<Path> {
  final double area;
  _ScannerAreaClipper(this.area);

  @override
  Path getClip(Size size) {
    Path path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    double dx = (size.width - area) / 2;
    double dy = (size.height - area) / 2;
    path.addRect(Rect.fromLTWH(dx, dy, area, area));
    return Path.combine(PathOperation.difference, path, Path());
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}

// Widget principal con MobileScanner y overlay profesional
class ScannerWidget extends StatefulWidget {
  final Function(String) onCodeRead;

  const ScannerWidget({Key? key, required this.onCodeRead}) : super(key: key);

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  String? currentCode; // Último código leído
  String? previousCode; // Código previo

  void _onDetect(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      setState(() {
        previousCode = currentCode; // Guarda el anterior (si existe)
        currentCode = barcodes.first.rawValue!; // Actualiza con el nuevo
      });
      widget.onCodeRead(barcodes.first.rawValue!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MobileScannerController controller = MobileScannerController(
      formats: [BarcodeFormat.all], // Así acepta QR y 1D/2D
    );
    return Stack(
      children: [
        MobileScanner(controller: controller, onDetect: _onDetect),

        // Sombra exterior semi-transparente
        Container(color: Colors.black.withOpacity(0.4)),
        // Visor centrado transparente
        Center(
          child: ClipPath(
            clipper: _ScannerAreaClipper(250),
            child: Container(
              width: 250,
              height: 250,
              color: Colors.transparent,
            ),
          ),
        ),
        // Overlay de esquinas profesionales
        Center(
          child: ScannerOverlay(
            size: 250,
            borderRadius: 24,
            borderLength: 40,
            borderWidth: 6,
            borderColor: Colors.greenAccent,
          ),
        ),
        // Mostrar los códigos (actual y anterior) en la parte superior
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentCode != null)
                  Container(
                    margin: const EdgeInsets.only(top: 18),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Código leído: $currentCode',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (previousCode != null)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Anterior: $previousCode',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
