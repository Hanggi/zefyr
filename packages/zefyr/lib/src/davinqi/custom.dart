import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zefyr/zefyr.dart';
import 'package:notus/notus.dart';

import 'package:flutter/services.dart' show SystemChannels;
import 'package:flutter/cupertino.dart';

//import '../widgets/toolbar.dart';
abstract class PlusDelegate {
  void test(BuildContext context);
}

class DavinqiDefaultPlusDelegate implements PlusDelegate {
  @override
  void test(BuildContext c) {
//    SystemChannels.textInput.invokeMethod('TextInput.hide');

    var toolbar = ZefyrToolbar.of(c);
    print(toolbar);
    showCupertinoModalPopup<String>(
      context: c,
      builder: (BuildContext context) => CupertinoActionSheet(
//            title: const Text('Favorite Dessert'),
//            message: const Text(
//                'Please select the best dessert from the options below.'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const Text(
                  '相机',
                  style: TextStyle(color: Colors.orange),
                ),
                onPressed: () async {
                  Navigator.pop(context, 'camera');
                  final editor = toolbar.editor;
                  final image =
                      await editor.imageDelegate.pickImage(ImageSource.camera);
                  if (image != null)
                    editor.formatSelection(NotusAttribute.embed.image(image));
                },
              ),
              CupertinoActionSheetAction(
                child: const Text(
                  '从相册选择',
                  style: TextStyle(color: Colors.orange),
                ),
                onPressed: () async {
                  Navigator.pop(context, 'gallery');

//                  final toolbar = ZefyrToolbar.of(c);
//                  print(toolbar);
                  final editor = toolbar.editor;
                  final image =
                      await editor.imageDelegate.pickImage(ImageSource.gallery);
                  if (image != null)
                    editor.formatSelection(NotusAttribute.embed.image(image));
                },
              ),
              CupertinoActionSheetAction(
                child: const Text(
                  '知识树',
                  style: TextStyle(color: Colors.orange),
                ),
                onPressed: () async {
                  Navigator.pop(context, 'mindmap');
                  var editor = toolbar.editor;
                  print('pick mindtree');

                  dynamic obj = await editor.mindmapDelegate.test(context);
//    print(obj.toString());
                  editor.formatSelection(NotusAttribute.embed.addMindmap(
                    id: int.parse(obj['id'].toString()),
                    imgUrl: obj['img_url'].toString(),
                  ));
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.orange),
              ),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            ),
          ),
    );
  }
}

abstract class DavinqiMindmapDelegate<S> {
  dynamic test(BuildContext context);
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

    dynamic obj = await editor.mindmapDelegate.test(context);
//    print(obj.toString());
    editor.formatSelection(NotusAttribute.embed.addMindmap(
      id: int.parse(obj['id'].toString()),
      imgUrl: obj['img_url'].toString(),
    ));
  }
}
