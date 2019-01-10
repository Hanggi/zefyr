// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:notus/notus.dart';
import 'package:zefyr/src/davinqi/custom.dart';

import '../widgets/editable_box.dart';



class MindmapRule extends StatefulWidget {
  const MindmapRule({Key key, @required this.node, this.delegate, this.id, this.img}) : super(key: key);

  final EmbedNode node;
  final DavinqiMindmapDelegate delegate;
  final int id;
  final String img;

  @override
  _MindmapRuleState createState() => _MindmapRuleState();
}

class _MindmapRuleState extends State<MindmapRule> {
  @override
  Widget build(BuildContext context) {

//    widget.delegate.test(context);
//  	print(widget.img);
//  	print('mindmap rule');
    return _EditableImage(
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.3),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: FadeInImage(
          fit: BoxFit.contain,
//          image: NetworkImage(
//              'https://www.mindmeister.com/blog/wp-content/uploads/2015/01/MindMapping_mindmap_handdrawn-796x531.png'),
          image: NetworkImage(widget.img == null ? '' :widget.img),
          placeholder: AssetImage(
            "assets/images/placeholder.png",
          ),
        ),
      ),
      node: widget.node,
    );
  }
}

class _EditableImage extends SingleChildRenderObjectWidget {
  _EditableImage({@required Widget child, @required this.node})
      : assert(node != null),
        super(child: child);

  final EmbedNode node;

  @override
  RenderEditableImage createRenderObject(BuildContext context) {
    return new RenderEditableImage(node: node);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderEditableImage renderObject) {
    renderObject..node = node;
  }
}

class RenderEditableImage extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>, RenderProxyBoxMixin<RenderBox>
    implements RenderEditableBox {
  static const kPaddingBottom = 24.0;

  RenderEditableImage({
    RenderImage child,
    @required EmbedNode node,
  }) : _node = node {
    this.child = child;
  }

  @override
  EmbedNode get node => _node;
  EmbedNode _node;
  void set node(EmbedNode value) {
    _node = value;
  }

  // TODO: Customize caret height offset instead of adjusting here by 2px.
  @override
  double get preferredLineHeight => size.height - kPaddingBottom + 2.0;

  @override
  SelectionOrder get selectionOrder => SelectionOrder.foreground;

  @override
  TextSelection getLocalSelection(TextSelection documentSelection) {
    if (!intersectsWithSelection(documentSelection)) return null;

    int nodeBase = node.documentOffset;
    int nodeExtent = nodeBase + node.length;
    int base = math.max(0, documentSelection.baseOffset - nodeBase);
    int extent =
        math.min(documentSelection.extentOffset, nodeExtent) - nodeBase;
    return documentSelection.copyWith(baseOffset: base, extentOffset: extent);
  }

  @override
  List<ui.TextBox> getEndpointsForSelection(TextSelection selection) {
    TextSelection local = getLocalSelection(selection);
    if (local.isCollapsed) {
      final dx = local.extentOffset == 0 ? _childOffset.dx : size.width;
      return [
        new ui.TextBox.fromLTRBD(
            dx, 0.0, dx, size.height - kPaddingBottom, TextDirection.ltr),
      ];
    }

    final rect = _childRect;
    return [
      new ui.TextBox.fromLTRBD(
          rect.left, rect.top, rect.left, rect.bottom, TextDirection.ltr),
      new ui.TextBox.fromLTRBD(
          rect.right, rect.top, rect.right, rect.bottom, TextDirection.ltr),
    ];
  }

  @override
  TextPosition getPositionForOffset(Offset offset) {
    int position = _node.documentOffset;

    if (offset.dx > size.width / 2) {
      position++;
    }
    return new TextPosition(offset: position);
  }

  @override
  TextRange getWordBoundary(TextPosition position) {
    final start = _node.documentOffset;
    return new TextRange(start: start, end: start + 1);
  }

  @override
  bool intersectsWithSelection(TextSelection selection) {
    final int base = node.documentOffset;
    final int extent = base + node.length;
    return base <= selection.extentOffset && selection.baseOffset <= extent;
  }

  @override
  Offset getOffsetForCaret(TextPosition position, Rect caretPrototype) {
    final pos = position.offset - node.documentOffset;
    Offset caretOffset = _childOffset - new Offset(kHorizontalPadding, 0.0);
    if (pos == 1) {
      caretOffset = caretOffset +
          new Offset(_lastChildSize.width + kHorizontalPadding, 0.0);
    }
    return caretOffset;
  }

  @override
  void paintSelection(PaintingContext context, Offset offset,
      TextSelection selection, Color selectionColor) {
    final localSelection = getLocalSelection(selection);
    assert(localSelection != null);
//    print('paintSelection');
    if (!localSelection.isCollapsed) {
      final Paint paint = new Paint()
        ..color = selectionColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      final rect = new Rect.fromLTWH(
          0.0, 0.0, _lastChildSize.width, _lastChildSize.height);
      context.canvas.drawRect(rect.shift(offset + _childOffset), paint);
    }
  }

  void paint(PaintingContext context, Offset offset) {
//    print('paint!!!!!!!!!!!!!!!!!');
//    print(context);
    super.paint(context, offset + _childOffset);
  }

  static const double kHorizontalPadding = 1.0;

  Size _lastChildSize;

  Offset get _childOffset {
    final dx = (size.width - _lastChildSize.width) / 2 + kHorizontalPadding;
    final dy = (size.height - _lastChildSize.height - kPaddingBottom) / 2;
    return new Offset(dx, dy);
  }

  Rect get _childRect {
    return new Rect.fromLTWH(_childOffset.dx, _childOffset.dy,
        _lastChildSize.width, _lastChildSize.height);
  }

  @override
  void performLayout() {
//    print('performLayout');
    assert(constraints.hasBoundedWidth);
    if (child != null) {
      // Make constraints use 16:9 aspect ratio.
      final width = constraints.maxWidth - kHorizontalPadding * 2;
      final childConstraints = constraints.copyWith(
        minWidth: 0.0,
        maxWidth: width,
        minHeight: 0.0,
        maxHeight: (width * 9 / 16).floorToDouble(),
      );
      child.layout(childConstraints, parentUsesSize: true);
      _lastChildSize = child.size;
      size = new Size(
          constraints.maxWidth, _lastChildSize.height + kPaddingBottom);
    } else {
      performResize();
    }
  }
}
