# Code Coverage Support for Flow Emulator

To view coverage results when running our tests, we can use:

```bash
# On Linux
bin/flow-x86_64-linux- test --cover test_foo_contract.cdc

# On Mac
bin/flow-x86_64-darwin- test --cover test_foo_contract.cdc
```

The output will look something like this:

```bash
Running tests...

Test results: (test_foo_contract.cdc)
- PASS: testGetIntegerTrait
- PASS: testAddSpecialNumber
Coverage: 93.3% of statements
```

It looks like not all statements were covered by the test inputs. To view details for the coverage report,
we can use the `--coverprofile` flag:

```bash
bin/flow-x86_64-linux- test --cover --coverprofile=coverage.json test_foo_contract.cdc
```

With the above flag, a `coverage.json` file was generated.

```json
{
  "coverage": {
    "S../FooContract.cdc": {
      "line_hits": {
        "14": 1,
        "18": 8,
        "19": 1,
        "20": 7,
        "21": 1,
        "22": 6,
        "23": 1,
        "24": 5,
        "25": 1,
        "26": 4,
        "27": 0,
        "30": 4,
        "31": 3,
        "34": 1,
        "6": 1
      },
      "missed_lines": [
        27
      ],
      "statements": 15,
      "percentage": "93.3%"
    }
  }
}
```

Reading the JSON file, we can see that for the `FooContract.cdc` the line `27` was missed during the tests (not covered by the test inputs).

To fix that, we can tweak the `testInputs` Dictionary on `test_foo_contract.cdc` to observe how the coverage percentage changes. By uncommenting the line `13`, we now get:

```bash
bin/flow-x86_64-linux- test --cover test_foo_contract.cdc

Running tests...

Test results: (test_foo_contract.cdc)
- PASS: testGetIntegerTrait
- PASS: testAddSpecialNumber
Coverage: 100.0% of statements
```

For some more realistic contracts and tests:

```bash
bin/flow-x86_64-linux- test --cover --coverprofile=coverage.json test_array_utils.cdc test_string_utils.cdc

Running tests...

Test results: (test_array_utils.cdc)
- PASS: testRange
- PASS: testTransform
- PASS: testIterate
- PASS: testMap
- PASS: testMapStrings
- PASS: testReduce
Test results: (test_string_utils.cdc)
- PASS: testFormat
- PASS: testExplode
- PASS: testTrimLeft
- PASS: testTrim
- PASS: testReplaceAll
- PASS: testHasPrefix
- PASS: testHasSuffix
- PASS: testIndex
- PASS: testCount
- PASS: testContains
- PASS: testSubstringUntil
- PASS: testSplit
- PASS: testJoin
Coverage: 96.3% of statements
```

Look at the files `ArrayUtils.cdc` (smart contract) and `test_array_utils.cdc` (tests for the smart contract). For the `ArrayUtils.range` method, we have omitted in purpose the branch where `start > end`. It is left as an exercise to the reader.

Also, look at the files `StringUtils.cdc` (smart contract) and `test_string_utils.cdc` (tests for the smart contract).
