# ahsheet

**Ah sheet, here we go again!**

A minimalistic wrapper for google api services which implements some common intermediate-level functionality which may be useful for wide range of projects.

## Google sheets api prerequisites

For being able to work with a specific google spreadsheet ensure you've done the following things:

1. Open access to the spreadsheet for anyone with the link;
1. Set the `spreadsheet id` to be the value of the `AH_SHEET_ID` environment variable; 
1. Generate an `api key` in the [google console](https://console.cloud.google.com/apis/credentials) with access to the sheets api;
1. Set the obtained `api key` to be the value of the `AH_SHEET_API_KEY` environment variable.

## Building

```
swift build --product ahsheet
```

## Running

```sh
./.build/debug/ahsheet
```
