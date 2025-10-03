# 🧹 Node Modules Sanitizer

A blazing-fast tool to analyze and clean up `node_modules` directories by removing unnecessary files.

## 🎯 Why This Project?

### The Problem
`node_modules` directories often contain unnecessary files that bloat your project size:
- TypeScript source files (`.ts`, `.tsx`) that are only needed during development
- Documentation files (`.md`) and examples
- Source maps (`.map`) used for debugging
- Test files that aren't needed in production

### The Solution
This tool helps you identify and remove these files, which is especially useful for:

- **🐳 Docker Images** - Reduce Docker image size significantly by cleaning `node_modules` before building the image. Smaller images mean:
  - Faster deployment and scaling
  - Reduced storage costs
  - Quicker CI/CD pipelines
  - Lower bandwidth usage

- **☁️ Serverless Functions** - Stay within size limits and improve cold start times

- **💾 Storage Optimization** - Free up disk space on development machines and CI/CD runners

- **📦 Distribution** - Smaller package sizes for faster downloads and installations

### Real Impact
A typical `node_modules` folder can be reduced by **30-50%** by removing development-only files. For a 500MB `node_modules`, that's **150-250MB saved** per Docker image!

## ✨ Features

- 🔍 **Analyze** - Scan your `node_modules` to see how much space can be freed
- 🧹 **Clean** - Remove unnecessary files (`.ts`, `.tsx`, `.md`, `.html`, `.map`, test files)
- ⚡ **Fast** - Built with Rust for maximum performance
- 🛡️ **Safe** - Only removes non-essential files that aren't needed for runtime

## 📦 Installation

```bash
cargo install --path .
```

Or build from source:

```bash
cargo build --release
```

The binary will be available as `nmz` in `target/release/`.

## 🚀 Usage

### 🔍 Analyze mode

See how much space can be freed without making any changes:

```bash
nmz --analyze
```

With custom path:

```bash
nmz --analyze --path ./my-project/node_modules
```

### 🧹 Clean mode

Remove unnecessary files from `node_modules`:

```bash
nmz
```

With custom path:

```bash
nmz --path ./my-project/node_modules
```

## 🗑️ What gets removed?

The tool removes the following file types that are typically not needed in production:

- `*.ts` - TypeScript source files
- `*.tsx` - TypeScript JSX files
- `*.md` - Markdown documentation
- `*.html` - HTML files
- `*.map` - Source map files
- `*.test.*` - Test files

## 📊 Example output

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

## ⚡ Performance

Built with Rust and optimized for speed:
- 🔄 Parallel file processing with Rayon
- 🎯 Efficient glob pattern matching
- 🚀 LTO and strip optimizations enabled in release builds

## 📄 License

MIT

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
