use bytesize::ByteSize;
use comfy_table::Table;
use fs_extra::dir::get_size;
use glob::{glob_with, MatchOptions};
use std::collections::HashMap;

const PATTERNS: [&str; 6] = ["tsx", "ts", "md", "html", "map", "test.*"];

pub fn run(path: &str) {
    let mut table = Table::new();
    let mut data: HashMap<String, [u64; 2]> = HashMap::new();

    for pattern in PATTERNS {
        let mut total_size: u64 = 0;
        let mut total_count: u64 = 0;

        if let Ok(files) = glob_with(
            &format!("{}/**/*.{}", path, pattern),
            MatchOptions {
                case_sensitive: false,
                require_literal_separator: true,
                require_literal_leading_dot: true,
            },
        ) {
            for file in files {
                if let Ok(size) = get_size(file.unwrap()) {
                    total_size += size;
                    total_count += 1;
                }
            }

            data.insert(pattern.to_string(), [total_size, total_count]);
        }
    }

    table.set_header(vec!["Pattern", "Files count", "Total size"]);

    let mut posible_space_to_free: u64 = 0;

    for (key, value) in &data {
        posible_space_to_free += value[0];
        table.add_row(vec![
            format!("*.{}", key),
            value[1].to_string(),
            ByteSize(value[0]).to_string(),
        ]);
    }

    println!("{table}");
    println!(
        "we can safely reduce the size of the node_modules folder by {}",
        ByteSize(posible_space_to_free).to_string()
    )
}
