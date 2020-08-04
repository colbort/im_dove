import 'package:app/pojo/video_bean.dart';
import 'package:flutter/material.dart';

class CarouseBean {
  int id;
  String linkName;
  int linkType;
  int parentType;
  String linkImg;
  int videoId;
  bool status;
  String jumpH5;
  String jumpApp;
  String startedAt;
  String endAt;
  int sort;
  String createdAt;
  String updatedAt;

  CarouseBean({
    this.id,
    this.linkName,
    this.linkType,
    this.parentType,
    this.linkImg,
    this.videoId,
    this.status,
    this.jumpH5,
    this.jumpApp,
    this.startedAt,
    this.endAt,
    this.sort,
    this.createdAt,
    this.updatedAt,
  });

  CarouseBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    linkName = json['linkName'];
    linkType = json['linkType'];
    parentType = json['parentType'];
    linkImg = json['linkImg'];
    videoId = json['videoId'];
    status = json['status'];
    jumpH5 = json['jumpH5'];
    jumpApp = json['jumpApp'];
    startedAt = json['startedAt'];
    endAt = json['endAt'];
    sort = json['sort'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['linkName'] = this.linkName;
    data['linkType'] = this.linkType;
    data['parentType'] = this.parentType;
    data['linkImg'] = this.linkImg;
    data['videoId'] = this.videoId;
    data['status'] = this.status;
    data['jumpH5'] = this.jumpH5;
    data['jumpApp'] = this.jumpApp;
    data['startedAt'] = this.startedAt;
    data['endAt'] = this.endAt;
    data['sort'] = this.sort;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Carouses {
  List<CarouseBean> carouses;

  Carouses();

  Carouses.fromJson(List<dynamic> json) {
    if (json == null) {
      return;
    }
    carouses = new List();
    json.forEach((it) {
      carouses.add(CarouseBean.fromJson(it));
    });
  }

  List<dynamic> toJson() {
    return carouses;
  }
}

class VideosBean {
  List<VideoBean> videos;

  VideosBean({
    @required this.videos,
  });

  VideosBean.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    if (json['videos'] != null) {
      videos = List<VideoBean>();
      json['videos'].forEach((v) {
        videos.add(VideoBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (videos != null) {
      data['videos'] = this.videos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActressGroupBean {
  int id;
  String headUrl;
  String name;
  int videonum;
  String descript;
  int popularity;
  String photoUrl;
  List<VideoBean> videos;

  ActressGroupBean({
    @required this.id,
    @required this.headUrl,
    @required this.name,
    @required this.videonum,
    @required this.descript,
    @required this.popularity,
    @required this.photoUrl,
    @required this.videos,
  });

  ActressGroupBean.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    id = json['id'] as int;
    headUrl = json['headImg'] as String;
    name = json['chineseName'] as String;
    videonum = json['videoNum'] as int;
    descript = json['introduction'] as String;
    popularity = json['popularity'] as int;
    photoUrl = json['photoUrl'] as String;
    if (json['video'] != null) {
      videos = List<VideoBean>();
      json['video'].forEach((v) {
        videos.add(VideoBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['headUrl'] = this.headUrl;
    data['id'] = this.id;
    data['name'] = this.name;
    data['videonum'] = this.videonum;
    data['descript'] = this.descript;
    data['popularity'] = this.popularity;
    data['photoUrl'] = this.photoUrl;
    data['video'] = this.videos.map((v) => v.toJson()).toList();
    return data;
  }
}

class VideoGroupBean {
  String topicName;
  int topicId;
  List<VideoBean> videos;

  VideoGroupBean({
    @required this.topicName,
    @required this.topicId,
    @required this.videos,
  });

  VideoGroupBean.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    topicName = json['topicName'] as String;
    topicId = json['topicId'] as int;
    if (json['videos'] != null) {
      videos = List<VideoBean>();
      json['videos'].forEach((v) {
        videos.add(VideoBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topicName'] = this.topicName;
    data['topicId'] = this.topicId;
    data['videos'] = this.videos.map((v) => v.toJson()).toList();
    return data;
  }
}

class VideoGroupsBean {
  List<VideoGroupBean> group;

  VideoGroupsBean({
    @required this.group,
  });

  VideoGroupsBean.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    if (json['topicVideos'] != null) {
      group = List<VideoGroupBean>();
      json['topicVideos'].forEach((v) {
        group.add(VideoGroupBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topicVideos'] = this.group.map((v) => v.toJson()).toList();
    return data;
  }
}

class ViewRecordBean {
  String id;
  String movieName;
  String movieCover;
  int totalTime;
  int playTime;
  bool isBuy;
  String version;
  int percent;
  String createTime;

  ViewRecordBean({
    this.id,
    this.movieName,
    this.movieCover,
    this.totalTime,
    this.playTime,
    this.isBuy,
    this.version,
    this.percent,
    this.createTime,
  });

  ViewRecordBean.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    id = json['id'] as String;
    movieName = json['movieName'] as String;
    movieCover = json['movieCover'] as String;
    totalTime = json['totalTime'] as int;
    playTime = json['totalTime'] as int;
    isBuy = json['isBuy'] as bool;
    version = json['version'] as String;
    percent = json['percent'] as int;
    createTime = json['createTime'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['movieName'] = movieName;
    data['movieCover'] = movieCover;
    data['totalTime'] = totalTime;
    data['playTime'] = playTime;
    data['isBuy'] = isBuy;
    data['version'] = version;
    data['percent'] = percent;
    data['createTime'] = createTime;
    return data;
  }
}

class ViewRecordsBean {
  List<ViewRecordBean> records;

  ViewRecordsBean() {
    records = List();
  }

  ViewRecordsBean.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    if (json['group'] != null) {
      records = List<ViewRecordBean>();
      json['group'].forEach((v) {
        records.add(ViewRecordBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group'] = this.records.map((v) => v.toJson()).toList();
    return data;
  }
}

class ClassifyBean {
  int id;
  String name;

  ClassifyBean({
    this.id,
    this.name,
  });

  ClassifyBean.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class ClassifiesBean {
  List<ClassifyBean> sorts;
  List<ClassifyBean> categorys;
  List<ClassifyBean> tags;

  ClassifiesBean({
    @required this.sorts,
    @required this.categorys,
    @required this.tags,
  });

  ClassifiesBean.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    if (json['sorts'] != null) {
      sorts = new List<ClassifyBean>();
      json['sorts'].forEach((v) {
        sorts.add(ClassifyBean.fromJson(v));
      });
    } else {
      json['sorts'] = [];
    }
    if (json['categorys'] != null) {
      categorys = new List();
      json['categorys'].forEach((v) {
        categorys.add(ClassifyBean.fromJson(v));
      });
    } else {
      json['categorys'] = [];
    }
    if (json['tags'] != null) {
      tags = new List();
      json['tags'].forEach((v) {
        tags.add(ClassifyBean.fromJson(v));
      });
    } else {
      json['tags'] = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sorts'] = this.sorts.map((v) => v.toJson()).toList();
    data['categorys'] = this.categorys.map((v) => v.toJson()).toList();
    data['tags'] = this.tags.map((v) => v.toJson()).toList();
    return data;
  }
}

class ClassifyHome {
  VideosBean videos;
  ClassifiesBean classifies;

  ClassifyHome.fromJson(Map<String, dynamic> json) {
    videos = VideosBean.fromJson(json);
    classifies = ClassifiesBean.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['videos'] = videos.toJson();
    data.addAll(classifies.toJson());
    return data;
  }
}
