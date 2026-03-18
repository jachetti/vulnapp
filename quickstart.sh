#!/bin/bash
# VulnApp v2.0 - Quick Start Script

echo "=================================================="
echo "  VulnApp v2.0 - Quick Start Guide"
echo "=================================================="
echo ""

# Check if we're in the right directory
if [ ! -d "frontend" ]; then
    echo "❌ Error: Run this script from the VulnApp root directory"
    exit 1
fi

echo "📦 Step 1: Install Frontend Dependencies"
echo "---------------------------------------------------"
cd frontend

if [ ! -d "node_modules" ]; then
    echo "Installing npm packages..."
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ npm install failed"
        exit 1
    fi
    echo "✅ Dependencies installed"
else
    echo "✅ Dependencies already installed"
fi

cd ..

echo ""
echo "🏗️  Step 2: Build Frontend for Production"
echo "---------------------------------------------------"
cd frontend
echo "Building React app..."
npm run build
if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi
echo "✅ Frontend built successfully"
echo "   Output: frontend/dist/"

cd ..

echo ""
echo "📊 Step 3: Verify Build"
echo "---------------------------------------------------"
if [ -d "frontend/dist" ]; then
    echo "✅ Build directory exists"
    ASSET_COUNT=$(find frontend/dist -type f | wc -l)
    BUILD_SIZE=$(du -sh frontend/dist | cut -f1)
    echo "   Files: $ASSET_COUNT"
    echo "   Size: $BUILD_SIZE"
else
    echo "❌ Build directory not found"
    exit 1
fi

echo ""
echo "=================================================="
echo "  ✅ Frontend Build Complete!"
echo "=================================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Start the backend server:"
echo "   sudo go run . -port 80"
echo ""
echo "2. Access the app:"
echo "   http://localhost"
echo ""
echo "OR"
echo ""
echo "1. Build Docker image:"
echo "   docker build -t vulnapp:2.0 ."
echo ""
echo "2. Run container:"
echo "   docker run -p 80:80 vulnapp:2.0"
echo ""
echo "3. Access the app:"
echo "   http://localhost"
echo ""
echo "=================================================="
