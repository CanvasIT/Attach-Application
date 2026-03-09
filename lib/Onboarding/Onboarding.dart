import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Colour tokens (from Figma spec) ──────────────────────────
const Color kNavy      = Color(0xFF071951);
const Color kNavyDark  = Color(0xFF001B60);
const Color kBtnBlue   = Color(0xFF374D69);
const Color kEllipse1  = Color(0xFFA1AED0);
const Color kBorder    = Color(0xFFDFE3E8);
const Color kTextTitle = Color(0xFF071951);
const Color kTextSub   = Color(0xFF637381);
const Color kHomebar   = Color(0xFF212B36);
const Color kWhite     = Color(0xFFFFFFFF);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const AttachApp());
}

class AttachApp extends StatelessWidget {
  const AttachApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Onboarding25Page(),
      );
}

class Onboarding25Page extends StatelessWidget {
  const Onboarding25Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        // ── Screen: 375 × 812 ──────────────────────────────
        child: SizedBox(
          width: 375,
          height: 812,
          child: Stack(
            children: [

              // ── ELLIPSE 1  #A1AED0 ──────────────────────
              // w:807.83  h:698.63  left:-382.29  top:-427.57
              // matrix(-0.37, 0.93, -0.93, 0.37, 0, 0)
              Positioned(
                left:  -382.29,
                top:   -427.57,
                child: Transform(
                  transform: Matrix4(
                    -0.37,  0.93, 0, 0,
                    -0.93,  0.37, 0, 0,
                     0,     0,   1, 0,
                     0,     0,   0, 1,
                  ),
                  child: Container(
                    width:  807.83,
                    height: 698.63,
                    decoration: const BoxDecoration(
                      color: kEllipse1,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              // ── ELLIPSE 2  #071951 ──────────────────────
              // w:807.83  h:698.63  left:-441  top:-423
              // matrix(-0.37, 0.93, -0.93, 0.37, 0, 0)
              Positioned(
                left:  -441,
                top:   -423,
                child: Transform(
                  transform: Matrix4(
                    -0.37,  0.93, 0, 0,
                    -0.93,  0.37, 0, 0,
                     0,     0,   1, 0,
                     0,     0,   0, 1,
                  ),
                  child: Container(
                    width:  807.83,
                    height: 698.63,
                    decoration: const BoxDecoration(
                      color: kNavy,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              // ── ARCH FRAME  left:62  top:38 ─────────────
              // w:251  h:374
              // border: 10px solid #001B60
              // borderRadius: 120 120 50 50
              Positioned(
                left: (375 - 251) / 2,   // = 62  (centred)
                top:  38,
                child: Container(
                  width:  251,
                  height: 374,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2F9),
                    border: Border.all(color: kNavyDark, width: 10),
                    borderRadius: const BorderRadius.only(
                      topLeft:     Radius.circular(120),
                      topRight:    Radius.circular(120),
                      bottomLeft:  Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: const _HandshakeIllustration(),
                ),
              ),

              // ── STATUS BAR  h:38  top:0 ─────────────────
              const Positioned(
                left: 0, top: 0, right: 0,
                child: _StatusBar(),
              ),

              // ── CONTENT CARD ─────────────────────────────
              // w:323  h:224  left:calc(50%-323/2-2)=23.5  top:474
              // padding:24  gap:32  border:1px #DFE3E8  radius:16
              Positioned(
                left:   (375 - 323) / 2 - 2,  // = 24
                top:    474,
                width:  323,
                height: 224,
                child: Container(
                  decoration: BoxDecoration(
                    color: kWhite,
                    border: Border.all(color: kBorder),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      // title & subtitle  w:275  h:120  gap:12
                      SizedBox(
                        width:  275,
                        height: 120,
                        child: Column(
                          children: [

                            // Title — Public Sans 700 24px #071951
                            SizedBox(
                              width:  275,
                              height: 36,
                              child: Text(
                                'Welcome to Attach',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize:   24,
                                  height:     1.5,
                                  color:      kTextTitle,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Subtitle — Public Sans 400 16px #637381
                            SizedBox(
                              width:  275,
                              height: 72,
                              child: Text(
                                'Connect with academic experts and '
                                'collaborate on your research and reports',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontWeight: FontWeight.w400,
                                  fontSize:   16,
                                  height:     1.5,
                                  color:      kTextSub,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // DOTS  w:96  h:24
                      // dot1: opacity.32 circle  dot2: ACTIVE pill  dot3,4: opacity.32
                      const _DotsIndicator(activeDot: 1),
                    ],
                  ),
                ),
              ),

              // ── NEXT BUTTON ──────────────────────────────
              // w:145  h:48  left:calc(50%-145/2+98)=265  top:725
              // #374D69  radius:8
              Positioned(
                left:   (375 - 145) / 2 + 98,  // = 263
                top:    725,
                width:  145,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBtnBlue,
                    elevation: 4,
                    shadowColor: const Color(0x40000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 11),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontWeight: FontWeight.w700,
                      fontSize:   15,
                      height:     26 / 15,
                      color:      kWhite,
                    ),
                  ),
                ),
              ),

              // ── SKIP BUTTON ──────────────────────────────
              // w:93  h:48  left:19  top:729
              // radius:100  color:#374D69  transparent bg
              Positioned(
                left:   19,
                top:    729,
                width:  93,
                height: 48,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 11),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontWeight: FontWeight.w700,
                      fontSize:   15,
                      height:     26 / 15,
                      color:      kBtnBlue,
                    ),
                  ),
                ),
              ),

              // ── HOME INDICATOR ───────────────────────────
              // w:375  h:34  top:773  bg:#FFFFFF
              // inner bar: w:134  h:4.47  #212B36  bottom:8.05
              const Positioned(
                left: 0, top: 773, right: 0,
                child: _HomeIndicator(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STATUS BAR  375 × 38
// clock left:33.45  top:17.17
// icons left:293.67 top:17.33
// ─────────────────────────────────────────────────────────────
class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:  375,
      height: 38,
      child: Stack(
        children: [
          // Clock
          Positioned(
            left: 33.45,
            top:  17.17,
            child: const Text(
              '9:41',
              style: TextStyle(
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w600,
                fontSize:   15,
                height:     18 / 15,
                letterSpacing: -0.3,
                color:      kWhite,
              ),
            ),
          ),

          // Right group  left:293.67  top:17.33
          Positioned(
            left: 293.67,
            top:  17.33,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5,
              children: [
                // Signal bars
                _SignalBars(),
                // WiFi
                _WifiIcon(),
                // Battery
                _BatteryIcon(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalBars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        _bar(4,   0.4),
        const SizedBox(width: 1.5),
        _bar(6,   0.6),
        const SizedBox(width: 1.5),
        _bar(8,   0.8),
        const SizedBox(width: 1.5),
        _bar(10,  1.0),
      ],
    );
  }

  Widget _bar(double h, double op) => Opacity(
        opacity: op,
        child: Container(
          width: 3, height: h,
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
}

class _WifiIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(15.33, 11),
      painter: _WifiPainter(),
    );
  }
}

class _WifiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = kWhite
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.6;

    final cx = size.width / 2;
    final cy = size.height;

    // dot
    canvas.drawCircle(Offset(cx, cy - 1.5), 1.5,
        Paint()..color = kWhite);
    // inner arc
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy), width: 8, height: 8),
      -3.14, 3.14, false, p);
    // outer arc
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy), width: 13, height: 13),
      -3.14, 3.14, false, p);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _BatteryIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25, height: 12,
      child: Row(
        children: [
          // Border 22 × 11.33
          Container(
            width: 22, height: 11.33,
            decoration: BoxDecoration(
              border: Border.all(
                color: kWhite.withOpacity(0.35)),
              borderRadius: BorderRadius.circular(2.67),
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(1.33),
              ),
            ),
          ),
          // Cap  1.33 × 4
          Container(
            width: 1.33, height: 4,
            color: kWhite.withOpacity(0.4),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// DOTS INDICATOR  w:96  h:24
// 4 slots of 24px each, activeDot index is the ACTIVE one
// active = wider pill (16px wide, radius 4)
// inactive = 8px circle, opacity .32
// ─────────────────────────────────────────────────────────────
class _DotsIndicator extends StatelessWidget {
  final int activeDot;   // 0-based
  const _DotsIndicator({required this.activeDot});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:  96,
      height: 24,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(4, (i) {
          final isActive = i == activeDot;
          return SizedBox(
            width:  24,
            height: 24,
            child: Center(
              child: Opacity(
                opacity: isActive ? 1.0 : 0.32,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width:  isActive ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: kNavy,
                    borderRadius: BorderRadius.circular(isActive ? 4 : 50),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// HOME INDICATOR  375 × 34
// bar: w:134  h:4.47  #212B36  bottom:8.05
// ─────────────────────────────────────────────────────────────
class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  375,
      height: 34,
      color:  kWhite,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 8.05),
      child: Container(
        width:  134,
        height: 4.47,
        decoration: BoxDecoration(
          color:  kHomebar,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// HANDSHAKE ILLUSTRATION  (SVG-equivalent via CustomPainter)
// Fills the arch frame (231 × 354 logical coords)
// ─────────────────────────────────────────────────────────────
class _HandshakeIllustration extends StatelessWidget {
  const _HandshakeIllustration();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HandshakePainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _HandshakePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Scale from design coords 231×354 → actual size
    final sx = size.width  / 231;
    final sy = size.height / 354;

    void rect(double x, double y, double w, double h,
        Color c, {double rx = 0}) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x * sx, y * sy, w * sx, h * sy),
          Radius.circular(rx * ((sx + sy) / 2)),
        ),
        Paint()..color = c,
      );
    }

    void oval(double cx, double cy, double rx2, double ry2, Color c) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx * sx, cy * sy),
          width:  rx2 * 2 * sx,
          height: ry2 * 2 * sy,
        ),
        Paint()..color = c,
      );
    }

    void arc(double x, double y, double w, double h,
        double start, double sweep, Color c,
        {double strokeW = 2.8}) {
      canvas.drawArc(
        Rect.fromLTWH(x * sx, y * sy, w * sx, h * sy),
        start, sweep, false,
        Paint()
          ..color = c
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeW * (sx + sy) / 2,
      );
    }

    // ── background ──
    rect(0, 0, 231, 354, const Color(0xFFEEF2F9));

    // ── speech bubble ──
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(118 * sx, 32 * sy, 72 * sx, 38 * sy),
        topLeft:     const Radius.circular(14),
        topRight:    const Radius.circular(14),
        bottomLeft:  const Radius.circular(14),
        bottomRight: const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFDCE8F8),
    );
    for (final cx in [131.0, 147.0, 163.0]) {
      oval(cx, 51, 4.5, 4.5, const Color(0xFF8AAEDC));
    }

    // ══ LEFT PERSON ══

    // trousers
    rect(44, 238, 24, 96, const Color(0xFF1A2D5A), rx: 9);
    rect(72, 238, 24, 96, const Color(0xFF1A2D5A), rx: 9);
    // shoes
    oval(56,  330, 20, 6.5, const Color(0xFF0C1322));
    oval(84,  330, 20, 6.5, const Color(0xFF0C1322));
    // jacket
    rect(36, 154, 76, 94, const Color(0xFFC8804A), rx: 14);
    // lapels
    final lapelPaintL = Paint()..color = const Color(0xFFB06C38);
    final pathLL = Path()
      ..moveTo(76 * sx, 156 * sy)
      ..lineTo(55 * sx, 175 * sy)
      ..lineTo(55 * sx, 248 * sy)
      ..lineTo(76 * sx, 248 * sy)
      ..close();
    canvas.drawPath(pathLL, lapelPaintL);
    final pathLR = Path()
      ..moveTo(76 * sx, 156 * sy)
      ..lineTo(97 * sx, 175 * sy)
      ..lineTo(97 * sx, 248 * sy)
      ..lineTo(76 * sx, 248 * sy)
      ..close();
    canvas.drawPath(pathLR, lapelPaintL);
    // neck
    rect(64, 139, 24, 22, const Color(0xFFF0BC88), rx: 7);
    // head
    oval(76, 120, 30, 30, const Color(0xFFF0BC88));
    // hair
    oval(76,  95, 30, 19, const Color(0xFF1C0C00));
    oval(52, 110, 16, 18, const Color(0xFF1C0C00));
    // eyebrows
    arc(58, 106, 20, 10, 3.4, -2.2, const Color(0xFF1C0C00));
    arc(78, 106, 20, 10, 3.4, -2.2, const Color(0xFF1C0C00));
    // eyes whites
    oval(70, 122, 4.5, 5,   const Color(0xFFFFFFFF));
    oval(88, 122, 4.5, 5,   const Color(0xFFFFFFFF));
    oval(70, 123, 3,   3,   const Color(0xFF3A1C00));
    oval(88, 123, 3,   3,   const Color(0xFF3A1C00));
    oval(71.5, 122, 1.2, 1.2, const Color(0xFFFFFFFF));
    oval(89.5, 122, 1.2, 1.2, const Color(0xFFFFFFFF));
    // smile
    arc(62, 128, 28, 14, 0.2, 2.8, const Color(0xFFB05838));
    // right arm
    rect(110, 164, 50, 20, const Color(0xFFF0BC88), rx: 10);
    oval(162, 174, 10, 7, const Color(0xFFF0BC88));
    // left arm
    rect(18, 158, 22, 58, const Color(0xFFC8804A), rx: 11);
    oval(29, 220, 13, 9, const Color(0xFFF0BC88));
    // briefcase
    rect(6,  208, 32, 24, const Color(0xFF7A3C0E), rx: 5);
    rect(14, 202, 16,  9, const Color(0xFF6A3008), rx: 3);
    canvas.drawLine(
      Offset(6 * sx, 220 * sy), Offset(38 * sx, 220 * sy),
      Paint()..color = const Color(0xFF9A5C1A)..strokeWidth = 1.5 * sx,
    );
    rect(21, 208, 2, 24, const Color(0xFF6A3008));

    // ══ RIGHT PERSON ══

    // skirt
    final skirtPath = Path()
      ..moveTo(154 * sx, 232 * sy)
      ..quadraticBezierTo(156 * sx, 272 * sy, 162 * sx, 334 * sy)
      ..lineTo(202 * sx, 334 * sy)
      ..quadraticBezierTo(208 * sx, 272 * sy, 210 * sx, 232 * sy)
      ..close();
    canvas.drawPath(skirtPath, Paint()..color = const Color(0xFF540E0E));
    // shoes
    oval(166, 336, 18, 6, const Color(0xFF0C1322));
    oval(198, 336, 18, 6, const Color(0xFF0C1322));
    rect(168, 330, 4, 10, const Color(0xFF1A1E2E), rx: 1.5);
    rect(200, 330, 4, 10, const Color(0xFF1A1E2E), rx: 1.5);
    // jacket
    rect(146, 156, 76, 88, const Color(0xFF720E0E), rx: 14);
    final lapelPaintR = Paint()..color = const Color(0xFF600C0C);
    final pathRL = Path()
      ..moveTo(182 * sx, 158 * sy)
      ..lineTo(160 * sx, 177 * sy)
      ..lineTo(160 * sx, 244 * sy)
      ..lineTo(182 * sx, 244 * sy)
      ..close();
    canvas.drawPath(pathRL, lapelPaintR);
    final pathRR = Path()
      ..moveTo(182 * sx, 158 * sy)
      ..lineTo(204 * sx, 177 * sy)
      ..lineTo(204 * sx, 244 * sy)
      ..lineTo(182 * sx, 244 * sy)
      ..close();
    canvas.drawPath(pathRR, lapelPaintR);
    // neck
    rect(170, 140, 24, 22, const Color(0xFFD08860), rx: 7);
    // head
    oval(182, 120, 28, 28, const Color(0xFFD08860));
    // hair
    oval(182, 96,  28, 18, const Color(0xFF280E00));
    oval(200, 108, 14, 17, const Color(0xFF280E00));
    oval(198, 93,  11, 10, const Color(0xFF280E00));
    // eyebrows
    arc(164, 106, 20, 10, 3.4, -2.2, const Color(0xFF280E00));
    arc(184, 106, 20, 10, 3.4, -2.2, const Color(0xFF280E00));
    // eyes
    oval(176, 122, 4.5, 5,   const Color(0xFFFFFFFF));
    oval(194, 122, 4.5, 5,   const Color(0xFFFFFFFF));
    oval(176, 123, 3,   3,   const Color(0xFF3A1000));
    oval(194, 123, 3,   3,   const Color(0xFF3A1000));
    oval(177.5, 122, 1.2, 1.2, const Color(0xFFFFFFFF));
    oval(195.5, 122, 1.2, 1.2, const Color(0xFFFFFFFF));
    // smile
    arc(168, 128, 28, 14, 0.2, 2.8, const Color(0xFFA04830));
    // left arm
    rect(100, 166, 48, 20, const Color(0xFFD08860), rx: 10);
    // right arm
    rect(220, 158, 22, 58, const Color(0xFF720E0E), rx: 11);
    oval(231, 220, 13, 9, const Color(0xFFD08860));

    // handshake clasp
    oval(138, 174, 22, 12, const Color(0xFFD89A68));
  }

  @override
  bool shouldRepaint(_) => false;
}