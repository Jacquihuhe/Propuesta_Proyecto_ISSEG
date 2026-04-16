// Vercel Speed Insights Integration
// This script initializes Speed Insights for the application
// Using ES module import from CDN

// Import and initialize Speed Insights
import { injectSpeedInsights } from 'https://cdn.jsdelivr.net/npm/@vercel/speed-insights@2.0.0/+esm';

// Initialize Speed Insights
// This will automatically track page views and Web Vitals metrics
// Data is only collected in production (when deployed to Vercel)
injectSpeedInsights({
  // Debug mode is automatically enabled in development
  // Set to false to disable debug logging even in development
  debug: false
});

console.log('Vercel Speed Insights initialized');
