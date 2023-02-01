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

Test results:
- PASS: testGetIntegerTrait
Coverage: 81.8% of statements
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
        "10": 1,
        "11": 0,
        "12": 1,
        "13": 0,
        "16": 1,
        "4": 4,
        "5": 1,
        "6": 3,
        "7": 1,
        "8": 2,
        "9": 1
      },
      "missed_lines": [
        11,
        13
      ],
      "statements": 11,
      "percentage": "81.8%"
    }
  }
}
```

Reading the JSON file, we can see that for the `FooContract.cdc` the lines `11`, `13` were missed during the tests (not covered by the test inputs).

To fix that, we can tweak the `testInputs` Dictionary on `test_foo_contract.cdc` to observe how the coverage percentage changes. By uncommenting the lines `10` and `11`, we now get:

```bash
bin/flow-x86_64-linux- test --cover test_foo_contract.cdc

Running tests...

Test results:
- PASS: testGetIntegerTrait
Coverage: 100.0% of statements
```

For some more realistic contracts and tests:

```bash
bin/flow-x86_64-linux- test --cover --coverprofile=coverage.json test_array_utils.cdc

Running tests...

Test results:
- PASS: testRange
- PASS: testTransform
- PASS: testIterate
- PASS: testMap
- PASS: testMapStrings
- PASS: testReduce
Coverage: 90.6% of statements
```

Look at the files `ArrayUtils.cdc` (smart contract) and `test_array_utils.cdc` (tests for the smart contract). For the `ArrayUtils.range` method, we have omitted in purpose the branch where `start > end`. It is left as an exercise to the reader.

And also:

```bash
bin/flow-x86_64-linux- test --cover --coverprofile=coverage.json test_string_utils.cdc

Running tests...

Test results:
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
Coverage: 100.0% of statements
```

Look at the files `StringUtils.cdc` (smart contract) and `test_string_utils.cdc` (tests for the smart contract).
