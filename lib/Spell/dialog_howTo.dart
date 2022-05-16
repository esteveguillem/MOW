import 'dart:ui';


import 'package:MindOfWords/Spell/constants.dart';
import 'package:MindOfWords/Spell/text_to_speech.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialogHowTo extends StatefulWidget {
  final String title, descriptions, text, text2;
  final Image img;
  final int points;

  const CustomDialogHowTo({Key? key, required this.title, required this.descriptions, required this.text, required this.img, required this.points, required this.text2}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogHowTo> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: Constants.padding,top: Constants.avatarRadius
              + Constants.padding, right: Constants.padding,bottom: Constants.padding
          ),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: <Widget>[
              Align(
              alignment: Alignment.center,
              child: Text(widget.title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600), textAlign: TextAlign.center)
              ),

              SizedBox(height: 15,),
              Text("Description:",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
              Text("The game starts with 3 lives.",style: TextStyle(fontSize: 14),textAlign: TextAlign.left,),
              Text("A button, speaker, that spells the word.",style: TextStyle(fontSize: 14),textAlign: TextAlign.left,),
              Text("We will have a score that as we hit the word we will add a point.",style: TextStyle(fontSize: 14),textAlign: TextAlign.left,),
              SizedBox(height: 22,),
              Text("Instructions:",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
              Text("We have three lives, each mistake we make will lose 1 life and when we lose all (0) we will lose.",style: TextStyle(fontSize: 14),textAlign: TextAlign.left,),
              Text("By pressing the button like the one above, spell the word, we can press it as many times as we want.",style: TextStyle(fontSize: 14),textAlign: TextAlign.left,),
              SizedBox(height: 22,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        onPressed: (){
                          //===== TANCAR DIALOG =======
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(widget.text,style: TextStyle(fontSize: 18),)),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset("assets/spell_background.png")
            ),
          ),
        ),
      ],
    );
  }
}