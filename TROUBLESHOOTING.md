# BizTracker Troubleshooting Guide

## Common Build Issues and Solutions

### 1. Namespace Error (Resolved with SQLite Migration)

**Status**: ✅ RESOLVED - Migrated from Isar to SQLite

**Previous Error**: `Namespace not specified. Specify a namespace in the module's build file`

**Solution Applied**: 
- Replaced Isar with SQLite database
- Eliminated all namespace issues
- Better compatibility with AGP 8.3.0+

**Current Database**: SQLite with comprehensive business data tables

### 2. Build Compatibility Issues

**Error**: `You can't rollout this release because it doesn't allow any existing users to upgrade`

**Solutions**:
- Use multi-architecture builds (already configured)
- Ensure universal APK support
- Run `./build_production.sh` for production builds

### 3. SQLite Database Setup

**Current Status**: ✅ Fully configured with SQLite

**Database Tables**:
- Business profiles
- Capital tracking
- Stock inventory
- Sales records
- Expenses tracking
- Profit analysis

**Setup Command**: `./migrate_to_sqlite.sh`

## Quick Fix Commands

### For Production Builds:
```bash
./build_production.sh
```

### For Testing SQLite Setup:
```bash
./test_sqlite_build.sh
```

### For SQLite Setup:
```bash
./migrate_to_sqlite.sh
```

## Prevention Tips

1. **Always test builds** before production deployment
2. **Use consistent dependency versions** across the project
3. **Keep Flutter SDK updated** but test thoroughly
4. **Monitor dependency updates** for breaking changes
5. **Use the provided scripts** for consistent builds

## Getting Help

If issues persist:
1. Check Flutter GitHub issues for similar problems
2. Review SQLite package documentation
3. Test with minimal example projects
4. Consider opening issues with package maintainers

## Current Configuration

- **Database**: SQLite 2.4.2
- **Gradle**: 8.6
- **AGP**: 8.3.0
- **Kotlin**: 1.9.22
- **Java**: 17

## Important Notes

- **SQLite Migration**: Successfully resolved all namespace issues
- **No Code Generation**: SQLite doesn't require build_runner
- **Better Compatibility**: Works seamlessly with AGP 8.3.0+
- **Standard Database**: Reliable, well-established database solution