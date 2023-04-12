# Code Coverage Support for Flow Emulator

## Requirements

Make sure that you have installed the minimum required version of `flow-cli`:

```bash
flow version

Version: v0.47.0
Commit: 388ea9cd23106e01894368e19ea7de7278cad60a
```

To install it, simply run:

```bash
sh -ci "$(curl -fsSL https://raw.githubusercontent.com/onflow/flow-cli/master/install.sh)" -- v0.47.0
```

To view coverage results when running our tests, we can use:

```bash
flow test --cover test_foo_contract.cdc
```

The output will look something like this:

```bash
Running tests...

Test results: "test_foo_contract.cdc"
- PASS: testGetIntegerTrait
- PASS: testAddSpecialNumber
Coverage: 93.3% of statements
```

It looks like not all statements were covered by the test inputs. To view details for the coverage report,
we can consult the auto-generated `coverage.json` file:

```json
{
  "coverage": {
    "S.FooContract.cdc": {
      "line_hits": {
        "14": 1,
        "18": 9,
        "19": 1,
        "20": 8,
        "21": 1,
        "22": 7,
        "23": 1,
        "24": 6,
        "25": 1,
        "26": 5,
        "27": 0,
        "30": 5,
        "31": 4,
        "34": 1,
        "6": 1
      },
      "missed_lines": [
        27
      ],
      "statements": 15,
      "percentage": "93.3%"
    }
  },
  "excluded_locations": [
    "I.Crypto",
    "I.Test",
    "s.7465737400000000000000000000000000000000000000000000000000000000"
  ]
}
```

Note: We can use the `--coverprofile` flag if we wish to generate the coverage report to a different file.

```bash
flow test --cover --coverprofile=codecov.json test_foo_contract.cdc
```

Reading the JSON file, we can see that for `FooContract.cdc` the line `27` was missed during the tests (not covered by the test inputs).

To fix that, we can tweak the `testInputs` Dictionary on `test_foo_contract.cdc` to observe how the coverage percentage changes. By uncommenting the line `13`, we now get:

```bash
flow test --cover test_foo_contract.cdc

Running tests...

Test results: "test_foo_contract.cdc"
- PASS: testGetIntegerTrait
- PASS: testAddSpecialNumber
Coverage: 100.0% of statements
```

For some more realistic contracts and tests:

```bash
flow test --cover test_array_utils.cdc

Running tests...

Test results: "test_array_utils.cdc"
- PASS: testRange
- PASS: testTransform
- PASS: testIterate
- PASS: testMap
- PASS: testMapStrings
- PASS: testReduce
Coverage: 90.6% of statements
```

Look at the files `ArrayUtils.cdc` (smart contract) and `test_array_utils.cdc` (tests for the smart contract). For the `ArrayUtils.range` method, we have omitted in purpose the branch where `start > end`. It is left as an exercise to the reader. Look at the comment on line 25 in `test_array_utils.cdc`.

Note that the above examples of tests could be best described as unit tests.

An example of integration tests can be found in the `test_string_utils.cdc` file, which tests the functionality of the `StringUtils.cdc` smart contract.

```bash
flow test --cover test_string_utils.cdc

Running tests...

Test results: "test_string_utils.cdc"
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
Coverage: 55.5% of statements
```

The generated `coverage.json` file is somewhat more elaborate, for integration tests. By viewing its content, we find the following keys:

- `A.01cf0e2f2f715450.ArrayUtils`
- `A.01cf0e2f2f715450.StringUtils`
- `A.0ae53cb6e3f42a79.FlowToken`
- `A.e5a8b7f23e8b548f.FlowFees`
- `A.ee82856bf20e2aa6.FungibleToken`
- `A.f8d6e0586b0a20c7.FlowServiceAccount`

and some other locations. The ones starting with `s.*` are scripts, while the ones starting with `t.*` are transactions.

The `ArrayUtils` smart contract is imported by `StringUtils`, that's why it was deployed on the integration tests, and that's why it is included in the resulting coverage report.

For viewing the coverage report of the `StringUtils` smart contract, we can just consult the value of the `A.01cf0e2f2f715450.StringUtils` key, in the `coverage.json` file.

The rest of the keys are system contracts that are always available in the Flow Emulator, which is utilized as the backend implementation for integration tests.
