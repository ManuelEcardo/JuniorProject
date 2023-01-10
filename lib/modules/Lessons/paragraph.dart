import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';

import '../../shared/styles/colors.dart';

class Paragraph extends StatelessWidget {

  final bool isSubmitted;  //Is Submitted to be checked
  final bool isChecked;   // Is it checked.
  final String mark;     // Mark
  const Paragraph({Key? key, required this.isSubmitted, required this.isChecked, required this.mark}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextEditingController textEditingController= TextEditingController();
    GlobalKey<FormState> formKey= GlobalKey<FormState>();

    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},

      builder: (context,state)
      {
        var cubit=AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            actions:
            [
              IconButton(onPressed: (){AppCubit.get(context).changeTheme();}, icon: const Icon(Icons.sunny)),
            ],
          ),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    Center(
                      child: Text(
                        'Unit Feedback',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: pistachioColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25,),

                    //If paper is Submitted but not checked and marked yet.
                    Visibility(
                      visible: isSubmitted && isChecked==false,
                      child: Column(
                        children: const
                        [
                          Text(
                            "You've submitted your paragraph.\nWaiting for result...",
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),

                          SizedBox(height: 20,),
                        ],
                      ),
                    ),

                    //Paper isChecked and has a mark
                    Visibility(
                      visible: isChecked==true && isSubmitted==true && mark.isNotEmpty,
                      child:Column(
                        children: [
                          Text(
                            "Your paper has been checked.\nYour Mark is: $mark",
                            style: const TextStyle(fontSize: 20),
                          ),

                          const SizedBox(height: 20,),
                        ],
                      ),
                    ),

                    TextFormField(
                      controller: textEditingController,
                      maxLines: 15,
                      decoration: InputDecoration(
                        hintText: "Write what you've learnt in this unit.\nWrite at least 50 characters.\nAn instructor will check for your paragraph.\n\n\n\n\n\n\n\n\n\n\n\n\n",
                        hintStyle: TextStyle(color:  Colors.grey.withOpacity(0.88),),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: cubit.isDarkTheme? Colors.white : Colors.black,
                              width: 1.0
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: cubit.isDarkTheme? Colors.white : Colors.black,
                              width: 1.0
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: cubit.isDarkTheme? Colors.redAccent : Colors.redAccent,
                              width: 1.0
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: cubit.isDarkTheme? Colors.redAccent : Colors.redAccent,
                              width: 1.0
                          ),
                        ),
                      ),
                      minLines: 2,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      readOnly: isSubmitted,
                      validator: (String? value)
                      {
                        if(value!.isEmpty)
                          {
                            return 'Fill out the paragraph section';
                          }
                        if(value.isNotEmpty)
                          {
                            if(value.length <50)
                            {
                              return 'Write More Lines';
                            }
                          }
                        return null;
                      },
                    ),

                    const SizedBox(height: 50,),

                    defaultButton(
                        function: ()
                        {
                          if(formKey.currentState!.validate())
                            {
                              if(isSubmitted || isChecked)  //If paper is already submitted, then button pressing will do nothing
                                {
                                  defaultToast(msg: "You've already submitted your paragraph");
                                }
                              else
                                {
                                  print(textEditingController.value.text);
                                  //SUBMIT AND SEND TO TEACHERS.
                                }
                            }
                        },
                        text: 'submit',
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
