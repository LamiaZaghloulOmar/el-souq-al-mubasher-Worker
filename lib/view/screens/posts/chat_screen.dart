import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:efood_multivendor_driver/data/cacheHelper.dart';
import 'package:efood_multivendor_driver/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../util/dimensions.dart';
import '../../../util/styles.dart';

class ChatScreen extends StatefulWidget {
  String name;
  String ServiceId;
  String UserId;
  String image;
  bool NotfromAll = true;
  ChatScreen(
      {Key key,
      this.name,
      this.ServiceId,
      this.UserId,
      this.image,
      this.NotfromAll})
      : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var textController = TextEditingController();
  sendMessage(String Text) async {
    if (widget.NotfromAll)
      await FirebaseFirestore.instance
          .collection(widget.UserId)
          .doc(int.parse(widget.ServiceId).toString())
          .set({
        "ServiceImage": widget.image,
        "UserImage": CacheHelper.getData(key: "UserImage"),
        "ServiceName": widget.name,
        "ServiceProviderId": widget.ServiceId,
        "UserId": widget.UserId,
        "UserName": CacheHelper.getData(key: "UserName"),
      });
    await FirebaseFirestore.instance
        .collection(widget.UserId)
        .doc(int.parse(widget.ServiceId).toString())
        .collection("messages")
        .add({
      "message": Text,
      "ID": widget.ServiceId,
      "createdAt": DateTime.now()
    });
  }

  Stream<QuerySnapshot> getChatMessage() {
    print(widget.UserId);
    print(widget.ServiceId);
    return FirebaseFirestore.instance
        .collection(widget.UserId)
        .doc(widget.ServiceId)
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Widget mineMessage(String text) => Align(
        child: Container(
          margin: EdgeInsets.only(top: 4),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(text,style: TextStyle(color: Theme.of(context).cardColor),),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        alignment: AlignmentDirectional.centerEnd,
      );

  Widget otherMessage(String text) => Align(
        child: Container(
          margin: EdgeInsets.only(top: 4),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(text),
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            ),
          ),
        ),
        alignment: AlignmentDirectional.centerStart,
      );
  @override
  Widget build(BuildContext context) {
    return 
    // Directionality(
      // textDirection: TextDirection.ltr,
      // child:
       Scaffold(
          appBar: AppBar(title:Text(widget.name,style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, 
      color: Theme.of(context).cardColor,))),
          body: Column(children: [
            StreamBuilder(
              stream: getChatMessage(),
              builder: (context, snapshot) {
                return Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount:
                        snapshot.data != null ? snapshot.data.docs.length : 0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.hasData || snapshot.data.docs != null) {
                        print("ID FROM SNAP ${snapshot.data.docs[index]["ID"]}");
                        print(widget.ServiceId);
                        if (int.parse(snapshot.data.docs[index]["ID"]) ==
                            int.parse(widget.ServiceId))
                          return mineMessage(
                            snapshot.data.docs[index]["message"],
                          );
                        else
                          return otherMessage(
                            snapshot.data.docs[index]["message"],
                          );
                      } else {
                        print(snapshot.connectionState);
                        return Center(
                          child: Container(
                            child: Text("لا يوجد رسالة"),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.grey)),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "     اكتب رسالتك",
                            contentPadding: EdgeInsets.only(left: 15),
                            border: InputBorder.none,
                          ),
                          controller: textController,
                        )),
                        Container(
                          color: Theme.of(context).primaryColor,
                          child: IconButton(
                            icon: Icon(Icons.send,color: Colors.white,),
                            onPressed: () async {
                              if (textController.text != "") {
                                sendMessage(textController.text);
                                textController.text = "";
                              }
                            },
                          ),
                        ),
                      ]),
                ))
          ])
          // ),
    );
  }
}
