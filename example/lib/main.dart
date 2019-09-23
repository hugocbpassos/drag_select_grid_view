import 'package:flutter/material.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.grey[200]),
  );
  runApp(
    MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(elevation: 1),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag Select Grid View Example'),
        centerTitle: true,
      ),
      body: buildDragSelectGridView(),
    );
  }

  DragSelectGridView buildDragSelectGridView() {
    return DragSelectGridView(
      padding: EdgeInsets.all(8),
      itemCount: 90,
      itemBuilder: (BuildContext context, int index, bool selected) {
        return ExampleChildItem(
          index: index,
          color: Colors.blue,
          selected: selected,
        );
      },
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
    );
  }

  Widget gridViewItem(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.blue,
      ),
      child: Center(
        child: Text(
          'Item\n#$index',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
    );
  }
}

class ExampleChildItem extends StatefulWidget {
  const ExampleChildItem({
    Key key,
    @required this.index,
    @required this.color,
    @required this.selected,
  }) : super(key: key);

  final int index;
  final MaterialColor color;
  final bool selected;

  @override
  _ExampleChildItemState createState() => _ExampleChildItemState();
}

class _ExampleChildItemState extends State<ExampleChildItem>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: widget.selected ? 1.0 : 0.0,
      duration: kThemeChangeDuration,
      vsync: this,
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));
  }

  @override
  void didUpdateWidget(ExampleChildItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      if (widget.selected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (BuildContext context, Widget child) {
        final color = Color.lerp(
            widget.color.shade500, widget.color.shade900, _controller.value);
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: DecoratedBox(
            decoration: BoxDecoration(color: color),
            child: child,
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          '${widget.index}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
          ),
        ),
      ),
    );
  }
}
