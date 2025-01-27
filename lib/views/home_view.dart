import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: const Text("Home View",style: TextStyle(
          fontSize: 25,
          color: AppColors.whiteColor
        ),),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 100),
        child: Center(
          child: Column(

            children: [

              Stack(
                children: [
                  CircleAvatar(
                    radius: 100,
                  )
                ],
              ),
              SizedBox(height: 50),
              Text("Email"),

              ListTile(
                title: Text("Name"),
                trailing: Icon(Icons.edit),
              )

            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30,right: 10),
        child: FloatingActionButton(onPressed: (){},child: Icon(Icons.login_sharp),),
      ),
    );
  }
}
