mod analyzer;
mod cleaner;

use clap::Parser;

#[derive(Parser, Debug)]
#[command(name = "nmz")]
#[command(version = "0.1")]
#[command(
    about = "A tool to analyze and clean up node_modules directories by removing unnecessary files"
)]
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
    } else {
        cleaner::run();
    }
}
