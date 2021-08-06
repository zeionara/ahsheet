# ahsheet

**Ah sheet, here we go again!**

A minimalistic wrapper for google api services which implements some common intermediate-level functionality which may be useful for wide range of projects.

## Google sheets api prerequisites

For being able to work with a specific google spreadsheet ensure you've done the following things:

1. Open access to the spreadsheet for anyone with the link;
1. Set the `spreadsheet id` to be the value of the `AH_SHEET_ID` environment variable; 
1. Generate an `api key` in the [google console](https://console.cloud.google.com/apis/credentials) with access to the sheets api;
1. Set the obtained `api key` to be the value of the `AH_SHEET_API_KEY` environment variable.

For being able to not only read data from a spreadsheet, but to update as well the following additional steps are required:

1. Open the [official web-page for testing sheets api](https://developers.google.com/sheets/api/reference/rest/v4/spreadsheets.values/update), send a couple of queries, open developer's console and save following values from the queries (these steps are necessary because for an unclear reason google sheets api doesn't support write operations using only api key - in any case it requires OAuth 2.0 token, even if a spreadsheet is freely available for modification):
    - value of the `key` attribute from the **inline url arguments** put into the environment variable `AH_SHEET_WRITE_API_KEY`;
    - value of the `Authorization` header put into the environment variable `AH_SHEET_TOKEN`.

## Building

```
swift build --product ahsheet
```

## Running

```sh
./.build/debug/ahsheet
```
