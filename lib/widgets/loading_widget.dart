import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget(
      {super.key, required this.child, required this.IsLoading});

  final bool IsLoading;
  final Widget child;

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.IsLoading)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              color: Theme.of(context).colorScheme.background,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}

class IsLoading extends ChangeNotifier {
  bool _IsLoading = false;
  bool isModalClosed = false;

  bool getLoading() => _IsLoading;

  void setLoading(bool value) {
    _IsLoading = value;
    notifyListeners();
  }

  bool getIsModalClosed() {
    return isModalClosed;
  }

  void setIsModalClosed(bool value) {
    isModalClosed = value;
    notifyListeners();
  }
}
