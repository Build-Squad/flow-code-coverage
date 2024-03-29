import Test

pub let blockchain = Test.newEmulatorBlockchain()
pub let admin = blockchain.createAccount()
pub let voter = blockchain.createAccount()

pub fun setup() {
    blockchain.useConfiguration(Test.Configuration({
        "../contracts/ApprovalVoting.cdc": admin.address
    }))

    let code = Test.readFile("../contracts/ApprovalVoting.cdc")
    let err = blockchain.deployContract(
        name: "ApprovalVoting",
        code: code,
        account: admin,
        arguments: []
    )

    Test.expect(err, Test.beNil())
}

pub fun testInitializeEmptyProposals() {
    let proposals: [String] = []
    let code = Test.readFile("../transactions/initialize_proposals.cdc")
    let tx = Test.Transaction(
        code: code,
        authorizers: [admin.address],
        signers: [admin],
        arguments: [proposals]
    )

    let result = blockchain.executeTransaction(tx)

    // Fails with error: pre-condition failed: Cannot initialize with no proposals
    Test.expect(result, Test.beFailed())
}

pub fun testInitializeProposals() {
    let proposals = [
        "Longer Shot Clock",
        "Trampolines instead of hardwood floors"
    ]
    let code = Test.readFile("../transactions/initialize_proposals.cdc")
    let tx = Test.Transaction(
        code: code,
        authorizers: [admin.address],
        signers: [admin],
        arguments: [proposals]
    )

    let result = blockchain.executeTransaction(tx)

    Test.expect(result, Test.beSucceeded())

    let typ = CompositeType("A.01cf0e2f2f715450.ApprovalVoting.ProposalsInitialized")!
    let events = blockchain.eventsOfType(typ)
    Test.assertEqual(1, events.length)
}

pub fun testProposalsImmutability() {
    let proposals = ["Add some more options"]
    let code = Test.readFile("../transactions/initialize_proposals.cdc")
    let tx = Test.Transaction(
        code: code,
        authorizers: [admin.address],
        signers: [admin],
        arguments: [proposals]
    )

    let result = blockchain.executeTransaction(tx)

    // Fails with error: pre-condition failed: Proposals can only be initialized once
    Test.expect(result, Test.beFailed())
}

pub fun testIssueBallot() {
    let code = Test.readFile("../transactions/issue_ballot.cdc")
    let tx = Test.Transaction(
        code: code,
        authorizers: [admin.address, voter.address],
        signers: [admin, voter],
        arguments: []
    )

    let result = blockchain.executeTransaction(tx)

    Test.expect(result, Test.beSucceeded())
}

pub fun testCastVoteOnMissingProposal() {
    let code = Test.readFile("../transactions/cast_vote.cdc")
    let tx = Test.Transaction(
        code: code,
        authorizers: [voter.address],
        signers: [voter],
        arguments: [2]
    )

    let result = blockchain.executeTransaction(tx)

    // Fails with error: pre-condition failed: Cannot vote for a proposal that doesn't exist
    Test.expect(result, Test.beFailed())
}

pub fun testCastVote() {
    let code = Test.readFile("../transactions/cast_vote.cdc")
    let tx = Test.Transaction(
        code: code,
        authorizers: [voter.address],
        signers: [voter],
        arguments: [1]
    )

    let result = blockchain.executeTransaction(tx)

    Test.expect(result, Test.beSucceeded())

    let typ = CompositeType("A.01cf0e2f2f715450.ApprovalVoting.VoteCasted")!
    let events = blockchain.eventsOfType(typ)
    Test.assertEqual(1, events.length)
}

pub fun testViewVotes() {
    let code = Test.readFile("../scripts/view_votes.cdc")

    let result = blockchain.executeScript(code, [])
    let votes = (result.returnValue as! {Int: Int}?)!

    let expected = {0: 0, 1: 1}
    Test.assertEqual(expected, votes)
}
