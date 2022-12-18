import 'dart:convert';
import 'package:efood_multivendor_driver/util/app_constants.dart';
import 'package:efood_multivendor_driver/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_driver/view/base/custom_image.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../data/cacheHelper.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';

class PostComent {
  int id;
  String userFname;
  String price;
  String userLname;
  String userId;
  String comment;
  String image;
  String orderId;
  String createdAt;
  String updatedAt;

  PostComent(
      {this.id,
      this.userFname,
      this.userLname,
      this.userId,
      this.comment,
      this.image,
      this.orderId,
      this.createdAt,
      this.updatedAt,
      this.price});

  PostComent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    userFname = json['user_fname'];
    userLname = json['user_lname'];
    userId = json['user_id'];
    comment = json['comment'];
    image = json['image'];
    orderId = json['order_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['user_fname'] = this.userFname;
    data['user_lname'] = this.userLname;
    data['user_id'] = this.userId;
    data['comment'] = this.comment;
    data['image'] = this.image;
    data['order_id'] = this.orderId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class PostComments extends StatefulWidget {
  int id;
  bool isLoad = false;
  PostComments({Key key, @required this.id}) : super(key: key);
  List<PostComent> postComments = [];
  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  showDataAlert(
      {BuildContext context, text, id, TextEditingController text2form}) async {
    text2form.text = text;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              contentPadding: EdgeInsets.all(
                  0.0,
              ),
              titlePadding: EdgeInsets.all(0),
              title:Container(
                height: 50,
                  decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                           borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),),
                padding: EdgeInsets.only(top: 15),
                
                child:  Text(
                "تعديل التعليق",
                textAlign: TextAlign.center,
                
                style: TextStyle(fontSize: 16.0,color: Theme.of(context).cardColor),
              )),
              content: Container(
                height: 180,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 15,),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: text2form,
                        keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'ادخل التعليق',
                            labelText: 'التعليق',
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 60,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            await http.post(
                                Uri.parse(
                                    "http://elsouqalmubasher.com/api/v1/services/update-comment/$id"),
                                body: {
                                  "token": CacheHelper.getData(
                                      key: AppConstants.TOKEN),
                                  "comment": text2form.text
                                }).then((value) {
                              print(value.statusCode);
                              print(value.body);
                              getComments(widget.id);
                            });
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            // fixedSize: Size(250, 50),
                          ),
                          child: Text(
                            "حفظ",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  showData2Alert(
      {BuildContext context, TextEditingController text2form}) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              contentPadding: EdgeInsets.only(
                top: 10.0,
              ),
              title: Text(
                "Add Price",
                style: TextStyle(fontSize: 24.0),
              ),
              content: Container(
                height: 300,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: text2form,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Price here',
                            labelText: 'Price',
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 60,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            // fixedSize: Size(250, 50),
                          ),
                          child: Text(
                            "Save",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  var textController = TextEditingController();
  var text2form = TextEditingController();
  var text22form = TextEditingController();
  @override
  void initState() {
    super.initState();
    getComments(widget.id);
  }

  void getComments(id) async {
    setState(() {
      widget.isLoad = false;
    });
    http.Response response = await http.get(Uri.parse(
        "${AppConstants.BASE_URL}${AppConstants.POST_COMMENTS}/${id.toString()}"));
    if (response.statusCode == 200) {
      widget.postComments = [];
      jsonDecode(response.body)[0].forEach((e) {
        setState(() {
          widget.postComments.add(PostComent.fromJson(e));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          centerTitle: true,
          title: Text('العروض المقدمة',style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, 
      color: Theme.of(context).cardColor,)),
        ),
        //  CustomAppBar(
        //   title: "Comments",
        // ),
        body: Column(
          children: [
            Expanded(
              child: widget.postComments.isEmpty
                  ? Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.comments_disabled_rounded, size: 30),
                            Text("لا يوجد عروض مقدمة حتي الأن",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ]),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        controller: scrollController,
                        itemBuilder: ((contextu, index) {
                          return Container(
                            // color: Colors.red,
                             decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                            child:
                           Stack(
                            alignment: Alignment.centerRight,

                            children: [
                             Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                     borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
    )
                                    ),
                              padding: EdgeInsets.only(bottom: 20,top: 5,right: 100,left: 10),
                              child:  Row(
                                children: [
                                  //  Column(
                                  //   children: [
                                      // Row(
                                      //   children: [
                                           Container(
                                             padding: EdgeInsets.only(left:15,right:15),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                200,
                                        child: Text(widget
                                            .postComments[index].comment,
                                            style: TextStyle(fontSize: 15,color: Colors.black),)),
                                      //   ],
                                      // ),
                                     
                                  //   ],
                                  // ),
                                  Spacer(),
                                  if (int.parse(
                                          widget.postComments[index].userId) ==
                                      int.parse(CacheHelper.getData(
                                          key: AppConstants.UserId)))
                                    Container(
                                     
                                        child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Container(
                                              child: Row(children: [
                                                PopupMenuButton(
                                                  icon: Icon(Icons.more_vert,
                                                      color: Colors.black),
                                                  itemBuilder: (contextt) => [
                                                    PopupMenuItem(
                                                      // enabled: false,
                                                      child: InkWell(
                                                          onTap: () {
                                                            showDataAlert(
                                                                context:
                                                                    context,
                                                                id: widget
                                                                    .postComments[
                                                                        index]
                                                                    .id,
                                                                text: widget
                                                                    .postComments[
                                                                        index]
                                                                    .comment,
                                                                text2form:
                                                                    text2form);
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text("تعديل"),
                                                            ],
                                                          )),
                                                    ),
                                                    PopupMenuItem(
                                                      onTap: () async {
                                                        http.Response res =
                                                            await http.post(
                                                                Uri.parse(
                                                                    "http://elsouqalmubasher.com/api/v1/services/delete-comment/${widget.postComments[index].id}"),
                                                                body: {
                                                              "token": CacheHelper
                                                                  .getData(
                                                                      key: AppConstants
                                                                          .TOKEN),
                                                            });
                                                        if (res.statusCode ==
                                                            200) {
                                                          print("Deleted!");
                                                          getComments(
                                                              widget.id);
                                                        }
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text("مسح"),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ]),
                                            )))
                                
                                ],
                              )),
                              SizedBox(height: 3),
                           Container(
                             decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                     borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
    )),
                            
                            child:   Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 15),
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10,),
                                   Row(
                                  children: [

                                      Text(
                                              widget.postComments[index]
                                                  .userLname??"",
                                              style: TextStyle(
                                                color: Theme.of(context).cardColor,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(width: 2),
                                          Text(
                                              widget.postComments[index]
                                                  .userFname??"",
                                              style: TextStyle(
                                                color: Theme.of(context).cardColor,
                                                  fontWeight: FontWeight.bold)),
                                 
                                            Spacer(),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top:8.0,bottom: 10,left: 15,right: 15),
                                          child: Text(
                                              "${widget.postComments[index].price.toString()} ريال",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        )),
                                  ],
                                ),
                                //  SizedBox(height: 3),
                                     
                                    Text( "${widget.postComments[index].updatedAt.split('T')[0]
                                    +'  '+widget.postComments[index].updatedAt.split('T')[1].split('.')[0]}"
                                     ,style: TextStyle(color: Theme.of(context).cardColor,), ),
                                      
                            ])
                              )),
                              // SizedBox(height: 3),
                              // if (catController.postsList[index].image != null)
                              //   InkWell(
                              //     onTap: () {
                              //       Navigator.push(context,
                              //           MaterialPageRoute(builder: (_) {
                              //         return FullImageScreen(
                              //             '${AppConstants.BASE_URL}/storage/app/public/serviceorder/${catController.postsList[index].image}');
                              //       }));
                              //     },
                              //     child: Hero(
                              //       tag: 'imageHero',
                              //       child: Container(
                              //         height: 300,
                              //         width: double.infinity,
                              //         child: Image.network(
                              //             '${AppConstants.BASE_URL}/storage/app/public/serviceorder/${catController.postsList[index].image}',
                              //             fit: BoxFit.contain),
                              //       ),
                              //     ),
                              //   )
                              SizedBox(
                                height: 1,
                              ),
                            ],
                          ),
                         Container(
                          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/1.5,
                          bottom: 50),
          // alignment: Alignment.centerRight,
        child:   Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: Theme.of(context).cardColor),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child:
                                        ClipOval(
                                      child: CustomImage(
                                    image: widget.postComments[index].image==null|| widget.postComments[index].image.isEmpty?'https://www.w3schools.com/howto/img_avatar.png':
                                        "${AppConstants.BASE_URL}/storage/app/public/delivery-man/${widget.postComments[index].image}",
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  )),
                                             
         )),
                          ]));
                        }),
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Divider(thickness: 1),
                        ),
                        itemCount: widget.postComments.length,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0,right: 10,left: 10),
              child: Container(
                padding: EdgeInsets.all(10),
                // clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey)),
                child:Column(children: [
                   Container(
                    padding: EdgeInsets.only(left:15,right:15),
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey)),
                    // height: 100,
                        child: TextFormField(
                      decoration: InputDecoration(
                        hintText: " اكتب تعليقك ...",
                        contentPadding: EdgeInsets.only(left: 15),
                        border: InputBorder.none,
                      ),
                      controller: textController,
                    )),
                    SizedBox(height: 10,),
                    //  InkWell(
                    //         child:
                            Container(
                               padding: EdgeInsets.only(left:15,right:15),
                                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey)),
                              child:
                              TextFormField(
                                keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: " اضف السعر",
                        contentPadding: EdgeInsets.only(left: 15),
                        border: InputBorder.none,
                      ),
                      controller: text22form,
                    ) 
                  
                              // ),   
                          ),
                          SizedBox(height: 10,),
 ElevatedButton(
  // color: Colors.red,
                            child:Container(child:Center(child: Text("ارسال",style: TextStyle(fontSize: 15),)),
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            ),
                            onPressed: () async {
                              if (textController.text.isNotEmpty) {
                                if (text22form.text.isNotEmpty) {
                                  http.Response res = await http.post(
                                      Uri.parse(
                                          "http://elsouqalmubasher.com/api/v1/services/service-comment"),
                                      body: {
                                        "order_id": widget.id.toString(),
                                        "comment": textController.text,
                                        "token": CacheHelper.getData(
                                            key: AppConstants.TOKEN),
                                        "price": text22form.text
                                      });
                                  print(res.body);
                                  if (res.statusCode == 200) {
                                    setState(() {
                                      textController.text = "";
                                      text22form.text = "";
                                    });
                                    print("Post Comment Success");
                                    setState(() {
                                      widget.isLoad = true;
                                    });
                                    getComments(widget.id);
                                    // if (!scrollController.hasClients) {
                                      
                    //                  scrollController.animateTo(-500,
                    // duration: Duration(seconds: 1), curve:Curves.easeOut);
                                    // }
                                  }else{
                                     showCustomSnackBar("حدث خطا الرجاء المحاوله مرة اخري");
                                  }
                                } else {
                                  showCustomSnackBar("برجاء اضافة سعر الخدمة!");
                                }
                              } else {
                                showCustomSnackBar(
                                    "لا يمكن ارسال تعليق فارغ !");
                              }
                            },
                          ),
                ],)
                
                //  Row(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     Expanded(
                //         child: TextFormField(
                //       decoration: InputDecoration(
                //         hintText: " اكتب تعليقك ...",
                //         contentPadding: EdgeInsets.only(left: 15),
                //         border: InputBorder.none,
                //       ),
                //       controller: textController,
                //     )),
                //     Container(
                //       color: Colors.blue,
                //       child: Row(
                //         children: [
                //           SizedBox(width: 10),
                //           InkWell(
                //             child: Text("اضافة سعر",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                //             onTap: () async {
                //               showData2Alert(
                //                   context: context, text2form: text22form);
                //             },
                //           ),
                //           IconButton(
                //             icon: Icon(Icons.send,color: Colors.white),
                //             onPressed: () async {
                //               if (textController.text.isNotEmpty) {
                //                 if (text22form.text.isNotEmpty) {
                //                   http.Response res = await http.post(
                //                       Uri.parse(
                //                           "http://elsouqalmubasher.com/api/v1/services/service-comment"),
                //                       body: {
                //                         "order_id": widget.id.toString(),
                //                         "comment": textController.text,
                //                         "token": CacheHelper.getData(
                //                             key: AppConstants.TOKEN),
                //                         "price": text22form.text
                //                       });
                //                   print(res.statusCode);
                //                   if (res.statusCode == 200) {
                //                     setState(() {
                //                       textController.text = "";
                //                       text22form.text = "";
                //                     });
                //                     print("Post Comment Success");
                //                     setState(() {
                //                       widget.isLoad = true;
                //                     });
                //                     getComments(widget.id);
                //                   }
                //                 } else {
                //                   showCustomSnackBar("برجاء اضافة سعر الخدمة!");
                //                 }
                //               } else {
                //                 showCustomSnackBar(
                //                     "لا يمكن ارسال تعليق فارغ !");
                //               }
                //             },
                //           ),
                //         ],
                //       ),
                    // ),
                  // ],
                // ),
              ),
            ),
          ],
        ));
  }
  ScrollController scrollController = ScrollController();

}
