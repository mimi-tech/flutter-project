import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class UploadMultipleImageDemo extends StatefulWidget {
  UploadMultipleImageDemo() : super();

  final String title = 'Firebase Storage';

  @override
  UploadMultipleImageDemoState createState() => UploadMultipleImageDemoState();
}

class UploadMultipleImageDemoState extends State<UploadMultipleImageDemo> {
  String? _path;
  late Map<String, String> _paths;
  String? _extension;
  FileType _pickType = FileType.video;
  bool _multiPick = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<UploadTask> _tasks = <UploadTask>[];

  void openFileExplorer() async {
    try {
      _path = null;
      if (_multiPick) {
        /// TODO: Ellis = Multi-file package has change. Refer to the documentation
        // _paths = await FilePicker.getMultiFilePath(
        //   type: FileType.video,
        // );
      } else {
        // _path = await FilePicker.getFilePath(
        //   type: FileType.video,
        // );

        FilePickerResult result = await (FilePicker.platform.pickFiles(
          type: FileType.video,
        ) as Future<FilePickerResult>);

        _path = result.files.single.path;
      }

      uploadToFirebase();
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
  }

  uploadToFirebase() {
    if (_multiPick) {
      _paths.forEach((fileName, filePath) => {upload(fileName, filePath)});
    } else {
      String fileName = _path!.split('/').last;
      String filePath = _path!;
      upload(fileName, filePath);
    }
  }

  upload(fileName, filePath) {
    _extension = fileName.toString().split('.').last;
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
    final UploadTask uploadTask = storageRef.putFile(
      File(filePath),
      SettableMetadata(
        contentType: '$_pickType/$_extension',
      ),
    );
    setState(() {
      _tasks.add(uploadTask);
    });
  }

  String _bytesTransferred(TaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalBytes}';
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    _tasks.forEach((UploadTask task) {
      final Widget tile = UploadTaskList(
        task: task,
        onDismissed: () => setState(() => _tasks.remove(task)),
        onDownload: () => downloadFile(task.snapshot.ref),
      );
      children.add(tile);
    });

    return MaterialApp(
      home: new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text(widget.title),
        ),
        body: new Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              OutlineButton(
                onPressed: () => openFileExplorer(),
                child: new Text("Open file picker"),
              ),
              SizedBox(
                height: 20.0,
              ),
              Flexible(
                child: ListView(
                  children: children,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> downloadFile(Reference ref) async {
    final String url = await ref.getDownloadURL();
    var url2 = Uri.parse(url);
    final http.Response downloadData = await http.get(url2);
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/tmp.jpg');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final DownloadTask task = ref.writeToFile(tempFile);
    // final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    final int byteCount = (await task).totalBytes;
    // final int byteCount = (await task.future).totalByteCount;
    var bodyBytes = downloadData.bodyBytes;
    final String name = await ref.name;
    // final String name = await ref.getName();
    final String path = await ref.fullPath;
    // final String path = await ref.getPath();
    print(url);
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Image.memory(
          bodyBytes,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class UploadTaskList extends StatelessWidget {
  const UploadTaskList({Key? key, this.task, this.onDismissed, this.onDownload})
      : super(key: key);

  final UploadTask? task;
  final VoidCallback? onDismissed;
  final VoidCallback? onDownload;

  String? get status {
    String? result;

    if (task!.snapshot.state == TaskState.success) {
      result = "Complete";
    } else if (task!.snapshot.state == TaskState.canceled) {
      result = "Cancelled";
    } else if (task!.snapshot.state == TaskState.error) {
      result = "Failed Error: ${TaskState.error}";
    } else if (task!.snapshot.state == TaskState.running) {
      result = "Uploading";
    } else if (task!.snapshot.state == TaskState.paused) {
      result = "Paused";
    }

    /// Miriam's old implmentation
    // if (task.isComplete) {
    //   if (task.isSuccessful) {
    //     result = 'Complete';
    //   } else if (task.isCanceled) {
    //     result = 'Canceled';
    //   } else {
    //     result = 'Failed ERROR: ${task.lastSnapshot.error}';
    //   }
    // } else if (task.isInProgress) {
    //   result = 'Uploading';
    // } else if (task.isPaused) {
    //   result = 'Paused';
    // }
    return result;
  }

  String _bytesTransferred(TaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalBytes}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskSnapshot>(
      stream: task!.snapshotEvents,
      builder:
          (BuildContext context, AsyncSnapshot<TaskSnapshot> asyncSnapshot) {
        Widget subtitle;
        Widget? prog;
        Widget progtext;
        if (asyncSnapshot.hasData) {
          final TaskSnapshot event = asyncSnapshot.data!;
          final TaskSnapshot snapshot = event;
          subtitle = Text('$status: ${_bytesTransferred(snapshot)}');
          double _progress =
              event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          prog = LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.red,
          );
          progtext = Text('${(_progress * 100).toStringAsFixed(2)} %');
        } else {
          subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed!(),
          child: ListTile(
            title: subtitle,
            // Text('Upload Task #${task.hashCode}'),

            subtitle: prog,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: task!.snapshot.state !=
                      TaskState.running, // !task.isInProgress
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task!.pause(),
                  ),
                ),
                Offstage(
                  offstage: task!.snapshot.state !=
                      TaskState.paused, // !task.isPaused
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task!.resume(),
                  ),
                ),
                Offstage(
                  offstage: task!.snapshot.state ==
                      TaskState.success, // task.isComplete
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task!.cancel(),
                  ),
                ),
                Offstage(
                  offstage: !(task!.snapshot.state == TaskState.success),
                  child: IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
