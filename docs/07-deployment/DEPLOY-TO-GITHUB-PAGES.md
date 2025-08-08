Here’s a step-by-step guide to build your Flutter project as a PWA and deploy it to GitHub Pages:

---

## 1. Build Flutter Web as a PWA

Flutter web projects are PWA-ready by default. To build:

```powershell
flutter build web --release
```

This will generate a `build/web/` directory containing your PWA assets.

---

## 2. Prepare for GitHub Pages

- Ensure your index.html and manifest.json are customized for your app (title, icons, theme color, etc.).
- If you want deep linking verification, place `assetlinks.json` and `apple-app-site-association` in .well-known.

---

## 3. Deploy to GitHub Pages

### Option 1: Deploy from `main` branch docs folder

1. Copy everything from `build/web/` to your repo’s docs folder.
2. Commit and push the changes.
3. In your GitHub repo settings, set Pages source to docs folder on `main` branch.

### Option 2: Deploy from `gh-pages` branch

1. Create a new orphan branch:
   ```powershell
   git checkout --orphan gh-pages
   ```
2. Remove all files except .git and copy contents of `build/web/` to root.
3. Commit and push:
   ```powershell
   git add .
   git commit -m "Deploy PWA to GitHub Pages"
   git push origin gh-pages --force
   ```
4. In GitHub repo settings, set Pages source to `gh-pages` branch.

---

## 4. Verify

- Visit your GitHub Pages URL (e.g., `https://<username>.github.io/<repo>/`)
- Test PWA installability and deep linking.

---

Let me know if you want automation scripts for this, or if you want me to copy the build output to docs for you!

---

# Add all the web files and commit to the gh-pages branch:
git add .

# Commit the PWA deployment:
git commit -m "🚀 Deploy"

# Push the gh-pages branch to GitHub for deployment
git push origin gh-pages --force

https://chakravartiraj.github.io/deep_link_demo/

---
