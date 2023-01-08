import 'package:cached_video_preview/cached_video_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Videos/VideoPlayer/videoPlayer.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../models/MainModel/content_model.dart';
import '../../shared/styles/colors.dart';

class UnitVideos extends StatelessWidget {

  final List<Videos> model; //Videos to be shown

  const UnitVideos(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},

      builder: (context,state)
      {
        return Scaffold(
          appBar: AppBar(
            actions:
            [
              IconButton(onPressed: (){AppCubit.get(context).changeTheme();}, icon: const Icon(Icons.sunny)),
            ],
          ),

          body: Padding(
            padding: const EdgeInsetsDirectional.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Center(
                    child: Text(
                      'Videos',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: pistachioColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10,),

                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context,index)=>itemBuilder(context: context, model: model[index]),
                      separatorBuilder: (context,index)=> const SizedBox(height: 25,),
                      itemCount: model.length,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

   Widget itemBuilder({required BuildContext context, required Videos model})
   {
     return GestureDetector(
       onTap: ()
       {
         navigateTo(
           context,
           ShowCaseWidget(
               builder: Builder(
                 builder: (context)=>VideoGetter(model),
               )
           ),
         );
       },

       child: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 10),
         child: Container(
           width: double.infinity,
           height: 200,
           clipBehavior: Clip.antiAliasWithSaveLayer,
           decoration: BoxDecoration(
             color: Colors.grey.withOpacity(0.3),
             borderRadius: BorderRadius.circular(10),

           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.max,
             children:
             [
               const Spacer(),

               Stack(
                 alignment: Alignment.center,
                 children:
                 [
                   Center(
                     child: SizedBox(
                       height: 150,
                       width: double.infinity,
                       child: ClipRRect(
                         borderRadius: BorderRadius.circular(8),
                         clipBehavior:Clip.antiAliasWithSaveLayer,
                         child: CachedVideoPreviewWidget(
                           path: model.videoLink!,
                           type: SourceType.remote,
                           httpHeaders: const <String, String>{},
                           placeHolder: const Center(child: CircularProgressIndicator(),),
                           remoteImageBuilder: (BuildContext context, url) => Image.network(
                             url,
                             width: 150,
                             height: 150,
                             errorBuilder: (context,error,stack)=>Image.asset('assets/images/defaultFlag.png'),
                           ),
                         ),
                       ),
                     ),
                   ),

                   const Icon(
                     Icons.play_circle,
                     size: 60,
                     color: Colors.white70,
                   ),
                 ],
               ),

               const Spacer(),

               Center(
                 child: Text(
                   model.videoTitle!,
                   overflow: TextOverflow.ellipsis,
                   maxLines: 1,
                 ),
               ),
             ],
           ),
         ),
       ),
     );
   }
}
