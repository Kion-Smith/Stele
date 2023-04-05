class FediverseAuth {
  String _clientID;
  String _secrectClientID;
  String _id;
  String _name;
  String _redirectURI;
  String _website;
  String _vapidKey;

  FediverseAuth(this._clientID, this._secrectClientID, this._id, this._name,
      this._redirectURI, this._website, this._vapidKey);

  factory FediverseAuth.fromJson(Map<String, dynamic> json) {
    return FediverseAuth(
        json['client_id'],
        json['client_secret'],
        json['id'],
        json['name'],
        json['redirect_uri'],
        json['website'] ?? "",
        json['vapid_key']);
  }

  @override
  String toString() {
    return "client id:$_clientID, client secret:$_secrectClientID, "
        "name:$_name, redirect uri:$_redirectURI, website:$_website, "
        "vapid key:$_vapidKey";
  }

  String get clientID => _clientID;
  String get clientSecret => _secrectClientID;
  String get redirectURI => _redirectURI;
}
