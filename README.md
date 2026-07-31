# latihan01_11

A new Flutter project.

## Getting Started

This repository is dedicated to developing a cross-platform application using the Flutter framework and the Dart programming language. The project focuses on delivering a responsive, intuitive, and efficient User Interface (UI) tailored for both Android and Web platforms. By leveraging Clean Architecture principles alongside the Android SDK toolchain and Google Chrome as the primary testing environments, this application is designed to ensure optimal performance, security, and long-term scalability.

# Commit

## Git Commit Guidelines

To maintain a clean, organized, and readable repository history, this project follows the **Conventional Commits** specification. Using a standardized commit format improves team collaboration, simplifies code reviews, and enables automated changelog generation.

## Commit Message Structure

Every commit message consists of a **type**, an optional **scope**, and a concise **description**:

text
<type>(<scope>): <description>

### Type

- feat: A new feature added to the application.

- fix: A bug fix resolving an issue or error.

- docs: Documentation-only changes (e.g., updates to README.md or code comments).

- refactor: Code restructuring that neither fixes a bug nor adds a feature.

- test: Adding or updating test cases (unit tests, integration tests).

- chore: Maintenance tasks, build configuration, or dependency updates.

### Scope

The scope specifies the context or part of the system affected by the commit examples:
- payment
- user-api
- auth
- hero-section

### Description

The description provides a short, imperative, present-tense summary of the change exmples:
- "add Google login support" instead of "added Google login support".

## Commit Standar Examples

### Frontend (UI)

- `git commit -m 'fix(hero_section) fixing shield icons not showing on mobile view'`

### Backend

- `git commit -m "refactor(product-service): simplify database query and user services api"`

### Features

- `git commit -m "feat(auth): add Google OAuth2 social login support"`