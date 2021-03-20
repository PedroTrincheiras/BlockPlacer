import 'dart:io';

import 'package:blockplacer/Management/colorscheme.dart';
import 'package:blockplacer/Management/gamegestor.dart';
import 'package:blockplacer/Management/pieces.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

typedef DragTargetWillAccept = bool Function(MyPiece data);
typedef DragTargetAccept = void Function(MyPiece data);
typedef DragTargetBuilder = Widget Function(
    BuildContext context, List candidateData, List<dynamic> rejectedData);
typedef DraggableCanceledCallback = void Function(
    Velocity velocity, Offset offset);
typedef DragEndCallback = void Function(GameDraggableDetails details);
typedef DragTargetLeave = void Function(Object data);

class GameDraggable extends StatefulWidget {
  const GameDraggable({
    Key key,
    @required this.child,
    @required this.feedback,
    @required this.sizex,
    @required this.sizey,
    @required this.gestor,
    this.data,
    this.childWhenDragging,
    this.feedbackOffset = Offset.zero,
    this.onDragStarted,
    this.onDraggableCanceled,
    this.onDragEnd,
    this.onDragCompleted,
    this.ignoringFeedbackSemantics = true,
  })  : assert(child != null),
        assert(feedback != null),
        assert(ignoringFeedbackSemantics != null),
        super(key: key);

  final MyPiece data;
  final Widget child;
  final double sizex;
  final double sizey;
  final Widget childWhenDragging;
  final Widget feedback;
  final Offset feedbackOffset;
  final bool ignoringFeedbackSemantics;
  final VoidCallback onDragStarted;
  final DraggableCanceledCallback onDraggableCanceled;
  final VoidCallback onDragCompleted;
  final DragEndCallback onDragEnd;
  final Gestor gestor;

  @protected
  MultiDragGestureRecognizer<MultiDragPointerState> createRecognizer(
      GestureMultiDragStartCallback onStart) {
    return ImmediateMultiDragGestureRecognizer()..onStart = onStart;
  }

  @override
  _GameDraggableState createState() => _GameDraggableState();
}

class _GameDraggableState extends State<GameDraggable> {
  @override
  void initState() {
    super.initState();
    _recognizer = widget.createRecognizer(_startDrag);
  }

  @override
  void dispose() {
    _disposeRecognizerIfInactive();
    super.dispose();
  }

  GestureRecognizer _recognizer;

  void _disposeRecognizerIfInactive() {
    if (widget.gestor.draging != 0) return;
    _recognizer.dispose();
    _recognizer = null;
  }

  void _routePointer(PointerDownEvent event) {
    if (widget.gestor.draging != 0) return;
    _recognizer.addPointer(event);
  }

  _GameDragAvatar _startDrag(Offset position) {
    if (widget.gestor.draging != 0) return null;
    setState(() {
      widget.gestor.draging += 1;
    });
    final _GameDragAvatar avatar = _GameDragAvatar(
      overlayState: Overlay.of(context, debugRequiredFor: widget),
      data: widget.data,
      initialPosition: position,
      dragStartPoint: Offset(widget.sizey / 2, widget.sizex + 100),
      feedback: widget.feedback,
      feedbackOffset:
          Offset(-(widget.sizey / 2) + 10, -(widget.sizex + 100) + 10),
      ignoringFeedbackSemantics: widget.ignoringFeedbackSemantics,
      onDragEnd: (Velocity velocity, Offset offset, bool wasAccepted) {
        if (mounted) {
          setState(() {
            widget.gestor.draging -= 1;
          });
        } else {
          widget.gestor.draging -= 1;
          _disposeRecognizerIfInactive();
        }
        if (mounted && widget.onDragEnd != null) {
          widget.onDragEnd(GameDraggableDetails(
            wasAccepted: wasAccepted,
            velocity: velocity,
            offset: offset,
          ));
        }
        if (wasAccepted && widget.onDragCompleted != null)
          widget.onDragCompleted();
        if (!wasAccepted && widget.onDraggableCanceled != null)
          widget.onDraggableCanceled(velocity, offset);
      },
    );
    if (widget.onDragStarted != null) widget.onDragStarted();
    return avatar;
  }

