section OpenApiVDR;

// TODO: add your client id and secret to the embedded files, then write the correct instance URI
client_id = Text.FromBinary(Extension.Contents("client_id"));
client_secret = Text.FromBinary(Extension.Contents("client_secret"));

//TODO: add your instalce URL in that format https://<instance>.vdr.secureworks.com/
instance_uri = ""; 


redirect_uri = "https://oauth.powerbi.com/views/oauthredirect.html" ;

windowWidth = 800;
windowHeight = 800;

[DataSource.Kind="OpenApiVDR", Publish="OpenApiVDR.Publish"]
shared OpenApiDVDRe.Contents = () =>
    let
        credential = Extension.CurrentCredential(),
        token = credential[access_token], 
        headers = [ Authorization = "Bearer " & token ],
        navTable = OpenApi.Document(Web.Contents(instance_uri & "/api/v2/spec/openapi-2.0.json?powerbi"), [ Headers = headers, ManualCredentials = true ])
    in
        navTable;


// Data Source Kind description
OpenApiVDR = [
    // enable both OAuth and Key based auth
    Authentication = [
        OAuth = [
            StartLogin = StartLogin,
            FinishLogin = FinishLogin,
            Refresh=Refresh
        ]
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
OpenApiVDR.Publish = [
    Category = "Other",
    ButtonText = { "OpenAPI - VDR", "OpenAPI - VDR" },
    LearnMoreUrl = "https://docs.ctpx.secureworks.com/vdr/api/using_public_api_via_power_bi_desktop/"
];

//
// OAuth2 flow definition
//

StartLogin = (resourceUrl, state, display) =>
    let
            AuthorizeUrl = instance_uri & "/auth/oauth2" & "/authorize?" & Uri.BuildQueryString([
            client_id = client_id,
            response_type = "code",
            scope = "read_only",
            state = state,
            redirect_uri = redirect_uri])
    in
        [
            LoginUri = AuthorizeUrl,
            CallbackUri = redirect_uri,
            WindowHeight = windowHeight,
            WindowWidth = windowWidth,
            Context = null
        ];

FinishLogin = (context, callbackUri, state) =>
    let
        Parts = Uri.Parts(callbackUri)[Query]
    in
        TokenMethod(Parts[code], "authorization_code");

TokenMethod = (code, grant_type) =>
    let
        Response = Web.Contents(instance_uri & "/auth/oauth2" & "/token", [
            Content = Text.ToBinary(Uri.BuildQueryString([
                client_id = client_id,
                client_secret = client_secret,
                code = code,
                grant_type = grant_type,
                redirect_uri = redirect_uri])),
            Headers=[#"Content-type" = "application/x-www-form-urlencoded",#"Accept" = "application/json"]]),
        Parts = Json.Document(Response)
    in
        Parts;

Refresh = (resourceUrl, refresh_token) => TokenMethod(refresh_token, "refresh_token");
