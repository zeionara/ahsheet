# ahsheet

**Ah sheet, here we go again!**

A minimalistic wrapper for google api services which implements some common intermediate-level functionality which may be useful for wide range of projects.

## Usage

In your `Package.swift` update the list of global dependencies which is written using the property `dependencies`. It must contain the following entry:

```swift
.package(url: "https://github.com/zeionara/ahsheet.git", .branch("master"))
```

In the same file include the dependency into the local list of dependencies corresponding to your app configuration (for instance, the path to this property may look like `targets.executableTarget.dependencies`). As a result of modification, this list have to include at least this entry:

```swift
.product(name: "ahsheet", package: "ahsheet")
```

## Google sheets api prerequisites (without OAuth 2.0)

Api wrappers from this category do not require creation of a wrapper instance and are instead purely based on authorization keys provided via environment variables. Hence, this approach is the most lightweight, but at the same time it requires a slighltly more complicated setup.

For being able to work with a specific google spreadsheet ensure you've done the following things:

1. Open access to the spreadsheet for anyone with the link;
1. Set the `spreadsheet id` to be the value of the `AH_SHEET_ID` environment variable; 
1. Generate an `api key` in the [google console](https://console.cloud.google.com/apis/credentials) with access to the sheets api;
1. Set the obtained `api key` to be the value of the `AH_SHEET_API_KEY` environment variable.

For being able to not only read data from a spreadsheet, but to update as well the following additional steps are required:

1. Open the [official web-page for testing sheets api](https://developers.google.com/sheets/api/reference/rest/v4/spreadsheets.values/update), send a couple of queries, open developer's console and save following values from the queries (these steps are necessary because for an unclear reason google sheets api doesn't support write operations using only api key - in any case it requires OAuth 2.0 token, even if a spreadsheet is freely available for modification):
    - value of the `key` attribute from the **inline url arguments** put into the environment variable `AH_SHEET_WRITE_API_KEY`;
    - value of the `Authorization` header put into the environment variable `AH_SHEET_TOKEN`.

Example of making a request for obtaining spreadsheet metadata using this interface:

```swift
print("Sheets:")
for sheet in try getSphreadsheetMeta().sheets {
     print(sheet)
}
```

Expected Output:

```sh
Sheets:
foo aka 0
bar aka 291892989
baz aka 210100302
```

## Google sheets api prerequisites (with OAuth 2.0)

Api wrappers of this kind are the easiest in the question of setup, but require creation of a shared wrapper instance which may consume additional memory and complicate the source code in general.

To provide the service with all required data you need to ensure that the following measures are taken:

1. The `spreadsheet id` is written to the `AH_SHEET_ID` environment variable;
1. There is an OAuth 2.0 client id created in the [google platform console's credentials section](https://console.cloud.google.com/apis/credentials);
1. The mentioned client id is provided with all required privilidges to `read / modify / manage` respective resources in the google cloud;
1. The appropriate `json` file containing crendentials which correspond to the client id is downloaded and put somewhere on your device, it's location is written to the environment variable `AH_SHEET_CREDS_PATH`.

That's it! During program execution you will be asked to log into your google account and all the required tokens will be generated and refreshed internally.

Example of making a request for obtaining spreadsheet metadata using this interface:

```swift
let wrapper = try GoogleApiSessionWrapper()

print("Sheets:")
for sheet in try wrapper.getSpreadsheetMeta().sheets {
    print(sheet)
}
```

Expected output is equivalent to the presented earlier:

```sh
Sheets:
foo aka 0
bar aka 291892989
baz aka 210100302
```
