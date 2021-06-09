import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Depreciation calculator',
  home: Maintab(),
  );
  }
}

class Maintab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MaintabState();
  }
}

class _MaintabState extends State<Maintab> {

  String finalanswer='''''';
  int current_year = 2000;
  final Yop = FocusNode();
  final Currentyear =FocusNode();
  final Quantity = FocusNode();
  final Dep = FocusNode();
  final Amount = FocusNode();
  final Map<String, dynamic> formData = {'Quantity': null, 'Amount': null, 'Currentyear': null, 'Dep': null, 'Yop': null};
  final _formKey = GlobalKey<FormState>();

  gourl(url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "Something went wrong :(",toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('Depic'),
        actions: [
          IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                displayModalBottomSheet(context);
              })/*,
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () => showDrawer(
              context: context,
              direction: DrawerDirection.topRight,
              builder: (_, __, close) => Container(
                width: displaySize(context).width*0.6,
                height: displaySize(context).height*0.455,
                child: Center(
                  child:morecard(context),
                ),
          ),)
          )*/
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(child: SingleChildScrollView(
            child:
            SafeArea(
              minimum: const EdgeInsets.all(40),
              child: _buildForm(),
            ),
          ),),
        ],
      )
    );
  }

  void displayModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return bottom();// return a StatefulWidget widget
        }
    );
  }


  getCurrentDate(){
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    setState(() {
      current_year = dateParse.year;
    });
    return current_year;
  }

  Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    return displaySize(context).width;
  }

  Widget _buildForm() {
    double tmp=displayHeight(context)*0.040;
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _Quantity(),
            space(tmp),
            _Amount(),
            space(tmp),
            _Currentyear(),
            space(tmp),
            _Dep(),
            space(tmp),
            _Yop(),
            space(tmp/2),
            Divider(thickness: 1, color: Colors.black),
            space(tmp/3),
            _buildSubmitButton(),
          ],
        ));
  }

  Widget _Quantity() {
    return TextFormField(
      decoration: new InputDecoration(
        labelText: "Quantity",
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: new BorderSide(
          ),
        ),
      ),
      validator: (String value) {if (value.isEmpty) return 'Hey! What was the quantity?';},
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onSaved: (String value) {
        formData['Quantity'] = value;
      },
      textInputAction: TextInputAction.next,
      focusNode: Quantity,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(Amount);
      },
    );
  }
  Widget _Amount() {
    return TextFormField(
      decoration: new InputDecoration(
        labelText: "Value amount",
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: new BorderSide(
          ),
        ),
      ),
      validator: (String value) {if (value.isEmpty) return 'Must not be empty!';},
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onSaved: (String value) {
        formData['Amount'] = value;
      },
      textInputAction: TextInputAction.next,
      focusNode: Amount,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(Currentyear);
      },
    );
  }

  Widget _Currentyear() {
    return TextFormField(
      decoration: new InputDecoration(
        labelText: "Current Year",
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: new BorderSide(color: Colors.black
          ),
        ),
      ),
      validator: (String value) {if (value.isEmpty) return "I guess it is "+getCurrentDate().toString(); },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onSaved: (String value) {
        formData['Currentyear'] = value;
      },
      textInputAction: TextInputAction.next,
      focusNode: Currentyear,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(Dep);
      },
    );
  }

  Widget _Dep() {
    return TextFormField(
      decoration: new InputDecoration(
        labelText: "Percentage of depreciation",
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: new BorderSide(
          ),
        ),
      ),
      validator: (String value) {if (value.isEmpty) return 'And what is the percentage of depreciation ?'; },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onSaved: (String value) {
        formData['Dep'] = value;
      },
      textInputAction: TextInputAction.next,
      focusNode: Dep,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(Yop);
      },
    );
  }
  Widget _Yop() {
    return TextFormField(
      decoration: new InputDecoration(
        labelText: "Year of purchase",
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: new BorderSide(
          ),
        ),
      ),
      validator: (String value) {if (value.isEmpty) return 'Please let me know the year of purchase'; },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      style: new TextStyle(
        fontFamily: "Poppins",
      ),
      onSaved: (String value) {
        formData['Yop'] = value;
      },
      focusNode: Yop,
      onFieldSubmitted: (v) {
        _submitForm();
      },
    );
  }
  Widget space(double amount) {
    return new Padding(padding: EdgeInsets.only(top: amount));
  }

  Widget _buildSubmitButton() {
    return MaterialButton(
      onPressed: () {
        _submitForm();
      },
      shape: const StadiumBorder(),
      height: 65,
      minWidth: displayWidth(context) * 0.80,
      textColor: Colors.white,
      color: Colors.black,
      splashColor: Colors.grey,
      child: Text(
        "Calculate",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save(); //onSaved is called!
      //double qty=double.parse(formData['Quantity']);
      double dep=double.parse(formData['Dep']);
      double amt=double.parse(formData['Amount']);
      double cyear=double.parse(formData['Currentyear']);
      double yr=double.parse(formData['Yop']);
      int a=0;
      double rr=cyear-yr;
      for( var i = 1 ; i <= rr; i++ ) {
        a=((amt*dep)/100).round();
        amt=amt-a;
      }
      finalanswer=amt.toString()+"\n";
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.black,
        duration: Duration(seconds: 4),
        icon: Icon(
          Icons.check,
          color: Colors.white,
        ),
        mainButton: IconButton(
          iconSize: 30,
          icon: Icon(Icons.content_copy),
          onPressed: () {
            Clipboard.setData(new ClipboardData(text:amt.toString()));
            Fluttertoast.showToast(msg: " Final answer: "+amt.toString()+" \n Copied to clipboard  ",toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            },
            tooltip: 'Copy to clipboard',
          color: Colors.white,
        ),
        titleText: Text(
          "Here's the result: ",
          style: TextStyle(fontSize: 18.0, color: Colors.green),
        ),

        messageText: Text(
          finalanswer,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
        ),
      )..show(context);
      finalanswer='''''';
    }
  }
}


