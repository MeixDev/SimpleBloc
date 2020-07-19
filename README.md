# Simple_BLoC

Implementation of the BLoC pattern along with an easier implementation using functions instead of events.

The base implementation is from this article from [didierboelens.com](https://www.didierboelens.com/2018/12/reactive-programming-streams-bloc-practical-use-cases/).

The original GitHub repository of the article is also available here along with documentation about the Event-State management: [boeledi/blocs](https://github.com/boeledi/blocs)

I then applied some changes (Such as allowed the BlocProvider to take multiple blocs as inputs), and added the RepositoryProvider and RepositoryBase classes, heavily influenced by the BlocProvider class.

As the project is not released on [pub.dev](https://pub.dev), you must add it as a dependency of your project the following way:

```yaml
dependencies:
  number_picker_redux:
    git:
      url: git@github.com:MeixDev/SimpleBloc.git
```

if you get a `Host key verification failed` when trying to pub get, you should add GitHub as a known host:
`ssh-keyscan github.com >> ~/.ssh/known_hosts`

## How to use as a Simple BLoC Implementation ?

In the case you don't need a really separated Event <-> State BLoC Management, you can use the BLoC implementation through RxDart BehaviorSubject class:

```dart
  // Create a BehaviorSubject<T>. I use the seeded factory to be able to set an initialValue. You can also add onListen & onCancel handlers if needed.
  BehaviorSubject<bool> _bottomSheetController =
    BehaviorSubject<bool>.seeded(false);
  // You can access the stream of the subject easily to be used in your StreamBuilders.
  Stream<bool> get bottomSheetController => _bottomSheetController.stream;
  // The BehaviorSubject retains the latest value it emits, so you can still get it anytime it's needed. 
  bool get isBottomSheetOpen => _bottomSheetController.value;
```

Then, in your Widget's build function :

```dart
  @override
  Widget build(BuildContext context) {
    ...
    // Create a StreamBuilder with the same type as your BehaviorSubject
    return StreamBuilder<bool>(
      // Pass the stream to watch
      stream: BlocProvider.of<BottomSheetBloc>(context).bottomSheetController,
      builder: (context, snapshot) {
        // Do something special in case the data doesn't exist 
        if (snapshot.data == null || !snapshot.hasData) return Container();
        // Do something for real with the Snapshot's data 
        return Text(snapshot.data);
      },
    );
  }
```

In order to update your BehaviorSubject with new values, you just have to use the add method on the StreamSink:

```dart
  _bottomSheetController.sink.add(true);
  // BehaviorSubject also adds a QoL shortcut:
  _bottomSheetController.add(false);
```