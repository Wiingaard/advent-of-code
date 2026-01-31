# Advent of Code 2025 - Methodology & Usage Guide

## Overview

This repository contains solutions for Advent of Code 2025 puzzles, implemented in Swift. The project includes utility scripts for downloading puzzle inputs, fetching puzzle descriptions, and submitting answers.

## Project Structure

```
2025/
├── aoc.swift              # Main utility: download puzzles & submit answers
├── download-input.swift   # Download input files for puzzles
├── day01/                 # Day 1 solutions and files
│   ├── day01.txt         # Input file
│   ├── day01.html        # Puzzle description
│   ├── solve-day01.swift # Part 1 solution
│   └── solve-day01-part2.swift # Part 2 solution
├── day02/                 # Day 2 solutions and files
│   └── ...
└── METHODOLOGY.md         # This file
```

## Methodology

### Workflow for Solving a New Day

1. **Download Input and Puzzle**
   ```bash
   swift download-input.swift <day>
   swift aoc.swift puzzle <day>
   ```

2. **Create Solution Directory**
   ```bash
   mkdir -p day<XX>
   mv day<XX>.txt day<XX>.html day<XX>/
   ```

3. **Analyze the Puzzle**
   - Read the puzzle description in `day<XX>.html`
   - Understand the requirements
   - Identify the input format

4. **Implement Part 1 Solution**
   - Create `solve-day<XX>.swift` in the day directory
   - Test with examples from the puzzle description
   - Run on actual input: `swift solve-day<XX>.swift`
   - Submit answer: `swift aoc.swift submit <day> 1 <answer>`

5. **Implement Part 2 Solution**
   - After Part 1 is accepted, download updated puzzle: `swift aoc.swift puzzle <day>`
   - Create `solve-day<XX>-part2.swift`
   - Test and verify logic
   - Run and submit: `swift aoc.swift submit <day> 2 <answer>`

6. **Organize and Commit**
   - Move all day-specific files to `day<XX>/` directory
   - Commit with descriptive message

### Solution Approach

1. **Read and Parse Input**
   - Always use `String(contentsOfFile:encoding:)` for file reading
   - Handle edge cases (empty lines, whitespace, etc.)
   - Validate input format

2. **Algorithm Design**
   - Break down the problem into clear steps
   - Use Swift's standard library effectively (String, Array, Set, Dictionary)
   - Consider performance for large inputs

3. **Testing**
   - Create test files with examples from puzzle description
   - Verify expected outputs match
   - Test edge cases

4. **Error Handling**
   - Validate input parsing
   - Handle invalid ranges, formats, etc.
   - Provide clear error messages

## Scripts Reference

### `download-input.swift`

Downloads the input file for a given day.

**Usage:**
```bash
swift download-input.swift <day>
```

**Example:**
```bash
swift download-input.swift 1    # Downloads day01.txt
```

**Details:**
- Day must be between 1-25
- Downloads from `https://adventofcode.com/2025/day/<day>/input`
- Saves as `day<XX>.txt` (zero-padded)
- Requires valid session cookie (hardcoded in script)

### `aoc.swift`

Main utility script for downloading puzzles and submitting answers.

**Usage:**
```bash
# Download puzzle description
swift aoc.swift puzzle <day>

# Submit an answer
swift aoc.swift submit <day> <level> <answer>
```

**Examples:**
```bash
swift aoc.swift puzzle 1                    # Download day 1 puzzle
swift aoc.swift submit 1 1 1168             # Submit part 1 answer
swift aoc.swift submit 1 2 7199             # Submit part 2 answer
```

**Details:**
- `puzzle` command: Downloads HTML puzzle description to `day<XX>.html`
- `submit` command: Submits answer and shows result (✓ correct, ✗ wrong, ⚠ rate limited)
- Automatically handles CSRF tokens if needed
- Provides helpful error messages

## Important Notes

### Session Cookie

The session cookie is **hardcoded** in both `aoc.swift` and `download-input.swift`. 

**To refresh your session cookie:**

1. Open Safari and go to https://adventofcode.com (make sure you're logged in)
2. Enable Developer menu: Safari → Settings → Advanced → Check "Show features for web developers"
3. Open Web Inspector: Safari → Develop → Show Web Inspector (Option + Command + I)
4. Go to Storage tab → Cookies → https://adventofcode.com
5. Find the "session" cookie and copy its Value
6. Replace the `SESSION_COOKIE` constant in both scripts

**Security Warning:** The session cookie is committed to the repository. This is intentional for convenience, but be aware that anyone with access to the repository can use your session.

### Running Scripts

