@testable import ScoreCard

extension RuleSet {
    static var `default`: RuleSet {
        RuleSet(gameType: .highScoreWins(0))
    }
}
