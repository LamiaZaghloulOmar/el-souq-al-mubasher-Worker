import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:efood_multivendor_driver/data/cacheHelper.dart';
import 'package:efood_multivendor_driver/util/app_constants.dart';
import 'package:efood_multivendor_driver/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_driver/view/base/custom_image.dart';
import 'package:efood_multivendor_driver/view/screens/posts/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({Key key}) : super(key: key);

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  @override
  void initState() {
    print("UserId + ${CacheHelper.getData(key: "UserId")}");
    getAllUsers();
    super.initState();
  }

  List users = [];
  List<String> collectiosId = [];
  getAllUsers() async {
    print(CacheHelper.getData(key: AppConstants.UserId));

// await FirebaseFirestore.instance.collection("collectionsId").doc().get();

    await FirebaseFirestore.instance
        .collection("collectionsId")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          collectiosId.add(element.id);
        });
      });
    }).then((value) {
      collectiosId.forEach((element) async {
        await FirebaseFirestore.instance
            .collection(element)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            setState(() {
              if (element.id == CacheHelper.getData(key: AppConstants.UserId))
              // print(element);
              // print(element.data());
                users.add(element.data());
                print(users);
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "الرسائل", isBackButtonExist: false),
      body: users.isEmpty
          ? Center(
              child: Text("لا يوجد رسائل"),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) =>
                  Container( 
                    margin: EdgeInsets.only(bottom: 10,left: 5,right: 5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                          border: Border.all(
                                          width: 0.5,
                                          color: Theme.of(context).primaryColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                 child:  InkWell(
                        onTap: () {
                          Get.to(ChatScreen(
                            name: users[index]["UserName"],
                            image: users[index]["ServiceImage"],
                            ServiceId: users[index]["ServiceProviderId"],
                            UserId: users[index]["UserId"],
                            NotfromAll: false,
                          ));
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                  ClipOval(
                                      child: CustomImage(
                                    image:users[index]["UserImage"]==null?'https://www.w3schools.com/howto/img_avatar.png':
                                    'https://www.w3schools.com/howto/img_avatar.png',
                                        //  "${AppConstants.BASE_URL}/storage/app/public/profile/${users[index]["UserImage"]}",
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )), 
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  users[index]["UserName"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: Colors.white,
                              thickness: 0.5,
                              height: 0,
                              indent: 20,
                              endIndent: 20,
                            )
                          ],
                        ),
                      ))),
            ),
    );
  }
}
 