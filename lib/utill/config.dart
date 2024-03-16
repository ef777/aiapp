import 'package:flutter/material.dart';

class Config {
  Config();

  static const PrimaryColor = Color(0xffffa600);
  static const SecondaryColor = Color(0xffF03C63);
  static const AppBarColor = Color(0xffA0DBE6);
  static const Petrol = Color(0xff19656D);
  static const AppYellow = Color(0xffF7CA2E);

  //#F03C63  //F7CA2E
  static const WhiteSmoke = Color.fromARGB(255, 241, 243, 246);
  static const Blue = Color(0xff3989ED);
  static const LightBlue = Color(0xffDFF1F8);
  static const DarkBlue = Color(0xff1F276D);
  static const FacebookColor = Color.fromARGB(255, 59, 89, 153);
  static const ErrorColor = Color.fromARGB(255, 242, 12, 73);
  static const BlueButtonColor = Color(0xff4c4495);
  static const UnderlineInputColor = Color(0xff373A3F);
  static const ConsultantTextColor = Color(0xff020E17);
  static const LoginButtonTextColor = Color(0xff0E0E0F);
  static const LoginTextColor = Color(0xff292F3B);
  static const DotColor = Color(0xff102563);
  static const TextSpanColor = Color(0xffA0A5AE);
  static const NotDotColor = Color(0xfff13f6);
  static const EyeColor = Color(0xff8C929C);
  static const BorderColor = Color(0xffF3F3F3);
  static const RedColor = Color(0xffD21313);
  static const Grey = Color(0xffC4C4C4);
  static const White = Color(0xffF6F9FE);
  static const TagColor = Color(0xffF1F4FF);
  static const GreenColor = Color(0xff15Ab89);
  static const ProfileBorderColor = Color(0xff95989A);
  static const rateTextColor = Color(0xffC4C9D2);
  static const rateBorderColor = Color(0xffE6E6E6);
  static const CommentProfileBorder = Color(0xff707070);

  static const primaryGradient = <Color>[
    Color(0xff386FD8),
    Color(0xff1E51B5),
  ];

  static BoxDecoration cardBoxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(5),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(.2),
        blurRadius: 20.0, // soften the shadow
        spreadRadius: 0.0, //extend the shadow
        offset: Offset(
          5.0, // Move to right 10  horizontally
          5.0, // Move to bottom 10 Vertically
        ),
      )
    ],
  );

  static BoxDecoration buttonDecoration = BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(width: 1, color: Config.WhiteSmoke)));

  /*const DarkBlueColor = ("#102563");
  const LightBlueColor = ("#24B1D8");*/

  static double getHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  static double getWidth(context) {
    return MediaQuery.of(context).size.width;
  }

  static String dayMonthYear(date) {
    var day = DateTime.parse(date).toUtc().toLocal().day.toString();
    var month = DateTime.parse(date).toUtc().toLocal().month.toString();
    var year = DateTime.parse(date).toUtc().toLocal().year.toString();

    return day + "." + month + "." + year;
  }

  static String getHour(date) {
    var hour = DateTime.parse(date).toUtc().toLocal().hour.toString();
    var minute = DateTime.parse(date).toUtc().toLocal().minute.toString();

    return hour + ":" + minute;
  }
}
