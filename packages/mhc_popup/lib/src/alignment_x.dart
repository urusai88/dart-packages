import 'package:flutter/cupertino.dart';

extension AlignmentX on Alignment {
  Alignment get reverseX => Alignment(-x, y);

  Alignment get reverseY => Alignment(x, -y);
}
