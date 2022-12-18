import 'dart:convert';
import 'dart:io';

import 'package:efood_multivendor_driver/data/cacheHelper.dart';
import 'package:efood_multivendor_driver/util/app_constants.dart';
import 'package:efood_multivendor_driver/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_driver/view/base/custom_image.dart';
import 'package:efood_multivendor_driver/view/screens/home/home_screen.dart';
import 'package:efood_multivendor_driver/view/screens/posts/full_image.dart';
import 'package:efood_multivendor_driver/view/screens/posts/post_comments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PostsScreen extends StatefulWidget {
  List<Post> posts = [];
  bool isDeliver;
  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  getPosts() async {
    http.Response response = await http.get(Uri.parse(
        "http://elsouqalmubasher.com/api/v1/services/dm-orders/${CacheHelper.getData(key: AppConstants.TOKEN)}"),
        
        headers: {HttpHeaders.acceptLanguageHeader:"ar"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      widget.posts = [];
      jsonDecode(response.body)[0].forEach((c) {
        setState(() {
          widget.posts.add(Post.fromJson(c));
        });
      });
    } else {
      //ApiChecker.checkApi(response as Response);
    }
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title:  'posts'.tr, isBackButtonExist: false,),
      body: widget.posts.isEmpty
          ? Center(
              child: Text('no_Posts'.tr),
            )
          : RefreshIndicator(
              onRefresh: () async {
                return await getPosts();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  itemBuilder: ((context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                     Column(
                          children: [
                           Container(
                           padding: EdgeInsets.only(top: 10,bottom: 10,right: 10,left: 10),
                         decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                                                    borderRadius: BorderRadius.all(
       Radius.circular(10),
      
    ),
                                 
                                    border: Border.all(
                                        width: 0.5,
                                        color: Theme.of(context).primaryColor)),
                        child:  Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: Theme.of(context).cardColor),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: ClipOval(
                                      child: CustomImage(
                                    image:widget.posts[index].user_image==null?'https://www.w3schools.com/howto/img_avatar.png':
                                        '${AppConstants.BASE_URL}/storage/app/public/profile/${widget.posts[index].user_image}',
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )),
                                ),
                                SizedBox(width: 5,),
                                InkWell(
                                  onTap: () {
                                    Get.to(PostComments(
                                        id: widget.posts[index].id));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Text(widget.posts[index].user_name??"",
                                              style: TextStyle(
                                                color: Theme.of(context).cardColor,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                         'poststutas'.tr +"${widget.posts[index].status??""}",
                                          style: TextStyle(
                                                color: Theme.of(context).cardColor,)
                                         ),
                                    
                                      
                                    
                                    ],
                                  ),
                                ),
                              ],
                            )),
                          ],
                        // )
                        ),
                          SizedBox(height: 20),
                          Padding(
                                        padding: const EdgeInsets.only(bottom: 5.0,top:5,
                                        left: 30,right: 30),
                                        child: Container(
                                          
                                          child:
                                              Text(widget.posts[index].details,
                                              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                                        ),
                                      ),
                        SizedBox(height: 3),
                        if (widget.posts[index].image != null)
                        Center(child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width-50,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return FullImageScreen(
                                    '${AppConstants.BASE_URL}/storage/app/public/serviceorder/${widget.posts[index].image}');
                              }));
                            },
                            child:
                            //  Hero(
                              // tag: 'imageHero',
                              // child: 
                              Container(
                                // height: 300,
                                 decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
    ),
                                 
                                    border: Border.all(
                                        width: 0.5,
                                        color: Theme.of(context).primaryColor),
                                     
                                  ),
                                width: double.infinity,
                                child:ClipRRect(
                                                                                   borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
    ),
                                  child:  Image.network(
                                    '${AppConstants.BASE_URL}/storage/app/public/serviceorder/${widget.posts[index].image}',
                                    fit: BoxFit.cover),
                              ))),
                            // ),
                          )),
                       InkWell(
                        onTap: (){
                          Get.to(PostComments(
                                        id: widget.posts[index].id));
                        },
                        child: Center(child:  Container(
                            width: MediaQuery.of(context).size.width-50,
                            // margin: EdgeInsets.only(left: 15,right: 15),
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
    ),
                                    border: Border.all(
                                        width: 0.5,
                                        color: Theme.of(context).primaryColor),
                                     
                                  ),
                                child:  Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  SizedBox(width: 10,),
Text('تقدم للوظيفة',style: TextStyle(fontSize: 15,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                                  SizedBox(width: 4,),

Icon(Icons.comment,color: Theme.of(context).primaryColor),
// Spacer(),

//  SizedBox(width: 4,),
 


                                  ],),
                          height: 43,)),
                    )],
                    );
                  }),
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(thickness: 1),
                  ),
                  itemCount: widget.posts.length,
                ),
              ),
            ),
    );
  }
}
