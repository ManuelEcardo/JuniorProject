import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/styles.dart';

class ProfilePage extends StatelessWidget {


  var formKey=GlobalKey<FormState>();

  var emailController= TextEditingController();

  var phoneController= TextEditingController();

  var passwordController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {

      },

      builder: (context,state)
      {
        return Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children:
                   [
                     const CircleAvatar(
                        backgroundColor: Colors.black12,
                        radius: 55,
                        backgroundImage: AssetImage('assets/images/robot.gif'),

                      ),

                     Text(
                       'Mohammad',
                       style: defaultHeadlineTextStyle,
                     ),

                     const SizedBox(height: 25,),

                     defaultFormField(
                         controller: passwordController,
                         keyboard: TextInputType.text,
                         label: 'Name',
                         prefix: Icons.person_rounded,
                         validate: (String? value)
                         {
                           if(value!.isEmpty)
                           {
                             return 'Name is Empty';
                           }
                           return null;
                         }
                     ),

                     const SizedBox(height: 25,),

                     defaultFormField(
                         controller: emailController,
                         keyboard: TextInputType.emailAddress,
                         label: 'Email Address',
                         prefix: Icons.email_rounded,
                         validate: (String? value)
                         {
                           if(value!.isEmpty)
                           {
                             return 'Email Address is Empty';
                           }
                           return null;
                         }
                     ),

                     const SizedBox(height: 25,),

                     defaultFormField(
                         controller: phoneController,
                         keyboard: TextInputType.phone,
                         label: 'Phone',
                         prefix: Icons.phone_rounded,
                         validate: (String? value)
                         {
                           if(value!.isEmpty)
                           {
                             return 'Phone is Empty';
                           }
                           return null;
                         }
                     ),


                     const SizedBox(height: 30,),

                     defaultButton(
                         function: (){},
                         text: 'update',
                     ),

                     const SizedBox(height: 20,),

                     TextButton(

                       child:const Center(
                           child: Text(
                             'Developers',
                             style:TextStyle(
                               fontSize: 20
                             ),
                           )
                       ),
                       onPressed: ()
                       async{
                         await showDialog(
                             context: context,
                             builder: (context)
                         {
                           return AlertDialog(
                             title: Text(
                               'Thanks for Using our App!',
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                 color: HexColor('8AA76C'),
                                 fontWeight: FontWeight.w700,
                               ),
                             ),
                             content:  Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisSize: MainAxisSize.min,
                               children:
                               const[
                                 Text(
                                   'A work of sincere people',
                                   style: TextStyle(
                                     color: Colors.black,
                                     fontSize: 18,
                                   ),
                                 ),

                                 Text(
                                   '-Mobile Application: Mohammad Bali',
                                   style: TextStyle(
                                     color: Colors.black,
                                     fontSize: 18,
                                   ),
                                 ),

                                 Text(
                                   '-Website: Ayhem Khatib',
                                   style: TextStyle(
                                     color: Colors.black,
                                     fontSize: 18,
                                   ),
                                 ),

                                 Text(
                                   '-Back End: Mostafa Hamwi',
                                   style: TextStyle(
                                     color: Colors.black,
                                     fontSize: 18,
                                   ),
                                 ),

                                 Text(
                                   '-Structure: Yazan',
                                   style: TextStyle(
                                     color: Colors.black,
                                     fontSize: 18,
                                   ),
                                 ),

                                 Text(
                                   '-Reports: Ibaa Safieh',
                                   style: TextStyle(
                                     color: Colors.black,
                                     fontSize: 18,
                                   ),
                                 ),

                               ],
                             ),
                           );
                         }
                         );
                       },
                     ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
