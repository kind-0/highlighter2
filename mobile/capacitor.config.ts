import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.highlighter.highlighter',
  appName: 'Highlighter',
  webDir: 'build',
  server: {
    androidScheme: 'https'
  }
};

export default config;