- All scripts are executable Swift scripts (shebang: `#!/usr/bin/env swift`)
- Run from the repository root or the specific day directory
- Solution scripts expect input files in the same directory
- Scripts use relative paths, so run from the correct directory

### Common Issues

1. **"Operation not permitted" errors**
   - Swift compiler may need full filesystem access
   - Use `required_permissions: ['all']` when running as an agent

2. **Session cookie expired**
   - Error: HTTP 401 or 403
   - Solution: Refresh session cookie as described above

3. **Puzzle not available yet**
   - Error: HTTP 404
   - Solution: Wait until the puzzle is released (midnight EST)

4. **Rate limiting**
   - Error: "You gave an answer too recently"
   - Solution: Wait before submitting again (usually a few seconds)

### File Organization

- Each day has its own directory: `day<XX>/`
- Day-specific files stay in their directory
- Utility scripts (`aoc.swift`, `download-input.swift`) stay in root
- Input files: `day<XX>.txt`
- Puzzle descriptions: `day<XX>.html`
- Solutions: `solve-day<XX>.swift` and `solve-day<XX>-part2.swift`
- Tests: `test-day<XX>.swift` and `test-day<XX>-part2.swift`

## Agent Task Instructions

When running as an agent task from the web:

### Prerequisites
1. Ensure you're in the repository root: `/Users/martin.wiingaard/dev/advent-of-code/2025`
2. Verify session cookie is up to date in both utility scripts
3. Have network access for downloading puzzles/inputs

### Typical Agent Workflow

```bash
# 1. Download input and puzzle
swift download-input.swift <day>
swift aoc.swift puzzle <day>

# 2. Create day directory and organize files
mkdir -p day<XX>
mv day<XX>.txt day<XX>.html day<XX>/

# 3. Analyze puzzle (read day<XX>.html)

# 4. Create and test solution
cd day<XX>
# Create solve-day<XX>.swift
swift solve-day<XX>.swift

# 5. Submit answer
cd ..
swift aoc.swift submit <day> 1 <answer>

# 6. After part 1 accepted, get part 2
swift aoc.swift puzzle <day>
# Create solve-day<XX>-part2.swift
swift aoc.swift submit <day> 2 <answer>

# 7. Commit changes
git add day<XX>/
git commit -m "Add solution for Day <XX>"
```

### Permissions Required

When running as an agent:
- **Network access**: Required for downloading puzzles/inputs and submitting answers
- **Git write**: Required for committing changes
- **All permissions**: Recommended for Swift compilation (may need access to system directories)

### Error Handling

The scripts include error handling for:
- Invalid day numbers (must be 1-25)
- Network errors
- HTTP errors (404, 401, 403)
- File I/O errors
- Invalid input formats

All errors provide clear messages to help diagnose issues.

## Solution Patterns

### Common Swift Patterns Used

1. **File Reading**
   ```swift
   guard let content = try? String(contentsOfFile: "input.txt", encoding: .utf8) else {
       print("Error: Could not read input.txt")
       exit(1)
   }
   ```

2. **Input Parsing**
   ```swift
   let lines = content.trimmingCharacters(in: .whitespacesAndNewlines)
       .components(separatedBy: .newlines)
       .filter { !$0.isEmpty }
   ```

3. **Range Iteration**
   ```swift
   for value in start...end {
       // Process value
   }
   ```

4. **String Manipulation**
   ```swift
   let digits = String(number)
   let firstHalf = String(digits.prefix(length / 2))
   let secondHalf = String(digits.suffix(length / 2))
   ```

5. **Modular Arithmetic (for wrapping)**
   ```swift
   position = (position + offset + modulus) % modulus
   ```

## Tips for Efficient Solving

1. **Start with examples**: Always verify your logic with the provided examples before running on full input
2. **Test incrementally**: Test small parts of your solution as you build it
3. **Read carefully**: Pay attention to edge cases mentioned in the puzzle description
4. **Part 2 often builds on Part 1**: Look for patterns or extensions from Part 1
5. **Use descriptive variable names**: Makes code easier to understand and debug
6. **Add comments for complex logic**: Helps when revisiting solutions later

## Git Workflow

- Branch: `2025`
- Commit messages: Descriptive, include day number and parts solved
- Structure: One commit per day (or per part if solving separately)

Example commit message:
```
Add solution for Day 2

- Part 1: Find IDs with sequence repeated exactly twice
- Part 2: Find IDs with sequence repeated at least twice
```

## Future Improvements

Potential enhancements:
- [ ] Template script generator for new days
- [ ] Automated testing framework
- [ ] Performance benchmarking
- [ ] Solution visualization tools
- [ ] Leaderboard integration
