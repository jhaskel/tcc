import 'dart:html';
import 'package:flutter/material.dart';
import 'package:image_web_picker/imagePiker.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:unigran_tcc/utils/alert.dart';

class Imag extends StatefulWidget {

  @override
  _ImagState createState() => _ImagState();
}

class _ImagState extends State<Imag> {

  var picker = ImagePickerWeb();
  List<dynamic> _listaImagens = List();
  List<String> _imagensFinal = List();
  fb.UploadTask _uploadTask;
  var image;
  String image2;
  Image imagem;
  double progressPercent = 0;
  String msg = '';
  bool _showProgress = false;

  @override
  Widget build(BuildContext context) {
    print('teste');
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de Categorias"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  _body() {

    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child:  Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Text(''),
                  ),
                  Center(
                    child: picker.image_memory == null
                        ? Text('')
                        : Text(''),
                  ),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(msg),
                        Container(
                          width: 600,
                          child: _listaImagens.length > 0 ?Container(
                            height: 300,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _listaImagens.length,
                              itemBuilder: (context, index){
                                return Image.memory(_listaImagens[index],height: 200,width: 200,);
                              },
                            ),

                          ):Container(),
                        ),
                        Container(
                          height: 300,
                          width: 300 ,
                          child: _listaImagens.length < 3 ? IconButton(
                            onPressed: () async {
                              picker = await ImagePickerWeb().getImage();
                              if(picker.image_memory.length > 0){
                                uploadImageToFirebase(picker);
                              }

                            },
                            icon: Icon(Icons.cloud_upload,size: 100,),
                          ):Container(),
                        ),

                      ],

                    ),
                  ),
                  StreamBuilder<fb.UploadTaskSnapshot>(
                    stream: _uploadTask?.onStateChanged,
                    builder: (context, snapshot) {
                      final event = snapshot?.data;
                      // Default as 0
                      progressPercent = event != null
                          ? event.bytesTransferred / event.totalBytes * 100
                          : 0;
                      if (progressPercent == 100) {
                        snapshot.data.ref.getDownloadURL().then((value) {
                            image2 = value.toString();
                            picker.image_memory = null;
                            print('ix${_imagensFinal.length}');
                            _imagensFinal.add(image2);
                            var gh = _imagensFinal.map((e) => e.toLowerCase()).toSet();
                            print('ix${gh}');
                            print('ix${msg}');
                        });
                        return  Text("");
                      } else if (progressPercent == 0) {

                        return  Text("");
                      } else {
                        return Center(
                          child: LinearProgressIndicator(
                            value: progressPercent,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }

  uploadToFirebase(File file) async {

    final extensao = file.type.split('/');
    print('ext${extensao}');
    String ext = extensao[1];
    print("modficado=${ext[1]}");

    if( ext== 'jpeg' || ext == 'png'){


        if(file.size > 1999999){
          toast(context,'Imagem muito grande!\nMax 2M',duration: 3);


        print('Imagem muito grande ${file.size}');

      }else{
          setState(() {
            _listaImagens.add(picker.image_memory);
          });
        final filePath = 'img2/${DateTime.now().millisecondsSinceEpoch.toString()}.png';
        final ref = "gs://app-orse.appspot.com";
        setState(() {

          _uploadTask = fb
              .storage()
              .refFromURL(ref)
              .child(filePath)
              .put(file);
        });
      }
    }else{
      print('3x');
     toast(context,'Documentos precisa ser imagem jpg ou png !',duration: 3);

    }
  }
  @override
  void dispose() {
    _uploadTask?.cancel();
    super.dispose();
  }

Future uploadImageToFirebase(ImagePickerWeb imagePickerWeb) async {

  setState(() {
    image = imagePickerWeb.image_upload;
  });
  uploadToFirebase(image);

}

}