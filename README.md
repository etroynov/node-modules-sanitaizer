# Node Modules Sanitizer

A blazing-fast tool to analyze and clean up `node_modules` directories by removing unnecessary files.

## Features

- **Analyze** - Scan your `node_modules` to see how much space can be freed
- **Clean** - Remove unnecessary files (`.ts`, `.tsx`, `.md`, `.html`, `.map`, test files)
- **Fast** - Built with Rust for maximum performance
- **Safe** - Only removes non-essential files that aren't needed for runtime

## Installation

```bash
cargo install --path .
```

Or build from source:

```bash
cargo build --release
```

The binary will be available as `nmz` in `target/release/`.

## Usage

### Analyze mode

See how much space can be freed without making any changes:

```bash
nmz --analyze
```

With custom path:

```bash
nmz --analyze --path ./my-project/node_modules
```

### Clean mode

Remove unnecessary files from `node_modules`:

```bash
nmz
```

With custom path:

```bash
nmz --path ./my-project/node_modules
```

## What gets removed?

The tool removes the following file types that are typically not needed in production:

- `*.ts` - TypeScript source files
- `*.tsx` - TypeScript JSX files
- `*.md` - Markdown documentation
- `*.html` - HTML files
- `*.map` - Source map files
- `*.test.*` - Test files

## Example output

### Analyze mode:
```
┌──────────┬─────────────┬────────────┐
│ Pattern  │ Files count │ Total size │
├──────────┼─────────────┼────────────┤
│ *.ts     │ 1245        │ 45.2 MB    │
│ *.tsx    │ 342         │ 12.8 MB    │
│ *.md     │ 892         │ 3.4 MB     │
│ *.html   │ 156         │ 892.5 KB   │
│ *.map    │ 2341        │ 89.7 MB    │
│ *.test.* │ 567         │ 23.1 MB    │
└──────────┴─────────────┴────────────┘

we can safely reduce the size of the node_modules folder by 174.3 MB
```

## Performance

Built with Rust and optimized for speed:
- Parallel file processing with Rayon
- Efficient glob pattern matching
- LTO and strip optimizations enabled in release builds

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
