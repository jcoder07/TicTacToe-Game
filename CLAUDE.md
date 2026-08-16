# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test

Use the `BuildProject` MCP tool (xcode-tools) to build. Use `RunAllTests` / `RunSomeTests` to run tests. Use `XcodeRefreshCodeIssuesInFile` for fast compiler diagnostics on a specific file.

## Architecture

The app uses a layered architecture with [Factory](https://github.com/hmlongco/Factory) for dependency injection.

**Layers (bottom → top):**

| Layer | Folder | Role |
|---|---|---|
| Domain | `Domain/` | Plain Swift types (enums, models) with no dependencies |
| Store | `Stores/` | `@MainActor` ObservableObjects that own and mutate state |
| ViewModel | `Core/*ViewModel.swift` | Bridges stores to views; uses `@Injected` to resolve stores |
| View | `Core/*View.swift` | SwiftUI views bound to their ViewModel |
| DI | `Extensions/Container+Registration.swift` | All Factory registrations in one place |

**Key patterns:**

- **State ownership:** Stores (`*LiveStore`) hold the single source of truth. ViewModels observe stores and expose data to views.
- **Dependency injection:** Factory's `Container` is extended in `Container+Registration.swift`. ViewModels resolve dependencies with `@Injected(\.propertyName)`. Stores are registered as `.singleton()` so the same instance is shared app-wide.
- **Actor isolation:** `AppModeLiveStore` is `@MainActor`. When registering a `@MainActor` type in Factory (which runs on a background context), use `MainActor.assumeIsolated { }` inside the factory closure.
- **App mode routing:** `AppMode` enum (`.gameSetup` / `.game`) drives top-level navigation. `AppModeView` is the root view and should switch between game setup and game screens based on this state.
