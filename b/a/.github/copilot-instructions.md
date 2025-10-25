# GitHub Copilot Instructions

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Context

This is a Node.js TypeScript Express MongoDB JWT Authentication Backend project following a layered architecture pattern.

## Architecture Guidelines

- Follow the established layered architecture: `controllers/`, `services/`, `models/`, `routes/`, `middlewares/`, `database/`
- Use TypeScript with strict typing
- Follow Express.js best practices
- Use Mongoose for MongoDB operations
- Implement proper error handling and logging

## Code Style Preferences

- Use async/await instead of callbacks
- Prefer ES6+ features and modern JavaScript/TypeScript syntax
- Use proper TypeScript interfaces and types
- Follow consistent naming conventions (camelCase for variables, PascalCase for classes)
- Add appropriate JSDoc comments for complex functions

## Security Considerations

- Always hash passwords with bcrypt
- Use JWT tokens for authentication
- Validate and sanitize all input data
- Implement proper error responses without exposing sensitive information
- Use environment variables for sensitive configuration

## Error Handling

- Use try-catch blocks in async functions
- Return consistent error response format
- Log errors appropriately with different log levels
- Handle MongoDB validation errors properly

## Testing

- When creating test requests, use the established format in the `requests/` folder
- Include both success and error scenarios
- Test all validation rules and edge cases
