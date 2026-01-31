# Quick Start Guide

## For Agent Tasks

### Solve a New Day

```bash
# 1. Download input and puzzle
swift download-input.swift <day>
swift aoc.swift puzzle <day>

# 2. Organize files
mkdir -p day<XX>
mv day<XX>.txt day<XX>.html day<XX>/

# 3. Create solution in day<XX>/solve-day<XX>.swift
# 4. Test and run
cd day<XX>
swift solve-day<XX>.swift

# 5. Submit
cd ..
swift aoc.swift submit <day> 1 <answer>

# 6. After part 1, get part 2
swift aoc.swift puzzle <day>
# Create solve-day<XX>-part2.swift
swift aoc.swift submit <day> 2 <answer>
```

### Common Commands

```bash
# Download input
swift download-input.swift <day>

# Download puzzle description
swift aoc.swift puzzle <day>

# Submit answer
swift aoc.swift submit <day> <level> <answer>

# Run solution
swift solve-day<XX>.swift
```

### Important Notes

- **Session Cookie**: Hardcoded in scripts. Update if you get 401/403 errors.
- **Permissions**: Use `required_permissions: ['all']` for agent tasks.
- **Directory**: Run from repo root or day directory.
- **Day Format**: Always zero-padded (day01, day02, etc.)

### File Locations

- Input: `day<XX>/day<XX>.txt`
- Puzzle: `day<XX>/day<XX>.html`
- Solutions: `day<XX>/solve-day<XX>.swift`
- Part 2: `day<XX>/solve-day<XX>-part2.swift`

See `METHODOLOGY.md` for detailed documentation.
