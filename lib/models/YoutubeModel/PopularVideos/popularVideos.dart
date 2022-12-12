class PopularYoutubeVideos
{
  String? kind;  //is Youtube Response
  List<YoutubeVideoItem>? items=[];
  String? nextPageToken;
  String? prevPageToken;


  PopularYoutubeVideos.fromJson(Map<String,dynamic>json)
  {
    kind=json['kind'];

    nextPageToken=json['nextPageToken'];

    prevPageToken=json['prevPageToken'];

    if(json['items'] !=null)
      {
        json['items'].forEach((element)
        {
          items?.add(YoutubeVideoItem.fromJson(element));
        });
      }
  }
}


class YoutubeVideoItem
{
  String? id;
  YoutubeVideoItemSnippet? snippet;
  YoutubeVideoItemContentDetails? contentDetails;

  YoutubeVideoItem.fromJson(Map<String,dynamic>json)
  {
    id=json['id'];
   snippet= YoutubeVideoItemSnippet.fromJson(json['snippet']);
   contentDetails=YoutubeVideoItemContentDetails.fromJson(json['contentDetails']);

  }
}

class YoutubeVideoItemSnippet
{
  String? title;
  String? description;
  YoutubeVideoItemSnippetThumbnail? thumbnail;
  String? channelTitle;
  String? defaultAudioLanguage;

  YoutubeVideoItemSnippet.fromJson(Map<String,dynamic>json)
  {
    title=json['title'];
    description=json['description'];
    thumbnail=YoutubeVideoItemSnippetThumbnail.fromJson(json['thumbnails']);
    channelTitle=json['channelTitle'];
    defaultAudioLanguage=json['defaultAudioLanguage'];
  }
}

class YoutubeVideoItemSnippetThumbnail
{
  YoutubeVideoItemSnippetThumbnailItem? high;

  YoutubeVideoItemSnippetThumbnail.fromJson(Map<String,dynamic>json)
  {
    high=YoutubeVideoItemSnippetThumbnailItem.fromJson(json['high']);
  }

}

class YoutubeVideoItemSnippetThumbnailItem
{
  String? url;
  int? height;
  int? width;

  YoutubeVideoItemSnippetThumbnailItem.fromJson(Map<String,dynamic>json)
  {
    url=json['url'];
    height=json['height'];
    width=json['width'];
  }
}

class YoutubeVideoItemContentDetails
{
  String? duration;
  String? definition;
  String? caption;

  YoutubeVideoItemContentDetails.fromJson(Map<String,dynamic>json)
  {
    duration=json['duration'];
    definition=json['definition'];
    caption=json['caption'];
  }
}