import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/company/constants.dart';
import 'package:sparks/company/screens/fifth_screen.dart';
import 'package:sparks/company/validation.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
class FourthScreen extends StatefulWidget {
  @override
  _FourthScreenState createState() => _FourthScreenState();
}

class _FourthScreenState extends State<FourthScreen> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(

              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(

                    image: DecorationImage(
                      image: AssetImage('images/company/sparksbg.png'),
                      fit: BoxFit.cover,
                    )),

                child: Column(

                  children: <Widget>[
                    //ToDo: The arrow for going back
                    Logo(),

                    //ToDo:school details
                    DetailsLogo(),
                    //ToDo:hint text
                    HintText(hintText:kCompanyCityLocated),

                    Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: kHorizontal,vertical:kHorizontal),
                        child: Column(
                          children: <Widget>[

                            TextFormField(
                              autofocus: true,
                              cursorColor: kComplinecolor,
                              style: Constants.textStyle,
                              textCapitalization: TextCapitalization.sentences,
                              onSaved: (String? value) {
                                Constants.companyCity = value;
                              },
                              onChanged: (String value) {
                                Constants.companyCity = value;
                              },
                              validator: Validator.validateCity,
                              decoration: Constants.companyDecoration,
                            ),

                          ],
                        ),
                      ),
                    ),
                    //SizedBox(height: ScreenUtil().setHeight(70)),

                    //ToDo: Company btn
                    Indicator(nextBtn: (){goToNext();},percent: 0.45,),


                  ],
                ),
              ),
            )
        ));
  }

  void goToNext() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      Navigator.of(context).push
        (MaterialPageRoute(builder: (context) => FifthScreen()));

    }

  }
}