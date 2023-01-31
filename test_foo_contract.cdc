import FooContract from "./FooContract.cdc"

pub fun testGetIntegerTrait() {
    // Arrange
    let testInputs: {Int: String} = {
        -1: "Negative",
        0: "Zero",
        9: "Small",
        // TODO: Uncomment the line below, to see how code coverage changes
        // 99: "Big",
        // 999: "Huge",
        1001: "Enormous"
    }
    let foo = FooContract()

    for input in testInputs.keys {
        // Act
        let result = foo.getIntegerTrait(input)

        // Assert
        assert(result == testInputs[input])
    }
}
