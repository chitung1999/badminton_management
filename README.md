# Badminton Management

## Build release
```bash
flutter build web --release
```
## Deploy
- Replace icon: build\web\favicon.png
- Modify build\web\index.html:
-- Remove line 17 "<base href="/">"
-- <title>Badminton Management</title>
- Push to deploy_branch
