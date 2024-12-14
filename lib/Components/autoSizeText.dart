import 'package:flutter/material.dart';

class AutoSizeText extends StatefulWidget {
  /// Creates a [AutoSizeText] widget.
  ///
  /// If the [style] argument is null, the text will use the style from the
  /// closest enclosing [DefaultTextStyle].
  const AutoSizeText(
    String this.data, {
    Key? key,
    this.textKey,
    this.style,
    this.strutStyle,
    this.minFontSize = 12,
    this.maxFontSize = double.infinity,
    this.stepGranularity = 1,
    this.presetFontSizes,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.wrapWords = true,
    this.overflow,
    this.overflowReplacement,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  })  : textSpan = null,
        super(key: key);

  /// Creates a [AutoSizeText] widget with a [TextSpan].
  const AutoSizeText.rich(
    TextSpan this.textSpan, {
    Key? key,
    this.textKey,
    this.style,
    this.strutStyle,
    this.minFontSize = 12,
    this.maxFontSize = double.infinity,
    this.stepGranularity = 1,
    this.presetFontSizes,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.wrapWords = true,
    this.overflow,
    this.overflowReplacement,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  })  : data = null,
        super(key: key);

  final Key? textKey;
  final String? data;
  final TextSpan? textSpan;
  final TextStyle? style;
  static const double _defaultFontSize = 14;
  final StrutStyle? strutStyle;
  final double minFontSize;
  final double maxFontSize;
  final double stepGranularity;
  final List<double>? presetFontSizes;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final bool wrapWords;
  final TextOverflow? overflow;
  final Widget? overflowReplacement;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;

  @override
  _AutoSizeTextState createState() => _AutoSizeTextState();
}

