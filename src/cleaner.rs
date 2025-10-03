use glob::{glob_with, MatchOptions};

use crate::config::PATTERNS;

pub fn run(path: &str) {
    let mut counter: i32 = 0;

    for pattern in PATTERNS {
        if let Ok(files) = glob_with(
            &format!("{}/**/*.{}", path, pattern),
            MatchOptions {
                case_sensitive: false,
                require_literal_separator: true,
                require_literal_leading_dot: true,
            },
        ) {
            for file in files {
                if let Ok(file) = file {
                    if let Err(e) = std::fs::remove_file(&file) {
                        eprintln!("Failed to remove {:?}: {}", file, e);
                    } else {
                        counter += 1;
                    }
                }
            }
        }
    }

    println!("total files removed: {}", counter);
}
