import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yellowclass_assignment/View/video_player.dart';

class HomePage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }

}

class HomePageState extends State<HomePage> {
  ScrollController _controller=ScrollController();
  final _middlePadding = 2.0 ; // padding of centered items
  final _edgesPadding = 2.0 ; // padding of non-centered items
  var _itemSize;
  final int _centeredItems = 1 ;
  int _numberOfEdgesItems =0; // number of items which aren't centered at any moment
  int _aboveItems =0; // number of items above the centered ones
  int _belowItems =0; // number of items below the centered ones;
  bool scroll = false;
  @override
  void initState() {
    _controller = ScrollController(); // Initializing ScrollController
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
          var width=MediaQuery.of(context).size.width;
          var height=MediaQuery.of(context).size.height;
          _itemSize=height*0.35;
          return Scaffold(
            backgroundColor: Colors.yellow,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.0), // here the desired height
                child: AppBar(
                  backgroundColor: Color(0xFF212121),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/logo.png'),
                  ),
                  title: Text('YellowClass',style: GoogleFonts.podkova(color: Colors.white),),
                  actions: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.notifications_active_outlined,color: Colors.white,),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.search,color: Colors.white,),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 17,
                        child: Icon(Icons.person,size: 30,),
                      ),
                    ),
                  ],
                )
            ),
            body:FutureBuilder<List<Video>>(
              future: getVideoDetails(),
            builder: (context, snapshot) {
            if (snapshot.hasData == false) {
            return  const Center(child: CircularProgressIndicator());
            }
            else {
            return NotificationListener(
              child: ListView.builder(
              controller: _controller ,
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                _numberOfEdgesItems = ( (MediaQuery.of(context).size.height - _centeredItems*(_itemSize + 2*(_middlePadding))) ~/ (_itemSize + 2*(_edgesPadding)) ) ;
                _aboveItems = ( ( (_controller.offset) / (_itemSize + 2*(_edgesPadding)) ) + _numberOfEdgesItems/2 ).toInt() ;
                _belowItems = _aboveItems + _centeredItems ;
                return   Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF212121),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        height: _itemSize,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            index >= _aboveItems && index < _belowItems && scroll ?Expanded(child: VideoPlayerRemote(url: snapshot.data![index].videoUrl)):Image.network(snapshot.data![index].cover,fit: BoxFit.fill,),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 8, 0, 0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 20,
                                      child: Center(child: Text(snapshot.data![index].id.toString(),style: GoogleFonts.podkova(fontSize: 24,),),)
                                    ),
                                  ),
                                  Text(snapshot.data![index].title, style: GoogleFonts.podkova(fontSize: 24,color: Colors.white),),
                                ],
                              )
                            ),
                          ],
                        ),
                  ),
                );
              }),
              onNotification: (notificationInfo) {
                if (notificationInfo is ScrollStartNotification) {
                   scroll=false;
                   setState((){});
                }
                if (notificationInfo is ScrollEndNotification) {
                  scroll=true;
                  setState((){});
                }
                return true;
              },
            );
            }
            }
              ),
      );
    }
  Future<List<Video>> getVideoDetails() async{
      String r=await rootBundle.loadString('assets/dataset.json');
      var x= jsonDecode(r);
      List<Video> y=[];
      for(var i in x)
        {
          y.add(Video(i["id"],i['title'],i['coverPicture'],i['videoUrl']));
        }
      return y;
  }
  }

  class Video {
    var id;
    var title;
    var videoUrl;
    var cover;
    Video(this.id,this.title,this.cover,this.videoUrl);
  }