#!/bin/bash

# Firebase Hosting Quick Setup Script for EyeBreak Website

echo "🔥 Firebase Hosting Setup for EyeBreak"
echo "======================================="
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI not found. Installing..."
    npm install -g firebase-tools
else
    echo "✅ Firebase CLI is installed"
fi

# Check if logged in
echo ""
echo "Checking Firebase authentication..."
firebase login:list

echo ""
echo "📋 Your existing Firebase projects:"
echo ""
firebase projects:list

echo ""
echo "Choose an option:"
echo "1. Use an existing project"
echo "2. Create a new project (manual via Console)"
echo ""
read -p "Enter your choice (1 or 2): " choice

if [ "$choice" == "1" ]; then
    read -p "Enter your Firebase Project ID: " project_id
    
    # Update .firebaserc
    cat > .firebaserc << EOF
{
  "projects": {
    "default": "$project_id"
  }
}
EOF
    
    echo "✅ Updated .firebaserc with project ID: $project_id"
    
    # Test connection
    echo ""
    echo "Testing Firebase connection..."
    firebase use $project_id
    
    echo ""
    echo "🎉 Firebase setup complete!"
    echo ""
    echo "Next steps:"
    echo "1. Build the website: npm run build"
    echo "2. Test deploy: firebase deploy --only hosting"
    echo "3. Setup GitHub Actions (see docs/FIREBASE_DEPLOYMENT.md)"
    
elif [ "$choice" == "2" ]; then
    echo ""
    echo "📝 To create a new Firebase project:"
    echo "1. Go to https://console.firebase.google.com/"
    echo "2. Click 'Add Project'"
    echo "3. Name it 'EyeBreak'"
    echo "4. Enable Firebase Hosting"
    echo "5. Come back and run this script again with option 1"
else
    echo "Invalid choice. Exiting."
    exit 1
fi
