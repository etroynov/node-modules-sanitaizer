mod analyzer;

use clap::Parser;

#[derive(Parser, Debug)]
#[command(name = "my_utility")]
#[command(version = "1.0")]
#[command(about = "Simple CLI utility")]
struct Args {
    #[arg(long)]
    analyze: bool,

    #[arg(long)]
    path: Option<String>,
}

const ROOT_DIR_PATH: &str = "./node_modules";

fn main() {
    let args = Args::parse();
    let path = args.path.as_deref().unwrap_or(ROOT_DIR_PATH);

    if args.analyze {
        analyzer::run(&path);
    }

    println!("{:?}", args);
}
