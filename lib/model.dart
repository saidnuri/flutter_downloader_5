class Model {
  String? type;
  String? id;
  String? title;
  String? publishedTime;
  String? duration;
  ViewCount? viewCount;
  List<Thumbnails>? thumbnails;
  Thumbnails? richThumbnail;
  List<DescriptionSnippet>? descriptionSnippet;
  Channel? channel;
  Accessibility? accessibility;
  String? link;
  // ignore: prefer_void_to_null, unnecessary_question_mark
  Null? shelfTitle;

  Model(
      {this.type,
      this.id,
      this.title,
      this.publishedTime,
      this.duration,
      this.viewCount,
      this.thumbnails,
      this.richThumbnail,
      this.descriptionSnippet,
      this.channel,
      this.accessibility,
      this.link,
      this.shelfTitle});

  Model.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    title = json['title'];
    publishedTime = json['publishedTime'];
    duration = json['duration'];
    viewCount = json['viewCount'] != null
        ? ViewCount.fromJson(json['viewCount'])
        : null;
    if (json['thumbnails'] != null) {
      thumbnails = <Thumbnails>[];
      json['thumbnails'].forEach((v) {
        thumbnails!.add(Thumbnails.fromJson(v));
      });
    }
    richThumbnail = json['richThumbnail'] != null
        ? Thumbnails.fromJson(json['richThumbnail'])
        : null;
    if (json['descriptionSnippet'] != null) {
      descriptionSnippet = <DescriptionSnippet>[];
      json['descriptionSnippet'].forEach((v) {
        descriptionSnippet!.add(DescriptionSnippet.fromJson(v));
      });
    }
    channel =
        json['channel'] != null ? Channel.fromJson(json['channel']) : null;
    accessibility = json['accessibility'] != null
        ? Accessibility.fromJson(json['accessibility'])
        : null;
    link = json['link'];
    shelfTitle = json['shelfTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['title'] = title;
    data['publishedTime'] = publishedTime;
    data['duration'] = duration;
    if (viewCount != null) {
      data['viewCount'] = viewCount!.toJson();
    }
    if (thumbnails != null) {
      data['thumbnails'] = thumbnails!.map((v) => v.toJson()).toList();
    }
    if (richThumbnail != null) {
      data['richThumbnail'] = richThumbnail!.toJson();
    }
    if (descriptionSnippet != null) {
      data['descriptionSnippet'] =
          descriptionSnippet!.map((v) => v.toJson()).toList();
    }
    if (channel != null) {
      data['channel'] = channel!.toJson();
    }
    if (accessibility != null) {
      data['accessibility'] = accessibility!.toJson();
    }
    data['link'] = link;
    data['shelfTitle'] = shelfTitle;
    return data;
  }
}

class ViewCount {
  String? text;
  String? short;

  ViewCount({this.text, this.short});

  ViewCount.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    short = json['short'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['short'] = short;
    return data;
  }
}

class Thumbnails {
  String? url;
  int? width;
  int? height;

  Thumbnails({this.url, this.width, this.height});

  Thumbnails.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}

class DescriptionSnippet {
  String? text;
  bool? bold;

  DescriptionSnippet({this.text, this.bold});

  DescriptionSnippet.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    bold = json['bold'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['bold'] = bold;
    return data;
  }
}

class Channel {
  String? name;
  String? id;
  List<Thumbnails>? thumbnails;
  String? link;

  Channel({this.name, this.id, this.thumbnails, this.link});

  Channel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    if (json['thumbnails'] != null) {
      thumbnails = <Thumbnails>[];
      json['thumbnails'].forEach((v) {
        thumbnails!.add(Thumbnails.fromJson(v));
      });
    }
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    if (thumbnails != null) {
      data['thumbnails'] = thumbnails!.map((v) => v.toJson()).toList();
    }
    data['link'] = link;
    return data;
  }
}

class Accessibility {
  String? title;
  String? duration;

  Accessibility({this.title, this.duration});

  Accessibility.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['duration'] = duration;
    return data;
  }
}
