import StringUtils from "StringUtils.cdc"

pub(set) var stringUtils = StringUtils()

pub fun testFormat() {
    // Act
    var result = stringUtils.format("Hello, {name}!", {"name": "Peter"})

    // Assert
    assert(result == "Hello, Peter!")
}

pub fun testExplode() {
    // Act
    var result = stringUtils.explode("Hello!")

    // Assert
    var expected = ["H", "e", "l", "l", "o", "!"]
    for char in expected {
        assert(result.contains(char))
    }
}

pub fun testTrimLeft() {
    // Act
    var result = stringUtils.trimLeft("    Hello, World!")

    // Assert
    assert(result == "Hello, World!")

    // Act
    result = stringUtils.trimLeft("")

    // Assert
    assert(result == "")
}

pub fun testTrim() {
    // Act
    var result = stringUtils.trim("  Hello, World!")

    // Assert
    assert(result == "Hello, World!")
}

pub fun testReplaceAll() {
    // Act
    var result = stringUtils.replaceAll("Hello, World!", "l", "L")

    // Assert
    assert(result == "HeLLo, WorLd!")
}

pub fun testHasPrefix() {
    // Act
    var result = stringUtils.hasPrefix("Hello, World!", "Hell")

    // Assert
    assert(result)

    // Act
    result = stringUtils.hasPrefix("Hell", "Hello, World!")

    // Assert
    assert(result == false)
}

pub fun testHasSuffix() {
    // Act
    var result = stringUtils.hasSuffix("Hello, World!", "ld!")

    // Assert
    assert(result)

    // Act
    result = stringUtils.hasSuffix("ld!", "Hello, World!")

    // Assert
    assert(result == false)
}

pub fun testIndex() {
    // Act
    var result = stringUtils.index("Hello, Peter!", "Peter", 0)

    // Assert
    assert(result == 7)

    // Act
    result = stringUtils.index("Hello, Peter!", "Mark", 0)

    // Assert
    assert(result == nil)
}

pub fun testCount() {
    // Act
    var result = stringUtils.count("Hello, World!", "o")

    // Assert
    assert(result == 2)
}

pub fun testContains() {
    // Act
    var result = stringUtils.contains("Hello, World!", "orl")

    // Assert
    assert(result)

    // Act
    result = stringUtils.contains("Hello, World!", "wow")

    // Assert
    assert(result == false)
}

pub fun testSubstringUntil() {
    // Act
    var result = stringUtils.substringUntil("Hello, sir. How are you today?", ".", 0)

    // Assert
    assert(result == "Hello, sir")

    // Act
    result = stringUtils.substringUntil("Hello, sir!", ".", 0)

    // Assert
    assert(result == "Hello, sir!")
}

pub fun testSplit() {
    // Act
    var result = stringUtils.split("Hello,How,Are,You? Today", ",")

    // Assert
    var expected = ["Hello", "How", "Are", "You? Today"]
    for e in expected {
        assert(result.contains(e))
    }
}

pub fun testJoin() {
    // Act
    var result = stringUtils.join(["Hello", "How", "Are", "You", "Today?"], " ")

    // Assert
    assert(result == "Hello How Are You Today?")
}
