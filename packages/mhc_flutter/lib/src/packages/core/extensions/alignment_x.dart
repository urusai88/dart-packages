import 'package:flutter/painting.dart';

extension AlignmentX on Alignment {
  Alignment get reversed => -this;

  Alignment get reverseX => Alignment(-x, y);

  Alignment get reverseY => Alignment(x, -y);
}
