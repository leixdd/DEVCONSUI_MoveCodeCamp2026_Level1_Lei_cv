module portfolio::portfolio {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::string::String;

    /// Portfolio struct optimized for CLI-only deployment
    struct Portfolio has key, store {
        id: UID,
        name: String,
        course: String,
        school: String,
        about: String,
        linkedin_url: String,
        github_url: String,
        skills: String, // comma-separated string for CLI deployment
    }

    /// Create a new portfolio object
    public fun create_portfolio(
        sender: address,
        name: String,
        course: String,
        school: String,
        about: String,
        linkedin_url: String,
        github_url: String,
        skills: String, // single string now
        ctx: &mut TxContext
    ) {
        let portfolio = Portfolio {
            id: object::new(ctx),
            name,
            course,
            school,
            about,
            linkedin_url,
            github_url,
            skills,
        };
        transfer::transfer(portfolio, sender);
    }
}
