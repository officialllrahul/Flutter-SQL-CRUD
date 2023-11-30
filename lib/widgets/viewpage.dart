import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'db_helper.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({Key? key}) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  List<Map<String, dynamic>> _viewDataList = [];
  bool _isLoading = true;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future getImageGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future getImageCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _refreshJournals() async {
    final data = await DatabaseHelper.instance.queryDatabase();
    setState(() {
      _viewDataList = data ?? [];
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  final TextEditingController updateNameController = TextEditingController();
  final TextEditingController updateEmailController = TextEditingController();
  final TextEditingController updateContactController = TextEditingController();
  var updatePic;
  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal = _viewDataList.firstWhere((element) => element['id'] == id);
      updateNameController.text = existingJournal['name'];
      updateEmailController.text = existingJournal['email'];
      updateContactController.text = existingJournal['contact'];
      updatePic = existingJournal['image_path'];
    }
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    getImageGallery();
                  },
                  onDoubleTap: (){
                    getImageCamera();
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: _image != null
                        ? Image.file(_image!.absolute)
                        : Center(child: Image.file(File(updatePic))),
                  ),
                ),
              ),
              TextField(
                controller: updateNameController,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: updateEmailController,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              TextField(
                controller: updateContactController,
                decoration: const InputDecoration(hintText: 'Contact'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await _updateItem(id);
                  updateNameController.text = '';
                  updateEmailController.text = '';
                  updateContactController.text = '';
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Create New' : 'Update'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateItem(int? id) async {
    if (_image != null) {
      // Save the image to the app's documents directory
      final appDocDir = await getApplicationDocumentsDirectory();
      final imagePath = '${appDocDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
      await _image!.copy(imagePath);
      await DatabaseHelper.instance.updateRecord(
        {
          DatabaseHelper.columnId: id,
          DatabaseHelper.columnImagePath: imagePath,
          DatabaseHelper.columnName: updateNameController.text,
          DatabaseHelper.columnEmail: updateEmailController.text,
          DatabaseHelper.columnContact: updateContactController.text,
        },
      );
    };
    _refreshJournals(); // Refresh the list after updating
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ViewPage update and delete"),
      ),
      body: _isLoading
          ? SingleChildScrollView(child: const Center(child: CircularProgressIndicator())
      )
          :ListView.builder(
                    itemCount: _viewDataList.length,
                    itemBuilder: (context, index) {
            final id = _viewDataList[index]['id'].toString();
            final imagePath = _viewDataList[index]['image_path'] as String?;
            final name = _viewDataList[index]['name'] as String?;
            final email = _viewDataList[index]['email'] as String?;

            return SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 17,
                    child: imagePath != null
                        ? Image.file(File(imagePath),height: 100,width: 100)
                        : const Icon(Icons.image), // Placeholder if imagePath is null
                  ),
                  title: Text(name ?? 'No Name'),
                  subtitle: Text(email ?? 'No Email'),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showForm(int.parse(id));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteItem(int.parse(id));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
                    },
                  ),
    );
  }

  Future<void> _deleteItem(int id) async {
    await DatabaseHelper.instance.deleteRecord(id);
    _refreshJournals(); // Refresh the list after deleting
  }
}
