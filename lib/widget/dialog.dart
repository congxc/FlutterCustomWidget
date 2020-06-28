import 'package:flutter/material.dart';

class Dialog extends StatelessWidget {
  /// Creates a dialog.
  ///
  /// Typically used in conjunction with [showDialog].
  const Dialog({
    Key key,
    this.backgroundColor,
    this.elevation,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.shape,
    this.child,
  }) : super(key: key);

  /// {@template flutter.material.dialog.backgroundColor}
  /// The background color of the surface of this [Dialog].
  ///
  /// This sets the [Material.color] on this [Dialog]'s [Material].
  ///
  /// If `null`, [ThemeData.cardColor] is used.
  /// {@endtemplate}
  final Color backgroundColor;

  /// {@template flutter.material.dialog.elevation}
  /// The z-coordinate of this [Dialog].
  ///
  /// If null then [DialogTheme.elevation] is used, and if that's null then the
  /// dialog's elevation is 24.0.
  /// {@endtemplate}
  /// {@macro flutter.material.material.elevation}
  final double elevation;

  /// The duration of the animation to show when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  ///
  /// Defaults to 100 milliseconds.
  final Duration insetAnimationDuration;

  /// The curve to use for the animation shown when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  ///
  /// Defaults to [Curves.fastOutSlowIn].
  final Curve insetAnimationCurve;

  /// {@template flutter.material.dialog.shape}
  /// The shape of this dialog's border.
  ///
  /// Defines the dialog's [Material.shape].
  ///
  /// The default shape is a [RoundedRectangleBorder] with a radius of 2.0.
  /// {@endtemplate}
  final ShapeBorder shape;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  // TODO(johnsonmh): Update default dialog border radius to 4.0 to match material spec.
  static const RoundedRectangleBorder _defaultDialogShape =
      RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)));
  static const double _defaultElevation = 24.0;

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);
    return AnimatedPadding(
      padding: EdgeInsets.all(0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 280.0),
            child: Material(
              color: backgroundColor ??
                  dialogTheme.backgroundColor ??
                  Theme.of(context).dialogBackgroundColor,
              elevation:
                  elevation ?? dialogTheme.elevation ?? _defaultElevation,
              shape: shape ?? dialogTheme.shape ?? _defaultDialogShape,
              type: MaterialType.card,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

Future<T> showDialog<T>({
  @required
      BuildContext context,
  bool barrierDismissible = true,
  Offset offset,
  @Deprecated(
      'Instead of using the "child" argument, return the child from a closure '
      'provided to the "builder" argument. This will ensure that the BuildContext '
      'is appropriate for widgets built in the dialog.')
      Widget child,
  WidgetBuilder builder,
}) {
  assert(child == null || builder == null);
  assert(debugCheckHasMaterialLocalizations(context));
  final ThemeData theme = Theme.of(context, shadowThemeOnly: false);
  return showGeneralDialog(
    context: context,
    offset: offset,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = child ?? Builder(builder: builder);
      return SafeArea(
        child: Builder(builder: (BuildContext context) {
          return theme != null
              ? Theme(data: theme, child: pageChild)
              : pageChild;
        }),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Color(0x01000000),
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: _buildMaterialDialogTransitions,
  );
}

Widget _buildMaterialDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

Future<T> showGeneralDialog<T>({
  @required BuildContext context,
  @required RoutePageBuilder pageBuilder,
  Offset offset,
  bool barrierDismissible,
  String barrierLabel,
  Color barrierColor,
  Duration transitionDuration,
  RouteTransitionsBuilder transitionBuilder,
}) {
  assert(pageBuilder != null);
  assert(!barrierDismissible || barrierLabel != null);
  return Navigator.of(context, rootNavigator: true).push<T>(_DialogRoute<T>(
    offset: offset,
    pageBuilder: pageBuilder,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    transitionDuration: transitionDuration,
    transitionBuilder: transitionBuilder,
//    settings: RouteSettings(arguments: )
  ));
}

class _DialogRoute<T> extends PopupRoute<T> {
  _DialogRoute({
    @required RoutePageBuilder pageBuilder,
    this.offset,
    bool barrierDismissible = true,
    String barrierLabel,
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder transitionBuilder,
    RouteSettings settings,
  })  : assert(barrierDismissible != null),
        _pageBuilder = pageBuilder,
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _barrierColor = barrierColor,
        _transitionDuration = transitionDuration,
        _transitionBuilder = transitionBuilder,
        super(settings: settings);

  final Offset offset;

  final RoutePageBuilder _pageBuilder;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  String get barrierLabel => _barrierLabel;
  final String _barrierLabel;

  @override
  Color get barrierColor => _barrierColor;
  final Color _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

  final RouteTransitionsBuilder _transitionBuilder;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    if (this.offset == null) {
      return Semantics(
        child: _pageBuilder(context, animation, secondaryAnimation),
        scopesRoute: true,
        explicitChildNodes: true,
      );
    } else {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: GestureDetector(
                  onTap: () {},
                  child: _pageBuilder(context, animation, secondaryAnimation)),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (_transitionBuilder == null) {
      return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.linear,
          ),
          child: child);
    } // Some default transition
    return _transitionBuilder(context, animation, secondaryAnimation, child);
  }
}
