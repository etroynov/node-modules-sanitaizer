use glob::{glob_with, MatchOptions};

use crate::config::PATTERNS;

pub fn run(path: &str) {
    for pattern in PATTERNS {
        if let Ok(files) = glob_with(
            &format!("{}/**/*.{}", path, pattern),
            MatchOptions {
                case_sensitive: false,
                require_literal_separator: true,
                require_literal_leading_dot: true,
            },
        ) {
            println!("{:?}", files);
        }
    }
}
