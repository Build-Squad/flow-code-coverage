pub contract FooContract {

    pub fun getIntegerTrait(_ n: Int): String {
        if n < 0 {
            return "Negative"
        } else if n == 0 {
            return "Zero"
        } else if n < 10 {
            return "Small"
        } else if n < 100 {
            return "Big"
        } else if n < 1000 {
            return "Huge"
        }

        return "Enormous"
    }

}
