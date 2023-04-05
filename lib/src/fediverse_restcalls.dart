import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:stele/src/data/fediverse_account.dart';
import 'package:stele/src/data/fediverse_auth.dart';
import 'package:stele/src/data/toot_data.dart';
import 'package:stele/src/stele_exceptions.dart';

String getTokens = "/apps";
String clientName = "Relic";
String redirectURI = "urn:ietf:wg:oauth:2.0:oob";
String scopes = "read write follow";

String authorize = "/oauth/authorize";
String clientId = "?client_id=";
String redirectReq = "&redirect_uri=";
String responseType = "&response_type=";
String resTypeCode = "code";
String scope = "&scope=";

String login = "/oauth/token";
String timeline = "/api/v1/timelines/home";
String publicTimeline = "/api/v1/timelines/public";
String verifyUser = "/api/v1/accounts/verify_credentials";
String registerApp = "/api/v1/apps/";
String getAccount = "/api/v1/accounts/";
String getStatuses = "/api/v1/statuses/";

Future<FediverseAccount> getAccountDetails(String domain,String account) async {
  final response =
  await http.get(Uri.parse("https://$domain$getAccount$account"));
  if (response.statusCode == 200) {
    return FediverseAccount.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        "Failed to retrive from this account from https://$domain$getAccount$account");
  }
}

// Was getClientTokens
Future<FediverseAuth> registerApplication(String domain) async {
  http.Response response = await http.post(
      Uri.parse("https://$domain$registerApp"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, String>{
        'baseurl': domain,
        'client_name': clientName,
        'redirect_uris': redirectURI,
        'scopes': scopes
      }));

  if (response.statusCode == 200) {
    return FediverseAuth.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        "Failed to register relic as an app for $domain. ${response.body}");
  }
}

Future<String> getAuthorizationURL(String domain,FediverseAuth auth) async {
  return "https://$domain$authorize$clientId${auth.clientID}$redirectReq$redirectURI$responseType$resTypeCode${scope}read+write+follow";
}

Future<void> getAndStoreAuthorizationToken( String domain,
    FediverseAuth auth, String authorizationToken) async {

  http.Response response = await http.post(Uri.parse("https://$domain$login"),
      body: (<String, String>{
        "grant_type": "authorization_code",
        "redirect_uri": redirectURI,
        "client_id": auth.clientID,
        "client_secret": auth.clientSecret,
        "code": authorizationToken,
        "scope": scopes
      }));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to get acess tokens $domain. ${response.body}");
  }
}

Future<List<FediversePost>> getUsersMostRecentTimeline(String domain, String accessToken,
    {String? maxId, String? minId, String? sinceId}) async {
  maxId = maxId ?? "";
  minId = minId ?? "";
  sinceId = sinceId ?? "";

  http.Response response = await http.get(
      Uri.parse(
          "https://$domain$timeline?max_id=$maxId&min_id=$minId&since_id=$sinceId"),
      headers: <String, String>{"Authorization": "Bearer $accessToken"});

  if (response.statusCode == 200) {
    List<dynamic> json = jsonDecode(response.body);
    List<FediversePost> posts = [];
    for (int i = 0; i < json.length; i++) {
      posts.add(FediversePost.fromJson(json[i]));
    }
    return posts;
  } else {
    throw MissingTimelineException(
        "Unable to access timeline because ${response.body}");
  }
}

//maybe make isonlylocal an enum to handle special cases see https://docs.joinmastodon.org/methods/timelines/ for more information
Future<List<FediversePost>> getFediversePublicTimeline(
    String domainName, bool isOnlyLocal, bool isOnlyMedia,
    {String? maxId, String? minId, String? sinceId}) async {
  maxId = maxId ?? "";
  minId = minId ?? "";
  sinceId = sinceId ?? "";

  if (domainName.isEmpty) {
    throw MissingDomainNameExcepetion("Missing a domain name");
  }

  //since there are no bodys we do it like this manually
  http.Response response = await http.get(
    Uri.parse(
        "https://$domainName$publicTimeline?max_id=$maxId&min_id=$minId&since_id=$sinceId&local=$isOnlyLocal&only_media=$isOnlyMedia"),
  );

  switch (response.statusCode) {
    case 200:
      List<dynamic> json = jsonDecode(response.body);
      List<FediversePost> posts = [];
      for (int i = 0; i < json.length; i++) {
        posts.add(FediversePost.fromJson(json[i]));
      }
      return posts;
    case 401: //Authorization error
      throw AuthorizationException("Not authorized. ${response.body}");
    default:
      throw Exception("Unable to access timeline. ${response.body}");
  }
}

Future<Map<String, List<FediversePost>>> getStatusContext(
    String domainName, String status) async {
  if (domainName.isEmpty) {
    throw MissingDomainNameExcepetion("Missing a domain name");
  }

  http.Response response = await http.get(
    Uri.parse("https://$domainName$getStatuses$status/context"),
  );

  print("https://$domainName$getStatuses$status/context");

  switch (response.statusCode) {
    case 200:
    //print(response.body);
      Map<String, dynamic> json = jsonDecode(response.body);
      Map<String, List<FediversePost>> contextMap = {};
      List<FediversePost> posts = [];
      for (int i = 0; i < json["ancestors"].length; i++) {
        posts.add(FediversePost.fromJson(json["ancestors"][i]));
      }

      contextMap["ancestors"] = posts;
      posts = [];

      for (int i = 0; i < json["descendants"].length; i++) {
        posts.add(FediversePost.fromJson(json["descendants"][i]));
      }
      contextMap["descendants"] = posts;

      return contextMap;
    case 401: //Authorization error
      throw AuthorizationException("Not authorized. ${response.body}");
    default:
      throw Exception("Unable to get context. ${response.body}");
  }
}

Future<FediverseAccount> verifyUserAccount(String domain, String accessToken) async {
  http.Response response = await http.get(
      Uri.parse("https://$domain$verifyUser"),
      headers: <String, String>{"Authorization": "Bearer $accessToken"});

  if (response.statusCode == 200) {
    return FediverseAccount.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to verify the users account. ${response.body}");
  }
}