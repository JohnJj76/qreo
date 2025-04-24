import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart.';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile;
  //
  // octener la imagen de la galeria
  Future pickImage() async {
    // picker
    final ImagePicker picker = ImagePicker();
    // octener de la galeria del movil
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // update image preview
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  // subir la imagen al storage
  Future uploadImage() async {
    if (_imageFile == null) return;

    //generate a unique file path
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'uploads/$fileName';

    //subil la imagen al storage de supabase
    await Supabase.instance.client.storage
        .from('images')
        .upload(path, _imageFile!)
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Imagen cargada satisfactoriamente')),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Page')),
      body: Center(
        child: Column(
          children: [
            _imageFile != null
                ? Image.file(_imageFile!, height: 200, width: 200)
                : const Text('No hay imagen seleccionada...'),
            //
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Seleccionar Imagen'),
            ),
            //
            ElevatedButton(
              onPressed: uploadImage,
              child: const Text('Subir la Imagen'),
            ),
          ],
        ),
      ),
    );
  }
}
