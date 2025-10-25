# Firebase Hosting Setup Guide

This guide will help you deploy the EyeBreak website to Firebase Hosting with automatic deployment on every push to the `main` branch.

## Prerequisites

- Firebase account (already logged in as chansocheatsok2001@gmail.com)
- GitHub repository with the EyeBreak project

## Setup Steps

### 1. Create or Select Firebase Project

You can either create a new project or use an existing one from your list:

**Option A: Create a new project via Firebase Console**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Name it "EyeBreak" (project ID will be auto-generated)
4. Follow the setup wizard

**Option B: Use an existing project**
Choose from your existing projects listed by `firebase projects:list`

### 2. Configure Firebase Project

Once you have a project, update the `.firebaserc` file in the `website/` directory:

```json
{
  "projects": {
    "default": "your-project-id"
  }
}
```

Replace `your-project-id` with your Firebase project ID.

### 3. Enable Firebase Hosting

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click on "Hosting" in the left sidebar
4. Click "Get Started" and follow the prompts

### 4. Generate Firebase Service Account

For GitHub Actions to deploy automatically, you need a service account key:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to "IAM & Admin" > "Service Accounts"
4. Click "Create Service Account"
5. Name it "github-actions" with description "For GitHub Actions deployment"
6. Grant it the "Firebase Hosting Admin" role
7. Click "Done"
8. Find the service account you just created
9. Click the three dots menu > "Manage Keys"
10. Click "Add Key" > "Create New Key"
11. Select "JSON" and click "Create"
12. Save the downloaded JSON file securely

### 5. Add GitHub Secrets

Add these secrets to your GitHub repository:

1. Go to your GitHub repository
2. Click "Settings" > "Secrets and variables" > "Actions"
3. Click "New repository secret" and add:

   **Secret 1: `FIREBASE_SERVICE_ACCOUNT`**
   - Name: `FIREBASE_SERVICE_ACCOUNT`
   - Value: Paste the entire contents of the service account JSON file

   **Secret 2: `FIREBASE_PROJECT_ID`**
   - Name: `FIREBASE_PROJECT_ID`
   - Value: Your Firebase project ID (e.g., "eyebreak-app")

### 6. Test Manual Deployment (Optional)

Before pushing, you can test manual deployment:

```bash
cd website
npm run build
firebase deploy --only hosting
```

### 7. Push to GitHub

Once everything is configured, simply push to the `main` branch:

```bash
git add .
git commit -m "Add Firebase hosting configuration"
git push origin main
```

The GitHub Action will automatically:
1. Detect changes in the `website/` directory
2. Install dependencies
3. Build the website
4. Deploy to Firebase Hosting

## Monitoring Deployments

- **GitHub Actions**: Check the "Actions" tab in your GitHub repository to see deployment status
- **Firebase Console**: Go to "Hosting" to see deployment history and live site

## Custom Domain (Optional)

To use a custom domain:

1. Go to Firebase Console > Hosting
2. Click "Add custom domain"
3. Follow the instructions to verify and configure DNS

## Files Created

- `website/firebase.json` - Firebase Hosting configuration
- `website/.firebaserc` - Firebase project configuration (needs your project ID)
- `.github/workflows/deploy-website.yml` - GitHub Actions workflow

## Workflow Triggers

The deployment workflow runs when:
- You push changes to the `main` branch that affect the `website/` directory
- You manually trigger it from GitHub Actions tab (workflow_dispatch)

## Build Output

The website builds to the `website/dist/` directory, which is what gets deployed to Firebase Hosting.

## Troubleshooting

**Build fails**: Check Node.js version in workflow (currently set to Node 20)
**Deploy fails**: Verify Firebase service account has correct permissions
**Site not updating**: Clear browser cache or check Firebase Console for deployment status

## Quick Commands

```bash
# Build locally
cd website && npm run build

# Preview locally
cd website && npm run preview

# Deploy manually
cd website && firebase deploy

# Check deployment status
firebase hosting:channel:list
```

## Support

- [Firebase Hosting Documentation](https://firebase.google.com/docs/hosting)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
