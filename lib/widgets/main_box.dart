part of toast;

class _MainBox extends StatefulWidget {
  const _MainBox({Key? key, required this.type, this.msg}) : super(key: key);

  static OverlayEntry? entry;

  final _ToastType type;
  final String? msg;

  @override
  _MainBoxState createState() => _MainBoxState();
}

class _MainBoxState extends State<_MainBox>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 125))
    ..forward();

  @override
  void initState() {
    super.initState();
    if (widget.type != _ToastType.loading) {
      Timer(const Duration(seconds: 1, milliseconds: 300), () {
        if (mounted) {
          _animationController.reverse().whenComplete(() {
            _MainBox.entry?.remove();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final top = (size.height - 136) / 2;
    final left = (size.width - 136) / 2;
    return Positioned(
        top: top,
        left: left,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (_, child) {
            return Opacity(
              opacity: _animationController.value,
              child: child,
            );
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 136,
              height: 136,
              decoration: BoxDecoration(
                  color: const Color(0xFF4C4C4C),
                  borderRadius: BorderRadius.circular(4)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  widget.type.icon,
                  if (widget.msg != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        widget.msg!,
                        style: TextStyle(color: Colors.white),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                ].appendSpace(const SizedBox(
                  height: 12,
                )),
              ),
            ),
          ),
        ));
  }
}

enum _ToastType { success, error, loading, info }

extension XToastType on _ToastType {
  _icon(IconData iconData) => Icon(
        iconData,
        size: 54,
        color: Colors.white,
      );

  Widget get icon {
    switch (this) {
      case _ToastType.success:
        return _icon(Icons.check_circle_rounded);
      case _ToastType.error:
        return _icon(Icons.cancel);
      case _ToastType.loading:
        return const SizedBox(
          width: 54,
          height: 54,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        );
      case _ToastType.info:
        return _icon(Icons.info);
    }
  }
}
