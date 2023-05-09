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

    Test.assert(err == nil)
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
    Test.assert(
        result.status == Test.ResultStatus.failed,
        message: result.error!.message
    )
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

    Test.assert(result.status == Test.ResultStatus.succeeded)
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
    Test.assert(
        result.status == Test.ResultStatus.failed,
        message: result.error!.message
    )
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

    Test.assert(result.status == Test.ResultStatus.succeeded)
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
    Test.assert(
        result.status == Test.ResultStatus.failed,
        message: result.error!.message
    )
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

    Test.assert(result.status == Test.ResultStatus.succeeded)
}

pub fun testViewVotes() {
    let code = Test.readFile("../scripts/view_votes.cdc")

    var result = blockchain.executeScript(code, [])
    var votes = (result.returnValue as! {Int: Int}?)!

    Test.assert(votes[0] == 0)
    Test.assert(votes[1] == 1)
}
