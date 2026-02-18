import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'otp_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:Color(0xffFAFAFA) ,
      appBar: AppBar(backgroundColor: Color(0xffFAFAFA),),
      body: 
      SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/OBJECTS.png", height: 120, width: 150,fit: BoxFit.fill,),
              ],
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Row(
                children: [
                  Text(
                    "Enter Phone Number",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Text Field
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hint: Row(
                    children: [
                      Text(
                        "Phone Number",
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff7D7D7D),
                        ),
                      ),
                      Text(
                        " *",
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: RichText(text: TextSpan(
                children: [
                  TextSpan(
                    text: "By Continuing, I agree to TotalX’s ",
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff7D7D7D),
                    ),
                  ),
                  TextSpan(
                    text: "Terms and condition",
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: " & ",
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff7D7D7D),
                    ),
                  ),
                  TextSpan(
                    text: " Privacy Policy",
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ]
              ), ),
            ),
            SizedBox(height: 24),

            // Get OTP Button
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(),));
              },
              child: Container(
                height: 50,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Colors.black,
                ),
                child: Center(
                  child: Text(
                    "Get OTP",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
