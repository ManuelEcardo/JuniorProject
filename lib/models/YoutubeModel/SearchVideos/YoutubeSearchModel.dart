class YoutubeSearchModel
{
  String? kind;  //is Youtube Response
  List<YoutubeSearchVideoItem>? items=[];
  String? nextPageToken;
  String? prevPageToken;
  String? regionCode;

  YoutubeSearchModel.fromJson(Map<String,dynamic>json)
  {
    kind=json['kind'];

    nextPageToken=json['nextPageToken'];

    prevPageToken=json['prevPageToken'];

    regionCode=json['regionCode'];

    if(json['items'] !=null)
    {
      json['items'].forEach((element)
      {
        items?.add(YoutubeSearchVideoItem.fromJson(element));
      });
    }
  }
}

class YoutubeSearchVideoItem
{
  String? id;
  YoutubeSearchVideoItemSnippet? snippet;

  YoutubeSearchVideoItem.fromJson(Map<String,dynamic>json)
  {
    id=json['id']['videoId'];
    snippet= YoutubeSearchVideoItemSnippet.fromJson(json['snippet']);
  }
}

class YoutubeSearchVideoItemSnippet
{
  String? title;
  String? description;
  YoutubeSearchVideoItemSnippetThumbnail? thumbnail;
  String? channelTitle;
  YoutubeSearchVideoItemSnippet.fromJson(Map<String,dynamic>json)
  {
    title=json['title'];
    description=json['description'];
    thumbnail=YoutubeSearchVideoItemSnippetThumbnail.fromJson(json['thumbnails']);
    channelTitle=json['channelTitle'];
  }
}

class YoutubeSearchVideoItemSnippetThumbnail
{
  YoutubeSearchVideoItemSnippetThumbnailItem? high;

  YoutubeSearchVideoItemSnippetThumbnail.fromJson(Map<String,dynamic>json)
  {
    high=YoutubeSearchVideoItemSnippetThumbnailItem.fromJson(json['high']);
  }

}

class YoutubeSearchVideoItemSnippetThumbnailItem
{
  String? url;
  int? height;
  int? width;

  YoutubeSearchVideoItemSnippetThumbnailItem.fromJson(Map<String,dynamic>json)
  {
    url=json['url'];
    height=json['height'];
    width=json['width'];
  }
}