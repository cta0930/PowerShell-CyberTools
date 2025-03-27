## Contributing

Thank you for your interest in contributing! This repository is focused on PowerShell tools for cybersecurity analysts, helping streamline log parsing, alert triage, threat hunting, and incident response workflows.

## How to Contribute

### 1. **Fork the repo**
   Click the **Fork** button in the top-right corner of this page to create your own copy.

   Then, clone your fork locally:

   ```bash
   git clone https://github.com/your-username/PowerShell-CyberTools.git
   cd PowerShell-CyberTools
   ```

### 2. **Create a feature branch**

   ```bash
   git checkout -b feature/your-script-name
   ```

   This allows you to safely work on your script without affecting the main codebase.

### 3. **Add your script**

   - Place your script in the appropriate folder:
     - `ThreatHunting/`
     - `LogParsing/`
     - `AlertTriage/`
     - `DataEnrichment/`
     - `Utils/`
   - Ensure your script includes:
     - A `.SYNOPSIS` header comment
     - Parameter support and input validation
     - `try/catch` error handling where needed
     - Meaningful variable names and formatting

### 4. **Test before submitting**

   Run your script to ensure:
   - It works cleanly on Windows PowerShell and PowerShell Core
   - Inputs are handled gracefully
   - Output is readable and structured (`Format-Table`, `Export-Csv`, etc.)

### 5. **Commit and push**

   ```bash
   git add .
   git commit -m "Add new script: brief description"
   git push origin feature/your-script-name
   ```

### 6. **Submit a pull request**

   Go to your fork on GitHub and click “**Compare & pull request**”. Please include:
   - A short summary of what the script does
   - Example output or how it’s useful
   - Any dependencies (external APIs, modules)

## Guidelines

- ✅ Use `param()` for user input
- ✅ Use `[PSCustomObject]` for structured output
- ✅ Use `Format-Table` or `Export-Csv` for readability
- ✅ Add comments and documentation for future users
- ❌ Do not hardcode sensitive values (API keys, passwords)
- ❌ Do not include offensive or unethical code

## Attribution

If your script is based on a blog, research, or another open-source tool, **please credit them in the comments**.

### Security contributions

If your script relates to vulnerability detection, red teaming, or network forensics:
- Avoid anything that simulates or launches actual attacks unless contained in lab-safe form
- Clearly label any potentially destructive actions (like file deletion or service modification)

### If you need help?

Open a GitHub Issue or start a Discussion if:
- You're unsure where to place a script
- You want feedback before submitting
- You need help with PowerShell logic

---

## License

[MIT License](LICENSE)

---

Thank you for helping build better tools for defenders!