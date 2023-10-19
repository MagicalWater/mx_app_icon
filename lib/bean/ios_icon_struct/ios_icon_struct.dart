class IosIconStructBean {
  List<IosIconStructImagesBean>? images;
  IosIconStructInfoBean? info;

  IosIconStructBean({
    this.images,
    this.info,
  });

  IosIconStructBean.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images = (json['images'] as List)
          .map((e) => IosIconStructImagesBean.fromJson(e))
          .toList();
    }
    info = json['info'] != null
        ? IosIconStructInfoBean.fromJson(json['info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'images': images?.map((e) => e.toJson()).toList(),
      'info': info?.toJson(),
    };
  }
}

class IosIconStructImagesBean {
  String? size;
  String? idiom;
  String? filename;
  String? scale;
  String? platform;

  IosIconStructImagesBean({
    this.size,
    this.idiom,
    this.filename,
    this.scale,
    this.platform,
  });

  IosIconStructImagesBean.fromJson(Map<String, dynamic> json) {
    size = json['size']?.toString();
    idiom = json['idiom']?.toString();
    filename = json['filename']?.toString();
    scale = json['scale']?.toString();
    platform = json['platform']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'idiom': idiom,
      'filename': filename,
      'scale': scale,
      'platform': platform,
    };
  }
}

class IosIconStructInfoBean {
  int? version;
  String? author;

  IosIconStructInfoBean({
    this.version,
    this.author,
  });

  IosIconStructInfoBean.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    author = json['author']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'author': author,
    };
  }
}
