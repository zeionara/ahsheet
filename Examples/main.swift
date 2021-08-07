import ahsheet

// Check oauth-based methods

let wrapper = try GoogleApiSessionWrapper()

for sheet in try wrapper.getSpreadsheetMeta().sheets {
    print(sheet)
}

print(try wrapper.getSheetData("'05.08.2021'!A1:B2").values)

try wrapper.setSheetData(
    SheetData(
        range: "test!A1",
        values: [
            [
                "foo", "bar"
            ]
        ]
    )
)

// Check env-based methods

for sheet in try getSpreadsheetMeta().sheets {
    print(sheet)
}

print(try getSheetData("'05.08.2021'!A1:B2").values)

try setSheetData(
    SheetData(
        range: "test!A1",
        values: [
            [
                "corge", "grault"
            ]
        ]
    )
)
