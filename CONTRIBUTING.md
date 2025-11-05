# Contributing to Full Client E2E Testing Framework

Thank you for your interest in contributing to this project! We welcome all forms of contributions.

## 🤝 How to Contribute

### Bug Reports

If you find a bug, please:

1. Check [Issues](https://github.com/YOUR_USERNAME/full-client-e2e-testing/issues) to ensure it hasn't been reported
2. Create a new Issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Your environment info (OS, Python version, Node version, etc.)
   - Relevant error messages or screenshots

### Feature Requests

If you have an idea for a new feature:

1. Search Issues for similar suggestions
2. Create a new Feature Request Issue
3. Describe the feature and its purpose in detail
4. Provide use cases if possible

### Pull Requests

1. **Fork the Project**
   ```bash
   git clone https://github.com/YOUR_USERNAME/full-client-e2e-testing.git
   cd full-client-e2e-testing
   ```

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix
   ```

3. **Set Up Development Environment**
   ```bash
   # macOS/Linux
   ./setup.sh
   
   # Windows
   setup.bat
   ```

4. **Make Your Changes**
   - Follow existing code style
   - Add necessary tests
   - Update relevant documentation

5. **Test Your Changes**
   ```bash
   # Run tests for relevant platform
   python scripts/run_tests.py --platform mac --env dev
   
   # Or use pytest
   python3 -m pytest tests/python/ -v
   ```

6. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   # or
   git commit -m "fix: fix your bug description"
   ```

   Commit message format:
   - `feat:` New feature
   - `fix:` Bug fix
   - `docs:` Documentation updates
   - `test:` Test-related changes
   - `refactor:` Code refactoring
   - `chore:` Miscellaneous (dependency updates, etc.)

7. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Create a Pull Request**
   - Go to GitHub and create a PR
   - Fill in the PR template
   - Link related Issues (if any)

## 📋 Code Standards

### Python Code

- Follow [PEP 8](https://pep8.org/) style guide
- Use meaningful variable names
- Add appropriate comments and docstrings
- Keep functions concise (single responsibility principle)

### Robot Framework Tests

- Use clear test case names
- Add test documentation
- Keep keywords reusable
- Use variables and parameterization appropriately

### Documentation

- Use Markdown format
- Maintain consistency in bilingual content (Chinese/English)
- Ensure code examples are executable
- Update relevant documentation when modifying features

## 🧪 Testing Requirements

- New features must include tests
- Bug fixes should include regression prevention tests
- Ensure all tests pass before submitting PR
- Tests should be verified on relevant platforms

## 📝 Documentation Requirements

If your PR includes:
- New features: Update README.md and relevant guides
- API changes: Update documentation and examples
- Configuration changes: Update .env.example and instructions

## 🔍 Code Review Process

1. Maintainers will review your PR
2. May request changes or provide feedback
3. Please respond to review comments promptly
4. PR will be merged once all checks pass

## ❓ Need Help?

- Check [README.md](./README.md) for project overview
- Review platform-specific testing guides
- Ask questions in Issues
- Contact maintainers

## 📜 License

By submitting code, you agree to license your contributions under the MIT License.

---

Thank you for your contributions! 🎉
