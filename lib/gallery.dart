import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  _GalleryState createState() => _GalleryState();
}
class _GalleryState extends State<Gallery> {
  String keyword = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.cyan[900],
          foregroundColor: Colors.cyan[50],
          title: Text(keyword)
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(hintText: 'Keyword'),
              onChanged: (value){
                setState((){ keyword=value; });
              },
              onSubmitted: (value){
                Navigator.of(context).push(MaterialPageRoute(builder:(context)=>GalleryData(value)));
              },
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,20,0,0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan[900], foregroundColor: Colors.cyan[50]
                    ),
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder:(context)=>GalleryData(keyword)));
                    },
                    child: const Text('Get Data')
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GalleryData extends StatefulWidget {
  String keyWord = '';
  GalleryData(this.keyWord, {super.key});
  @override
  _GalleryDataState createState() => _GalleryDataState();
}
class _GalleryDataState extends State<GalleryData> {
  List<dynamic> data = [];
  int currentPage=1;
  int pageSize=10;
  int totalPages=0;
  final ScrollController _scrollController = ScrollController();
  dynamic dataGallery;
  List<dynamic> hits = [];
  getData(url){
    http.get(
        Uri.parse(url)
    ).then((resp){
      setState(() {
        dataGallery=json.decode(resp.body);
        hits.addAll(dataGallery['hits']);
        if(dataGallery['totalHits'] % pageSize==0) {
          totalPages = dataGallery['totalHits']~/pageSize;
        } else {
          totalPages = 1 + (dataGallery['totalHits']/pageSize).floor() as int;
        }
      });
    }).catchError((err){
      print(err);
    });
  }

  Future<void> _saveImage(BuildContext context, String url) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    late String message;

    try {
      // Download image
      final http.Response response = await http.get(
          Uri.parse(url));
      print('download');
      // Get temporary directory
      final dir = await getTemporaryDirectory();
      print('temp dir');
      // Create an image name
      var filename = '${dir.path}/SaveImage${Random(100).nextInt(100)}.png';
      print('file name');
      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);
      print('saving');
      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);
      print('ask user');
      if (finalPath != null) {
        message = 'Image saved to disk';
      }
    } catch (e) {
      message = e.toString();
      print(message);
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          message,
          style:  const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFe91e63),
      ));
    }

    if (message != null) {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFe91e63),
      ));

    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    _scrollController.addListener((){
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
        if(currentPage<totalPages){
          ++currentPage;
          loadData();
        }
      }
    });
  }
  @override void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  void loadData(){
    String url="https://pixabay.com/api/?key=44749483-ed4df4756c4af8779bcacb951&q=${widget.keyWord}&page=$currentPage&per_page=$pageSize&orientation=vertical&min_width=720";
    getData(url);
    print(url);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.keyWord} : $currentPage / $totalPages'),
        backgroundColor: Colors.cyan[900],
        foregroundColor: Colors.cyan[50]
      ),
        body: (dataGallery==null)? const Center(child: CircularProgressIndicator()):
      ListView.builder(
          controller:_scrollController ,
          itemCount: dataGallery==null?0:hits.length,
          itemBuilder: (context,index){
            return Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 5,right: 5,top: 0,bottom: 0),
                    child: Card(
                        color: const Color(0xFF006064),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor:Colors.cyan[50],
                                backgroundColor: Colors.cyan[900]
                            ),
                            onPressed: () async {
                              _saveImage(context, hits[index]['largeImageURL']);
                            },
                            child: Text(hits[index]['tags'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          )
                        )
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(right: 5,left: 5,top: 0,bottom: 0),
                    child: Card(
                      child: Image.network(
                        hits[index]['largeImageURL'],
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  ),
                  const Divider(color: Colors.grey,thickness: 2,),
                ]
            );
          })
    );
  }
}