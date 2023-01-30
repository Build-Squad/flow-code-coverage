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
- PASS: testTrait
Coverage: 87.5% of statements
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
        "11": 1,
        "12": 0,
        "13": 1,
        "14": 0,
        "17": 1,
        "5": 4,
        "6": 1,
        "7": 3,
        "8": 1,
        "9": 2
      },
      "missed_lines": [
        14,
        12
      ],
      "statements": 11,
      "percentage": "81.8%"
    },
    "s.7465737400000000000000000000000000000000000000000000000000000000": {
      "line_hits": {
        "14": 1,
        "16": 1,
        "18": 4,
        "21": 4,
        "5": 1
      },
      "missed_lines": [],
      "statements": 5,
      "percentage": "100.0%"
    }
  }
}
```

Reading the JSON file, we can see that for the `FooContract.cdc` the lines `12`, `14` were missed during the tests (not covered by the test inputs).

To fix that, we can tweak the `testInputs` Dictionary on `test_foo_contract.cdc` to observe how the coverage percentage changes. By uncommenting the lines `10` and `11`, we now get:

```bash
bin/flow-x86_64-linux- test --cover test_foo_contract.cdc

Running tests...

Test results:
- PASS: testTrait
Coverage: 100.0% of statements
```

Note: If you are wondering where is the coverage for `"s.7465737400000000000000000000000000000000000000000000000000000000"` coming from, it is the coverage for the `test_foo_contract` test file, which is also written in Cadence.
