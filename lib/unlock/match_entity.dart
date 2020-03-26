
class MatchEntity {

  int size;
  int br;
  String url;
  Object md5;

	MatchEntity.fromJsonMap(Map<String, dynamic> map): 
		size = map["size"],
		br = map["br"],
		url = map["url"],
		md5 = map["md5"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['size'] = size;
		data['br'] = br;
		data['url'] = url;
		data['md5'] = md5;
		return data;
	}
}
