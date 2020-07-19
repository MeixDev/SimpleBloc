import 'package:simple_bloc/repository_helpers/repository_base.dart';
import 'package:flutter/material.dart';

class RepositoryProvider<T extends RepositoryBase> extends StatefulWidget {
  final Widget child;
  final List<T> repositories;

  RepositoryProvider({
    Key key,
    @required this.child,
    @required this.repositories,
  }) : super(key: key);

  @override
  _RepositoryProviderState createState() {
    if (key != null) masterKey = key;
    return _RepositoryProviderState();
  }

  static T of<T extends RepositoryBase>(BuildContext context) {
    _RepositoryProviderInherited provider = context
        .getElementForInheritedWidgetOfExactType<_RepositoryProviderInherited>()
        ?.widget;
    return provider?.repositories?.firstWhere((x) => x is T);
  }

  static T master<T extends RepositoryBase>() {
    assert(masterKey != null);
    return (masterKey.currentWidget as RepositoryProvider)
        .repositories
        ?.firstWhere((x) => x is T);
  }

  static GlobalKey masterKey;
}

class _RepositoryProviderState extends State<RepositoryProvider> {
  @override
  void initState() {
    super.initState();
    widget.repositories?.forEach((bloc) => bloc.initState());
  }

  @override
  void dispose() {
    widget.repositories?.forEach((bloc) => bloc.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _RepositoryProviderInherited(
      repositories: widget.repositories,
      child: widget.child,
    );
  }
}

class _RepositoryProviderInherited extends InheritedWidget {
  final List<RepositoryBase> repositories;

  _RepositoryProviderInherited(
      {Key key, @required Widget child, @required this.repositories})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
