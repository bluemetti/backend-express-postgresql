import App from './app';

// Handle uncaught exceptions
process.on('uncaughtException', (error: Error) => {
  console.error('❌ Uncaught Exception:', error);
  process.exit(1);
});

// Handle unhandled promise rejections
process.on('unhandledRejection', (reason: unknown, promise: Promise<any>) => {
  console.error('❌ Unhandled Rejection at:', promise, 'reason:', reason);
  process.exit(1);
});

// Create application instance
const appInstance = new App();
const app = appInstance.getApp();

// Export for Vercel serverless
export default app;

// Start server for local development or non-serverless environments
if (process.env.NODE_ENV !== 'production' || !process.env.VERCEL) {
  appInstance.listen();
  
  // Graceful shutdown
  process.on('SIGTERM', () => {
    console.log('👋 SIGTERM received, shutting down gracefully');
    process.exit(0);
  });

  process.on('SIGINT', () => {
    console.log('👋 SIGINT received, shutting down gracefully');
    process.exit(0);
  });
}