class bottom extends StatefulWidget {
  @override
  _bottomState createState() => _bottomState();
}

class _bottomState extends State<bottom> {
  bool isSwitched = false;


  void _onSwitchChanged(bool value) {
//    setState(() {
    isSwitched = value;
//    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[

          space(20),
          ListTile(
            leading: Icon(Icons.feedback,color: Colors.grey),
            title: Text('Feedback',style: TextStyle(fontWeight: FontWeight.w300,color: Colors.black,)),
            onTap: () {
              Fluttertoast.showToast(msg: " Opening feedback page..  ",toastLength: Toast.LENGTH_SHORT);
              gourl('http://atdepic.000webhostapp.com/feedback.php');
            },
          ),
          Divider(thickness: 0.2, color: Colors.black),
          ListTile(
            leading: Icon(Icons.supervised_user_circle,color: Colors.grey),
            title: Text('About dev',style: TextStyle(fontWeight: FontWeight.w300,color: Colors.black,)),
            onTap: () {
              Fluttertoast.showToast(msg: " Opening developer's portfolio..  ",toastLength: Toast.LENGTH_SHORT);
              gourl('http://sankalpmishra.me');
            },
          ),
          Divider(thickness: 0.2, color: Colors.black),
          ListTile(
            leading: Icon(Icons.share,color: Colors.grey),
            title: Text('Share',style: TextStyle(fontWeight: FontWeight.w300,color: Colors.black,)),
            onTap: () {
              Fluttertoast.showToast(msg: " Please wait..  ",toastLength: Toast.LENGTH_SHORT);
              final RenderBox box = context.findRenderObject();
              Share.share('Hi! Check out Depic, A made in India depreciation calculator!\nTry this if you need to calculate deprecation and share your reviews and feedback.\nAs of now this app is not available on Playstore, still you can download it from its official website:\n  http://atdepic.000webhostapp.com/downloads.php', subject: 'Depic: Depreciation Calculator', sharePositionOrigin: box.localToGlobal(Offset.zero) &
              box.size);
            },
          ),
          Divider(thickness: 0.2, color: Colors.black),
          ListTile(
            leading: Icon(Icons.system_update_alt,color: Colors.grey),
            title: Text('Check for update',style: TextStyle(fontWeight: FontWeight.w300,color: Colors.black,)),
            onTap: () {
              Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                reverseAnimationCurve: Curves.decelerate,
                forwardAnimationCurve: Curves.elasticOut,
                backgroundColor: Colors.black,
                duration: Duration(seconds: 15),
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
                mainButton: IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    Fluttertoast.showToast(msg: " Opening downloads page..  ",toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 15,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    gourl('http://atdepic.000webhostapp.com/downloads.php');
                  },
                  tooltip: 'Copy to clipboard',
                  color: Colors.white,
                ),
                titleText: Text(
                  "Depic version: 1.2.0+1",
                  style: TextStyle(fontSize: 18.0, color: Colors.green),
                ),
                messageText: Text(
                  "Automatic update notification feature will be available soon.\nBy that time, please click on the button to manually check.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
                ),
              )..show(context);
            },
          ),
          Divider(thickness: 0.2, color: Colors.black),
          ListTile(
            title: Text('Made in India',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54)),
          ),

        ],
      ),
    );
  }

  Widget space(double amount) {
    return new Padding(padding: EdgeInsets.only(top: amount));
  }

  gourl(url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "Something went wrong :(",toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      throw 'Could not launch $url';
    }
  }
}
