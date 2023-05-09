import ApprovalVoting from "ApprovalVoting.cdc"

// This script allows anyone to read the tallied votes for each proposal.

pub fun main(): {Int: Int} {
    return ApprovalVoting.votes
}
