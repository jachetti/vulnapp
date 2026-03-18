# VulnApp v2.0 - React Frontend

Modern React + TypeScript + Tailwind CSS frontend for the VulnApp container security testing platform.

## Features

- ✅ **Interactive Attack Grid** - Browse 24 attack scenarios organized by MITRE ATT&CK categories
- ✅ **Real-time Execution** - WebSocket streaming for live attack output
- ✅ **Split-View Panel** - Attack details alongside terminal output
- ✅ **MITRE Mappings** - Visual technique badges and descriptions
- ✅ **CrowdStrike Branding** - Professional dark theme with brand colors
- ✅ **Vulnerable Scenarios** - Interactive reverse shell form for LAN testing
- ✅ **Responsive Design** - Works on desktop, tablet, and mobile

## Technology Stack

- **React 18.3+** - Modern React with hooks
- **TypeScript** - Type-safe development
- **Vite 5.x** - Fast build tool and dev server
- **Tailwind CSS 3.x** - Utility-first CSS framework
- **WebSocket API** - Real-time communication

## Directory Structure

```
frontend/
├── src/
│   ├── components/          # React components
│   │   ├── Header.tsx              # Top navigation bar
│   │   ├── WelcomeSection.tsx      # Introduction section
│   │   ├── AttackCard.tsx          # Individual attack card
│   │   ├── AttackGrid.tsx          # Grid of attacks by category
│   │   ├── ExecutionPanel.tsx      # Split-view execution modal
│   │   ├── MitreBadge.tsx          # MITRE technique badge
│   │   └── VulnerableScenario.tsx  # Interactive reverse shell form
│   ├── hooks/
│   │   └── useWebSocket.ts         # WebSocket connection hook
│   ├── api/
│   │   └── attacks.ts              # API client functions
│   ├── types/
│   │   └── attack.types.ts         # TypeScript interfaces
│   ├── App.tsx                     # Root component
│   ├── main.tsx                    # Entry point
│   └── index.css                   # Global styles
├── public/                  # Static assets
├── index.html              # HTML shell
├── package.json            # Dependencies
├── tsconfig.json           # TypeScript config
├── tailwind.config.js      # Tailwind theme (CrowdStrike colors)
└── vite.config.ts          # Vite configuration
```

## Installation

### Prerequisites

- Node.js 18+ (or 20+)
- npm or yarn

### Install Dependencies

```bash
cd frontend
npm install
```

This will install:
- react & react-dom (^18.3.1)
- TypeScript (^5.4.5)
- Vite (^5.2.11)
- Tailwind CSS (^3.4.3)
- And dev dependencies

## Development

### Start Development Server

```bash
npm run dev
```

This starts Vite dev server on http://localhost:5173 with:
- Hot module replacement (HMR)
- Proxy to backend API on port 80
- Fast refresh

### Development with Backend

**Terminal 1 - Start Go backend:**
```bash
cd ..
sudo go run . -port 80
```

**Terminal 2 - Start React dev server:**
```bash
cd frontend
npm run dev
```

**Access:**
- Frontend: http://localhost:5173 (with API proxy)
- Backend: http://localhost (direct access)

## Build for Production

```bash
npm run build
```

This creates optimized production build in `dist/`:
- Minified JavaScript and CSS
- Code splitting
- Asset optimization
- Source maps (optional)

The build output goes to `dist/` which will be served by the Go backend at `/static/`.

## CrowdStrike Theme Colors

Tailwind is configured with CrowdStrike brand colors:

```javascript
colors: {
  'cs-dark': '#17161a',      // Main background
  'cs-darker': '#000000',    // Darker sections
  'cs-red': '#e01f3d',       // Primary accent
  'cs-gray': '#888888',      // Secondary text
  'cs-white': '#ffffff',     // Primary text
  'cs-success': '#10b981',   // Success states
  'cs-warning': '#f59e0b',   // Warning states
  'cs-error': '#ef4444',     // Error states
  'cs-info': '#3b82f6',      // Info badges
}
```

## Component Overview

### AttackGrid

Main component that displays all attacks organized by MITRE ATT&CK category:
- Category filtering
- Responsive grid layout
- Attack count badges

### AttackCard

Individual attack card showing:
- Attack name and description
- MITRE technique badges
- Severity indicator
- "NEW" badge for modern threats
- CVE badges
- Execute button

### ExecutionPanel

Full-screen modal with split view:
- **Left Panel:** Attack details, MITRE mappings, prerequisites, execution info
- **Right Panel:** Terminal-style output with real-time streaming
- Status indicators (running/completed/failed)
- Exit code and duration display

### VulnerableScenario

Interactive form for LAN-based reverse shell testing:
- Attacker IP input
- Port configuration
- Step-by-step instructions
- Result display

## API Integration

The frontend communicates with the Go backend via REST API and WebSocket:

### REST Endpoints

```typescript
GET  /api/attacks              // List all attacks
GET  /api/attacks/:id          // Get attack details
POST /api/attacks/:id/execute  // Execute attack
GET  /api/executions/:id       // Get execution status
GET  /api/health               // Health check
POST /api/vulnerable/reverse-shell  // Interactive scenarios
```

### WebSocket

```typescript
ws://localhost/api/executions/:id/stream?execution_id=:id
```

Real-time output streaming for live attack execution feedback.

## TypeScript Types

All types are defined in `src/types/attack.types.ts`:

- `AttackScenario` - Attack metadata
- `MitreTechnique` - MITRE ATT&CK technique
- `Execution` - Execution state
- `WebSocketMessage` - WebSocket messages
- And more...

## Custom Hooks

### useWebSocket

Manages WebSocket connection for real-time output:

```typescript
const { output, status, exitCode, duration, isConnected } = useWebSocket(url);
```

Features:
- Auto-reconnect
- Message parsing
- State management
- Error handling

## Responsive Design

The UI adapts to different screen sizes:
- **Desktop:** 3-column attack grid, full split-view panel
- **Tablet:** 2-column grid, responsive panel
- **Mobile:** 1-column grid, stacked panel views

## Browser Support

- Chrome/Edge 90+
- Firefox 88+
- Safari 14+
- Modern mobile browsers

## Troubleshooting

### Dev Server Won't Start

```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

### API Calls Fail

Check that the Go backend is running on port 80:
```bash
curl http://localhost/api/health
```

If the backend is on a different port, update `vite.config.ts`:
```typescript
proxy: {
  '/api': {
    target: 'http://localhost:8080',  // Change port
    changeOrigin: true,
  }
}
```

### Build Fails

Ensure TypeScript has no errors:
```bash
npm run lint
```

### WebSocket Connection Issues

Check browser console for errors. WebSocket URL should be:
```
ws://localhost/api/executions/:id/stream?execution_id=:id
```

For HTTPS, it auto-upgrades to `wss://`.

## Next Steps

After building the frontend:

1. **Build for production:**
   ```bash
   npm run build
   ```

2. **Copy dist to Docker:**
   The multi-stage Dockerfile will copy `frontend/dist/` to `/static/` in the container

3. **Test integration:**
   Build Docker image and verify the frontend is served by Go backend

## Development Tips

- Use React DevTools for debugging
- Check Network tab for API calls
- Monitor WebSocket frames in DevTools
- Use browser console for errors
- Vite HMR preserves state during development

## License

Same as parent project.
