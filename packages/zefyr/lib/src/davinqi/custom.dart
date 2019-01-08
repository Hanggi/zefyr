import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'package:notus/notus.dart';

//import '../widgets/toolbar.dart';

abstract class PlusDelegate<S> {
	void test();

}
abstract class DavinqiMindmapDelegate<S> {
	void test();
//	/// Builds image widget for specified [imageSource] and [context].
//	Widget buildImage(BuildContext context, String imageSource);
//
//	/// Picks an image from specified [source].
//	///
//	/// Returns unique string key for the selected image. Returned key is stored
//	/// in the document.
//	Future<String> pickImage(S source);
}

/// davinqi
/// mybuttons
class FormatButton extends StatefulWidget {
  const FormatButton({Key key}) : super(key: key);

  @override
  _FormatButtonState createState() => _FormatButtonState();
}

class _FormatButtonState extends State<FormatButton> {
  @override
  Widget build(BuildContext context) {
    final toolbar = ZefyrToolbar.of(context);
    return toolbar.buildButton(
      context,
      ZefyrToolbarAction.format,
      onPressed: showOverlay,
    );
  }

  void showOverlay() {
    final toolbar = ZefyrToolbar.of(context);
    toolbar.showOverlay(buildOverlay);
  }

  Widget buildOverlay(BuildContext context) {
    final toolbar = ZefyrToolbar.of(context);
    final buttons = Row(
      children: <Widget>[
        SizedBox(width: 8.0),
        toolbar.buildButton(context, ZefyrToolbarAction.bold),
        toolbar.buildButton(context, ZefyrToolbarAction.italic),
        toolbar.buildButton(context, ZefyrToolbarAction.bulletList),
        toolbar.buildButton(context, ZefyrToolbarAction.numberList),
        toolbar.buildButton(context, ZefyrToolbarAction.quote),
      ],
    );
    return ZefyrToolbarScaffold(body: buttons);
  }
}

/// davinqi
/// 自定义 控件 如 知识树
class CustomToolsButton extends StatefulWidget {
  const CustomToolsButton({Key key}) : super(key: key);

  @override
  _CustomToolsButtonState createState() => _CustomToolsButtonState();
}

class _CustomToolsButtonState extends State<CustomToolsButton> {
  @override
  Widget build(BuildContext context) {
    final toolbar = ZefyrToolbar.of(context);
    return toolbar.buildButton(
      context,
      ZefyrToolbarAction.file_tree,
      onPressed: showOverlay,
    );
  }

  void showOverlay() {
    final toolbar = ZefyrToolbar.of(context);
    toolbar.showOverlay(buildOverlay);
  }

  Widget buildOverlay(BuildContext context) {
    final toolbar = ZefyrToolbar.of(context);
    final buttons = Row(
      children: <Widget>[
        SizedBox(width: 8.0),
        toolbar.buildButton(context, ZefyrToolbarAction.listMindmap,
            onPressed: () {}),
        toolbar.buildButton(context, ZefyrToolbarAction.addMindmap,
            onPressed: _pickMindtree),
      ],
    );
    return ZefyrToolbarScaffold(body: buttons);
  }

  void _pickMindtree() async {
    final editor = ZefyrToolbar.of(context).editor;
    print('pick mindtree');

    editor.mindmapDelegate.test();
//    final image = await editor.imageDelegate.pickImage(ImageSource.gallery);
//    if (image != null)
    editor.formatSelection(NotusAttribute.embed.addMindmap('test mindtree'));
  }
}