class _AutoSizeTextState extends State<AutoSizeText> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      final defaultTextStyle = DefaultTextStyle.of(context);

      var style = widget.style;
      if (widget.style == null || widget.style!.inherit) {
        style = defaultTextStyle.style.merge(widget.style);
      }
      if (style!.fontSize == null) {
        style = style.copyWith(fontSize: AutoSizeText._defaultFontSize);
      }

      final maxLines = widget.maxLines ?? defaultTextStyle.maxLines;

      _validateProperties(style, maxLines);

      final result = _calculateFontSize(size, style, maxLines);
      final fontSize = result[0] as double;
      final textFits = result[1] as bool;

      Widget text = _buildText(fontSize, style, maxLines);

      if (widget.overflowReplacement != null && !textFits) {
        return widget.overflowReplacement!;
      } else {
        return text;
      }
    });
  }

  void _validateProperties(TextStyle style, int? maxLines) {
    assert(widget.overflow == null || widget.overflowReplacement == null,
        'Either overflow or overflowReplacement must be null.');
    assert(maxLines == null || maxLines > 0,
        'MaxLines must be greater than or equal to 1.');
    assert(widget.key == null || widget.key != widget.textKey,
        'Key and textKey must not be equal.');

    if (widget.presetFontSizes == null) {
      assert(
          widget.stepGranularity >= 0.1,
          'StepGranularity must be greater than or equal to 0.1. It is not a '
          'good idea to resize the font with a higher accuracy.');
      assert(widget.minFontSize >= 0,
          'MinFontSize must be greater than or equal to 0.');
      assert(widget.maxFontSize > 0, 'MaxFontSize has to be greater than 0.');
      assert(widget.minFontSize <= widget.maxFontSize,
          'MinFontSize must be smaller or equal than maxFontSize.');
      assert(widget.minFontSize / widget.stepGranularity % 1 == 0,
          'MinFontSize must be a multiple of stepGranularity.');
      if (widget.maxFontSize != double.infinity) {
        assert(widget.maxFontSize / widget.stepGranularity % 1 == 0,
            'MaxFontSize must be a multiple of stepGranularity.');
      }
    } else {
      assert(widget.presetFontSizes!.isNotEmpty,
          'PresetFontSizes must not be empty.');
    }
  }

  List _calculateFontSize(
      BoxConstraints size, TextStyle? style, int? maxLines) {
    final span = TextSpan(
      style: widget.textSpan?.style ?? style,
      text: widget.textSpan?.text ?? widget.data,
      children: widget.textSpan?.children,
      recognizer: widget.textSpan?.recognizer,
    );

    final userScale =
        widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);

    int left;
    int right;

    final presetFontSizes = widget.presetFontSizes?.reversed.toList();
    if (presetFontSizes == null) {
      final num defaultFontSize =
          style!.fontSize!.clamp(widget.minFontSize, widget.maxFontSize);
      final defaultScale = defaultFontSize * userScale / style.fontSize!;
      if (_checkTextFits(span, defaultScale, maxLines, size)) {
        return <Object>[defaultFontSize * userScale, true];
      }

      left = (widget.minFontSize / widget.stepGranularity).floor();
      right = (defaultFontSize / widget.stepGranularity).ceil();
    } else {
      left = 0;
      right = presetFontSizes.length - 1;
    }

    var lastValueFits = false;
    while (left <= right) {
      final mid = (left + (right - left) / 2).floor();
      double scale;
      if (presetFontSizes == null) {
        scale = mid * userScale * widget.stepGranularity / style!.fontSize!;
      } else {
        scale = presetFontSizes[mid] * userScale / style!.fontSize!;
      }
      if (_checkTextFits(span, scale, maxLines, size)) {
        left = mid + 1;
        lastValueFits = true;
      } else {
        right = mid - 1;
      }
    }

    if (!lastValueFits) {
      right += 1;
    }

    double fontSize;
    if (presetFontSizes == null) {
      fontSize = right * userScale * widget.stepGranularity;
    } else {
      fontSize = presetFontSizes[right] * userScale;
    }

    return <Object>[fontSize, lastValueFits];
  }

  bool _checkTextFits(
      TextSpan text, double scale, int? maxLines, BoxConstraints constraints) {
    if (!widget.wrapWords) {
      final words = text.toPlainText().split(RegExp('\\s+'));

      final wordWrapTextPainter = TextPainter(
        text: TextSpan(
          style: text.style,
          text: words.join('\n'),
        ),
        textAlign: widget.textAlign ?? TextAlign.left,
        textDirection: widget.textDirection ?? TextDirection.ltr,
        textScaleFactor: scale,
        maxLines: words.length,
        locale: widget.locale,
        strutStyle: widget.strutStyle,
      );

      wordWrapTextPainter.layout(maxWidth: constraints.maxWidth);

      if (wordWrapTextPainter.didExceedMaxLines ||
          wordWrapTextPainter.width > constraints.maxWidth) {
        return false;
      }
    }

    final textPainter = TextPainter(
      text: text,
      textAlign: widget.textAlign ?? TextAlign.left,
      textDirection: widget.textDirection ?? TextDirection.ltr,
      textScaleFactor: scale,
      maxLines: maxLines,
      locale: widget.locale,
      strutStyle: widget.strutStyle,
    );

    textPainter.layout(maxWidth: constraints.maxWidth);

    return !(textPainter.didExceedMaxLines ||
        textPainter.height > constraints.maxHeight ||
        textPainter.width > constraints.maxWidth);
  }

  Widget _buildText(double fontSize, TextStyle style, int? maxLines) {
    if (widget.data != null) {
      return Text(
        widget.data!,
        key: widget.textKey,
        style: style.copyWith(fontSize: fontSize),
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        locale: widget.locale,
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        textScaleFactor: 1,
        maxLines: maxLines,
        semanticsLabel: widget.semanticsLabel,
      );
    } else {
      return Text.rich(
        widget.textSpan!,
        key: widget.textKey,
        style: style,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        locale: widget.locale,
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        textScaleFactor: fontSize / style.fontSize!,
        maxLines: maxLines,
        semanticsLabel: widget.semanticsLabel,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
