# VDR PowerBI Data Connector

This repository hosts Secureworks VDR Power BI Desktop Data Connector, originally created modifying some of the existing [Microsoft OpenAPI samples](https://github.com/Microsoft/DataConnectors)

It is meant to handle OAUTH2 authentification towards a specific VDR instance and allow fetching VDR data through Power Query / M language in Power BI Desktop.

## Building Environment Requirements

1. Install Visual Studio (you can use the free VS Express version available on [Microsoft's Website](https://visualstudio.microsoft.com/vs/express/).
2. Install the [Power Query SDK](https://aka.ms/powerquerysdk) from the Visual Studio Marketplace.

## Building & Installing

### Building:
1. Open the existing .mproj file or create a new Data Connector project.
2. Define your instance URL in the `OpenApiVDR.pq` file by setting the `instance_uri` variable.
3. Create a Public API Client ID and Secret in your VDR instance, as described in [VDR User Guide](https://docs.ctpx.secureworks.com/vdr/userGuide/administration/creating_public_api_clients/).
4. Set the created Client ID and Secret directly in the `client_id` and `client_secret` files in your project (rename the existing .template files).

### Installing:
1. Build the project in order to create a .mez file. Do make sure that the .mez file size is not null, which could indicate a problem with the build. :warning: Note that a .mez file is only a Zip archive, and will include your `client_id` & `client_secret` which are sensitive information, in plaintext.
2. Copy the extension file into the `[Documents]\Power BI Desktop\Custom Connectors` directory.
3. Refer to VDR User Guide section on [Using the Public API through the Power BI Desktop Connector](https://docs.ctpx.secureworks.com/vdr/api/using_public_api_via_power_bi_desktop/).

## Contributing

Most contributions are welcome. Simply submit a pull request on [GitHub](https://github.com/delvelabs/warden-powerbi-connector).

Instruction for contributors:
* Accept the contributor license agreement.

To report a bug or suggest a feature, open an issue.

## License

See the [LICENSE](LICENSE.md) file for license rights and limitations (MIT).