  @override
  Widget build(BuildContext context) {
    assert(Overlay.of(context, debugRequiredFor: widget) != null);
    final bool showChild =
        widget.gestor.draging == 0 || widget.childWhenDragging == null;
    return Listener(
      onPointerDown: widget.gestor.draging == 0 ? _routePointer : null,
      child: showChild ? widget.child : widget.childWhenDragging,
    );
  }
}

class GameDraggableDetails {
  GameDraggableDetails({
    this.wasAccepted = false,
    @required this.velocity,
    @required this.offset,
  })  : assert(velocity != null),
        assert(offset != null);

  final bool wasAccepted;
  final Velocity velocity;
  final Offset offset;
}

class GameDragTarget extends StatefulWidget {
  const GameDragTarget(
      {Key key,
      this.onLeave,
      @required this.gestor,
      @required this.x,
      @required this.y,
      @required this.mcs,
      @required this.color})
      : super(key: key);

  final DragTargetLeave onLeave;
  final Gestor gestor;
  final int x;
  final int y;
  final Color color;
  final MyColorScheme mcs;

  @override
  _GameDragTargetState createState() => _GameDragTargetState();
}

class _GameDragTargetState extends State<GameDragTarget> {
  final List<_GameDragAvatar> _candidateAvatars = <_GameDragAvatar>[];
  final List<_GameDragAvatar> _rejectedAvatars = <_GameDragAvatar>[];

  bool didEnter(_GameDragAvatar avatar) {
    assert(!_candidateAvatars.contains(avatar));
    assert(!_rejectedAvatars.contains(avatar));
    if (widget.gestor.canAccept(avatar.data, widget.x, widget.y)) {
      setState(() {
        _candidateAvatars.add(avatar);
      });
      return true;
    } else {
      setState(() {
        _rejectedAvatars.add(avatar);
      });
      return false;
    }
  }

  void didLeave(_GameDragAvatar avatar) {
    assert(_candidateAvatars.contains(avatar) ||
        _rejectedAvatars.contains(avatar));
    if (!mounted) return;
    setState(() {
      _candidateAvatars.remove(avatar);
      _rejectedAvatars.remove(avatar);
    });
    if (widget.onLeave != null) widget.onLeave(avatar.data);
  }

  void didDrop(_GameDragAvatar avatar) {
    assert(_candidateAvatars.contains(avatar));
    if (!mounted) return;
    setState(() {
      _candidateAvatars.remove(avatar);
      widget.gestor.accept(avatar.data, widget.x, widget.y);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _actual = false;

    Container filled = Container(
        key: Key("1"),
        height: (((MediaQuery.of(context).size.width - 100) / 9) - 1.5),
        width: (((MediaQuery.of(context).size.width - 100) / 9) - 1.5),
        decoration: BoxDecoration(
            border:
                Border.all(width: 0.25, color: widget.mcs.pieceBorderColor()),
            borderRadius: BorderRadius.all(Radius.circular(2)),
            color: widget.mcs.pieceColor()));

    Container unfilled = Container(
        key: Key("2"),
        height: (((MediaQuery.of(context).size.width - 100) / 9) - 1.5),
        width: (((MediaQuery.of(context).size.width - 100) / 9) - 1.5),
        decoration: BoxDecoration(
            border: null, borderRadius: null, color: widget.color));

    widget.gestor.addListener(() {
      if (widget.gestor.getVal(widget.x, widget.y) != _actual) {
        setState(() {});
        _actual = !_actual;
      }
    });

    widget.mcs.addListener(() {
      setState(() {});
    });

    return MetaData(
        metaData: this,
        behavior: HitTestBehavior.translucent,
        child: Padding(
            padding: const EdgeInsets.all(0.25),
            child: AnimatedSwitcher(
              child:
                  widget.gestor.getVal(widget.x, widget.y) ? filled : unfilled,
              duration: widget.gestor.getVal(widget.x, widget.y)
                  ? Duration.zero
                  : Duration(
                      milliseconds: 10,
                    ),
            )));
  }
}

enum _DragEndKind { dropped, canceled }
typedef _OnDragEnd = void Function(
    Velocity velocity, Offset offset, bool wasAccepted);

class _GameDragAvatar extends Drag {
  _GameDragAvatar({
    @required this.overlayState,
    this.data,
    this.axis,
    Offset initialPosition,
    this.dragStartPoint = Offset.zero,
    this.feedback,
    this.feedbackOffset = Offset.zero,
    this.onDragEnd,
    @required this.ignoringFeedbackSemantics,
  })  : assert(overlayState != null),
        assert(ignoringFeedbackSemantics != null),
        assert(dragStartPoint != null),
        assert(feedbackOffset != null) {
    _entry = OverlayEntry(builder: _build);
    overlayState.insert(_entry);
    _position = initialPosition;
    updateDrag(initialPosition);
  }

  final MyPiece data;
  final Axis axis;
  final Offset dragStartPoint;
  final Widget feedback;
  final Offset feedbackOffset;
  final _OnDragEnd onDragEnd;
  final OverlayState overlayState;
  final bool ignoringFeedbackSemantics;

  _GameDragTargetState _activeTarget;
  final List<_GameDragTargetState> _enteredTargets = <_GameDragTargetState>[];
  Offset _position;
  Offset _lastOffset;
  OverlayEntry _entry;

  @override
  void update(DragUpdateDetails details) {
    _position += _restrictAxis(details.delta);
    updateDrag(_position);
  }

  @override
  void end(DragEndDetails details) {
    finishDrag(_DragEndKind.dropped, _restrictVelocityAxis(details.velocity));
  }

  @override
  void cancel() {
    finishDrag(_DragEndKind.canceled);
  }

  void updateDrag(Offset globalPosition) {
    _lastOffset = globalPosition - dragStartPoint;
    _entry.markNeedsBuild();
    final HitTestResult result = HitTestResult();
    WidgetsBinding.instance.hitTest(result, globalPosition + feedbackOffset);

    final List<_GameDragTargetState> targets =
        _getDragTargets(result.path).toList();

    bool listsMatch = false;
    if (targets.length >= _enteredTargets.length &&
        _enteredTargets.isNotEmpty) {
      listsMatch = true;
      final Iterator<_GameDragTargetState> iterator = targets.iterator;
      for (int i = 0; i < _enteredTargets.length; i += 1) {
        iterator.moveNext();
        if (iterator.current != _enteredTargets[i]) {
          listsMatch = false;
          break;
        }
      }
    }

    if (listsMatch) return;

    _leaveAllEntered();

    final _GameDragTargetState newTarget = targets.firstWhere(
      (_GameDragTargetState target) {
        _enteredTargets.add(target);
        return target.didEnter(this);
      },
      orElse: () => null,
    );

    _activeTarget = newTarget;
  }

  Iterable<_GameDragTargetState> _getDragTargets(
      Iterable<HitTestEntry> path) sync* {
    for (final HitTestEntry entry in path) {
      final HitTestTarget target = entry.target;
      if (target is RenderMetaData) {
        final dynamic metaData = target.metaData;
        if (metaData is _GameDragTargetState) yield metaData;
      }
    }
  }

  void _leaveAllEntered() {
    for (int i = 0; i < _enteredTargets.length; i += 1)
      _enteredTargets[i].didLeave(this);
    _enteredTargets.clear();
  }

  void finishDrag(_DragEndKind endKind, [Velocity velocity]) {
    bool wasAccepted = false;
    if (endKind == _DragEndKind.dropped && _activeTarget != null) {
      _activeTarget.didDrop(this);
      wasAccepted = true;
      _enteredTargets.remove(_activeTarget);
    }
    _leaveAllEntered();
    _activeTarget = null;
    _entry.remove();
    _entry = null;
    if (onDragEnd != null)
      onDragEnd(velocity ?? Velocity.zero, _lastOffset, wasAccepted);
  }

  Widget _build(BuildContext context) {
    final RenderBox box = overlayState.context.findRenderObject() as RenderBox;
    final Offset overlayTopLeft = box.localToGlobal(Offset.zero);
    return Positioned(
      left: _lastOffset.dx - overlayTopLeft.dx,
      top: _lastOffset.dy - overlayTopLeft.dy,
      child: IgnorePointer(
        child: feedback,
        ignoringSemantics: ignoringFeedbackSemantics,
      ),
    );
  }

  Velocity _restrictVelocityAxis(Velocity velocity) {
    if (axis == null) {
      return velocity;
    }
    return Velocity(
      pixelsPerSecond: _restrictAxis(velocity.pixelsPerSecond),
    );
  }

  Offset _restrictAxis(Offset offset) {
    if (axis == null) {
      return offset;
    }
    if (axis == Axis.horizontal) {
      return Offset(offset.dx, 0.0);
    }
    return Offset(0.0, offset.dy);
  }
}
